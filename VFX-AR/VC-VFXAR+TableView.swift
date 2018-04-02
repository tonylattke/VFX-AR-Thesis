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
            case "Sparks":
                let sparks = LUSparks(transform: calculatePositionOfObject(cameraTransform: currentFrame.camera.transform,
                                                                           distance: distanceWithCamera),
                                      amountOfParticles: 1000)
                
                currentLUScene.objects.append(sparks)
                mainNodeScene.addChildNode(sparks)
            case "Rain":
                let rain = LURain(transform: calculatePositionOfObject(cameraTransform: currentFrame.camera.transform,
                                                                       distance: distanceWithCamera),
                                  amountOfParticles: 1000)
                
                currentLUScene.objects.append(rain)
                mainNodeScene.addChildNode(rain)
            case "Smoke":
                let smoke = LUSmoke(transform: calculatePositionOfObject(cameraTransform: currentFrame.camera.transform,
                                                                         distance: distanceWithCamera),
                                    amountOfParticles: 20)
                
                currentLUScene.objects.append(smoke)
                mainNodeScene.addChildNode(smoke)
            case "Fire":
                let fire = LUFire(transform: calculatePositionOfObject(cameraTransform: currentFrame.camera.transform,
                                                                       distance: distanceWithCamera),
                                  amountOfParticles: 455)
                
                currentLUScene.objects.append(fire)
                mainNodeScene.addChildNode(fire)
            case "3D Model":
                let model = LU3DModel(transform: calculatePositionOfObject(cameraTransform: currentFrame.camera.transform,
                                                                           distance: distanceWithCamera))
                
                currentLUScene.objects.append(model)
                mainNodeScene.addChildNode(model)
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
                showTranformAxisMenu()
                updateUIStatus(title: "Edit - Translation")
            case "Scale":
                interactionMode = .scale
                showTranformAxisMenu()
                updateUIStatus(title: "Edit - Scale")
            case "Rotate":
                interactionMode = .rotation
                showTranformAxisMenu()
                updateUIStatus(title: "Edit - Rotation")
            default:
                currentSelectedAttributeName = selectedOption
                currentSelectedAttributeType =  (selectedObject?.manageOptions(selectedOption: selectedOption))!
                let type = currentSelectedAttributeType?.name
                switch type! {
                case "String":
                    updateUIStatus(title: "Edit - Text")
                    textField.text = selectedObject?.getValue(attributeName: currentSelectedAttributeName)
                    showTextEditor()
                case "Float":
                    if let rangeNumber = currentSelectedAttributeType as? RangeNumber {
                        updateUIStatus(title: "Edit - Number")
                        let value = selectedObject?.getValue(attributeName: currentSelectedAttributeName)
                        numberSliderControl.value = Float(value!)!
                        numberSliderControl.minimumValue = rangeNumber.min
                        numberSliderControl.maximumValue = rangeNumber.max
                        showNumberEditor()
                    }
                default:
                    print("No implemented")
                }
            }
            
            hideSettingsMenu()
            UIView.animate(withDuration: 0.2, animations: {self.view.layoutIfNeeded()})
        }
    }

}


