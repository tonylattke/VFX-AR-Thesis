//
//  ViewController+Buttons.swift
//  VFX-AR
//
//  Created by Tony Lattke on 24.01.18.
//  Copyright © 2018 HSB. All rights reserved.
//

import UIKit
import SceneKit
import ARKit
import CoreLocation
import FontAwesome_swift
import SwiftyJSON

extension ViewControllerVFXAR {
    
    // Reset
    @IBAction func resetButtonTouchDown(_ sender: UIButton) {
        // Remove marks
        currentLUScene.marks.removeAll()
        
        // Remove objects from scene
        for object in mainNodeScene.childNodes {
            object.removeFromParentNode()
        }
        
        // Remove objects
        currentLUScene.objects.removeAll()
        
        // Remove all MarkIds on table
        markIdTable.removeAll()
        
        // Reset start position GPS
        saveFirstCoordinates = false
        currentLUScene.positionGPS = nil
        
        firstTimePositionCompare = true
        
        baseSessionScene = nil
        
        // Reset session
        let configuration = ARWorldTrackingConfiguration()
        configuration.planeDetection = .horizontal
        configuration.worldAlignment = .gravityAndHeading
        sceneView.session.run(configuration, options: [.removeExistingAnchors,.resetTracking])
    }
    
    // Read
    @IBAction func readButtonTouchDown(_ sender: UIButton) {
        // Set URL of cache directory
        let documentsUrl =  FileManager.default.urls(for: .cachesDirectory, in: .userDomainMask).first! as NSURL
        // Adding filename DB
        let documentsPath = documentsUrl.appendingPathComponent(filenameToLoad)
        if let dbUrl = documentsPath {
            do {
                // Getting the data from File
                let plaintText = try String(contentsOf: dbUrl, encoding: .utf8)
                print(plaintText)
                // Text formating
                if let dataFromString = plaintText.data(using: .utf8, allowLossyConversion: false) {
                    do {
                        // Data to Json
                        let jsonData = try JSON(data: dataFromString)
                        
                        // Rebuild last session
                        let loadedSceneID = jsonData["id"].intValue
                        // - Initial position
                        let loadedBaseInitialPosition = jsonToCLLocation(data: jsonData["initialPosition"])
                        // - Description
                        let loadedDescription = jsonData["description"].stringValue
                        // - Marks
                        var loadedBaseMarks = [UUID: LUMark]()
                        for mark in jsonData["marks"].arrayValue {
                            let baseMark = JSONToLUMark(data: mark)
                            loadedBaseMarks[baseMark.id] = baseMark
                        }
                        // - Objects
                        var loadedBaseObjects = [LUInteractivObject]()
                        for object in jsonData["objects"].arrayValue {
                            let oldObject = JSONToLUInteractivObject(data: object)
                            loadedBaseObjects.append(oldObject)
                        }
                        
                        // Result
                        baseSessionScene = LUScene(id: loadedSceneID,
                                                   description: loadedDescription,
                                                   location: loadedBaseInitialPosition,
                                                   marks: loadedBaseMarks,
                                                   objects: loadedBaseObjects)
                        
                        for baseMark in (baseSessionScene?.marks)! {
                            markIdTable[baseMark.key] = nil
                        }
                        
                        updateMarkIdTable()
                        
                        for object in (baseSessionScene?.objects)! {
                            object.isHidden = true
                            currentLUScene.objects.append(object)
                            mainNodeScene.addChildNode(object)
                        }
                    } catch {
                        print("json error")
                    }
                }
            } catch {
                print("Cannot load DB")
            }
        }
    }
    
    // Write
    @IBAction func saveButtonTouchDown(_ sender: UIButton) {
        showTextEditor()
    }
    
    func saveScene(description: String) {
        if currentLUScene.positionGPS != nil {
            // Coding marks
            var marksJSON: [JSON] = []
            if baseSessionScene != nil {
                for mark in (baseSessionScene?.marks)! {
                    marksJSON.append(LUMarkToJSON(mark: mark.value))
                }
            } else {
                for mark in currentLUScene.marks {
                    if mark.value.isBaseMark {
                        let baseMarkReferences = filterBaseMarkReferences(references: mark.value.references,
                                                                          marks: currentLUScene.marks)
                        marksJSON.append(LUMarkToJSON(mark: mark.value,
                                                      references: baseMarkReferences))
                    }
                }
            }
            
            // Coding objects
            var objectsJSON: [JSON] = []
            for object in currentLUScene.objects {
                objectsJSON.append(LUInteractivObjectToJSON(object: object))
            }
            
            // Coding final json object
            let json: JSON =  [
                "id": currentLUScene.id,
                "initialPosition": CLLocationToJSON(location: currentLUScene.positionGPS!),
                "description": description,
                "marks": marksJSON,
                "objects": objectsJSON
            ]
            
            // JSON to string
            let text = json.rawString([.castNilToNSNull: true]) //just a text
            print(text)
            
            // Setting URL
            let documentsUrl =  FileManager.default.urls(for: .cachesDirectory, in: .userDomainMask).first! as NSURL
            let sceneFileName = "scene\(currentLUScene.id).json"
            // Adding filename to URL
            let documentsPath = documentsUrl.appendingPathComponent(sceneFileName)
            do {
                // Saving Scene
                try text?.write(to: documentsPath!, atomically: false, encoding: .utf8)
                print("save file successful")
                
                // Update DB
                updateDBFile(filenameDB: filenameDB, newSceneFile: sceneFileName, sceneId: currentLUScene.id)
            } catch {
                print("Cannot save scene")
            }
        }
    }
    
