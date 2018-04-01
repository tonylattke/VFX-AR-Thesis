//
//  ViewController+TableView.swift
//  VFX-AR
//
//  Created by Tony Lattke on 21.11.17.
//  Copyright © 2017 HSB. All rights reserved.
//

import Foundation
import UIKit
import SceneKit
import ARKit

let distanceWithCamera: Float = -0.3

extension ViewControllerVFXAR: UITableViewDelegate, UITableViewDataSource {
    
    // Init tables
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        var count = 0
        
        if tableView == effectsMenu {
            count = optionsEffects.count
        }
        if tableView == settigsMenu {
            count = optionsSettings.count
        }
        
        return count
    }
    
    // Init cells
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell:UITableViewCell?
        
        if tableView == effectsMenu {
            cell = UITableViewCell(style: .default, reuseIdentifier: "cellEffects")
            cell?.textLabel?.text = optionsEffects[indexPath.row]
        }
        
        if tableView == settigsMenu {
            cell = UITableViewCell(style: .default, reuseIdentifier: "cellOptions")
            cell?.textLabel?.text = optionsSettings[indexPath.row]
        }
        
        return cell!
    }
    
    // Option selected
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // Effects
        if tableView == effectsMenu {
            let selectedEffect = optionsEffects[indexPath.row]
            
            guard let currentFrame = sceneView.session.currentFrame else {
                return
            }
            
            switch selectedEffect {
            case "Box":
                let box = LU3DBox(transform: calculatePositionOfObject(cameraTransform: currentFrame.camera.transform,
                                                                       distance: distanceWithCamera),
                                  width: 0.1, height: 0.1, length: 0.1, chamferRadius: 0)
                
                currentLUScene.objects.append(box)
                mainNodeScene.addChildNode(box)
            case "Text":
                let text = LUText(transform:  calculatePositionOfObject(cameraTransform: currentFrame.camera.transform,
                                                                        distance: distanceWithCamera),
                                  message: "")
                
                currentLUScene.objects.append(text)
                mainNodeScene.addChildNode(text)
            default:
                print("TODO")
            }
            
            hideEffectsMenu()
            UIView.animate(withDuration: 0.2, animations: {self.view.layoutIfNeeded()})
        }
        
        // Settings
        if tableView == settigsMenu {
            let selectedOption = optionsSettings[indexPath.row]
            switch selectedOption {
            case "Translate":
                interactionMode = .position
                updateUIStatus(title: "Edit - Translation")
            case "Scale":
                interactionMode = .scale
                updateUIStatus(title: "Edit - Scale")
            case "Rotate":
                interactionMode = .rotation
                updateUIStatus(title: "Edit - Rotation")
            default:
                currentSelectedAttributeName = selectedOption
                currentSelectedAttributeType =  (selectedObject?.manageOptions(selectedOption: selectedOption))!
                
                switch currentSelectedAttributeType {
                case "String":
                    updateUIStatus(title: "Edit - Text")
                    textField.text = selectedObject?.getValue(attributeName: currentSelectedAttributeName)
                    textEditorView.isHidden = false
                default:
                    print("No implemented")
                }
            }
            
            hideSettingsMenu()
            UIView.animate(withDuration: 0.2, animations: {self.view.layoutIfNeeded()})
        }
    }

}


