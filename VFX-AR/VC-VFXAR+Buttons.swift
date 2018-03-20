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
        if let dir = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first {
            
            let fileURL = dir.appendingPathComponent(filenameToLoad)
            
            //reading
            do {
                let plaintText = try String(contentsOf: fileURL, encoding: .utf8)
                print(plaintText)
                if let dataFromString = plaintText.data(using: .utf8, allowLossyConversion: false) {
                    do {
                        let jsonData = try JSON(data: dataFromString)
                        
                        // Rebuild last session
                        let loadedSceneID = jsonData["id"].intValue
                        // - Initial position
                        let loadedBaseInitialPosition = jsonToCLLocation(data: jsonData["initialPosition"])
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
                        baseSessionScene = LUScene(id: loadedSceneID, location: loadedBaseInitialPosition,
                                                   marks: loadedBaseMarks, objects: loadedBaseObjects)
                        
                        for baseMark in (baseSessionScene?.marks)! {
                            markIdTable[baseMark.key] = nil
                        }
                        
                        updateMarkIdTable()
                        
                        for object in (baseSessionScene?.objects)! {
                            object.isHidden = true
                            currentLUScene.objects.append(object)
                            mainNodeScene.addChildNode(object)
                        }
                        
                        print("load successful")
                    } catch {
                        print("json error")
                    }
                }
            }
            catch {/* error handling here */}
        }
    }
    
    // Write
    @IBAction func saveButtonTouchDown(_ sender: UIButton) {
        if currentLUScene.positionGPS != nil {
            // Coding marks
            var marksJSON: [JSON] = []
            for mark in currentLUScene.marks {
                if mark.value.isBaseMark {
                    let baseMarkReferences = filterBaseMarkReferences(references: mark.value.references,
                                                                      marks: currentLUScene.marks)
                    marksJSON.append(LUMarkToJSON(mark: mark.value,
                                                  references: baseMarkReferences))
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
                "marks": marksJSON,
                "objects": objectsJSON
            ]
            
            // JSON to string
            let text = json.rawString([.castNilToNSNull: true]) //just a text
            print(text)
            
            // Accesing to file system
            if let dir = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first {
                let sceneFileName = "scene\(currentLUScene.id).json"
                // Setting URL
                let fileURL = dir.appendingPathComponent(sceneFileName)
                
                //writing
                do {
                    try text?.write(to: fileURL, atomically: false, encoding: .utf8)
                    print("save file successful")
                    
                    updateDBFile(filenameDB: filenameDB, newSceneFile: sceneFileName, sceneId: currentLUScene.id)
                }
                catch {/* error handling here */}
            }
        }
    }
    
    @IBAction func checkBaseMarkAction(_ sender: UIButton) {
        if selectedLUMark != nil {
            selectedLUMark?.setAsBaseMark()
        }
    }
    
    @IBAction func uncheckBaseMarkAction(_ sender: UIButton) {
        if selectedLUMark != nil {
            selectedLUMark?.setAsNotBaseMark()
        }
    }
    
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
}