    // Check the mark as base mark
    @IBAction func checkBaseMarkAction(_ sender: UIButton) {
        if selectedLUMark != nil {
            selectedLUMark?.setAsBaseMark()
        }
    }
    
    // Uncheck the mark as base mark
    @IBAction func uncheckBaseMarkAction(_ sender: UIButton) {
        if selectedLUMark != nil {
            selectedLUMark?.setAsNotBaseMark()
        }
    }
    
    // Update appMode
    @IBAction func apModeControlChangeValueHandle(_ sender: UISegmentedControl) {
        switch sender.selectedSegmentIndex {
        case 0:
            appMode = .idle
            setIdleModeUI()
        case 1:
            appMode = .creation
            setCreationModeUI()
        case 2:
            appMode = .relocate
            setRelocateModeUI()
        default:
            break
        }
    }
    
    // Update selected Axis
    @IBAction func selectAxisInteration(_ sender: UISegmentedControl) {
        switch sender.selectedSegmentIndex {
        case 1:
            interactionAxis = .x
        case 2:
            interactionAxis = .y
        case 3:
            interactionAxis = .z
        default:
            interactionAxis = .all
        }
    }
    
    // Save edited text button handler
    @IBAction func editTextSaveHandle(_ sender: UIButton) {
        switch currentTextEditorMode {
        case .attributeEditor:
            selectedObject?.updateAttribute(name: currentSelectedAttributeName, value: textField.text!)
        case .sceneDescription:
            saveScene(description: textField.text!)
        }
        
        currentTextEditorMode = .sceneDescription
        
        currentSelectedAttributeName = ""
        currentSelectedAttributeType = nil
        
        hideTextEditor()
        updateUIStatus(title: "Edit Object")
        
        
        self.view.endEditing(true) // Hide Keyboard
    }
    
    // Cancel edited text button handler
    @IBAction func editTextCancelHandle(_ sender: UIButton) {
        currentSelectedAttributeName = ""
        currentSelectedAttributeType = nil
        
        hideTextEditor()
        updateUIStatus(title: "Edit Object")
        
        self.view.endEditing(true)
    }
    
    // Update number of slider on attribute of selected object
    @IBAction func numberSliderHandle(_ sender: UISlider) {
        selectedObject?.updateAttribute(name: currentSelectedAttributeName, value: String(numberSliderControl.value))
    }
    
    // Save edited number button handler
    @IBAction func saveNumberEditionHandle(_ sender: UIButton) {
        selectedObject?.updateAttribute(name: currentSelectedAttributeName, value: String(numberSliderControl.value))
        
        currentSelectedAttributeName = ""
        currentSelectedAttributeType = nil
        
        hideNumberEditor()
        updateUIStatus(title: "Edit Object")
    }
    
    // Cancel edited number button handler
    @IBAction func cancelNumberEditionHandle(_ sender: UIButton) {
        currentSelectedAttributeName = ""
        currentSelectedAttributeType = nil
        
        hideNumberEditor()
        updateUIStatus(title: "Edit Object")
    }
    
    // Save edited axis handler
    @IBAction func saveTransformAxisHandle(_ sender: UIButton) {
        // Save transform
        selectedObject?.saveCurrentState()
        
        interactionMode = .none
        
        hideTranformAxisMenu()
        updateUIStatus(title: "Edit Object")
    }
    
    // Cancel edited axis handler
    @IBAction func cancelTransformAxisHandle(_ sender: UIButton) {
        // Restore Backuo state
        selectedObject?.restoreBackupState()
        
        interactionMode = .none
        
        hideTranformAxisMenu()
        updateUIStatus(title: "Edit Object")
    }
    
    // Delete an selected Object
    @IBAction func handleDeleteButton(_ sender: UIButton) {
        if selectedObject != nil {
            // Remove of LUScene
            var i = 0
            while i < currentLUScene.objects.count {
                if currentLUScene.objects[i] == selectedObject! {
                    currentLUScene.objects.remove(at: i)
                    break
                } else {
                    i = i + 1
                }
            }
            
            // Remove of Scene
            i = 0
            while i < mainNodeScene.childNodes.count {
                if mainNodeScene.childNodes[i] == selectedObject! {
                    mainNodeScene.childNodes[i].removeFromParentNode()
                    break
                } else {
                    i = i + 1
                }
            }
            
            selectedObject = nil
            setIdleModeUI()
        }
    }
    
}
