//
//  ViewController+NavigationBars.swift
//  VFX-AR
//
//  Created by Tony Lattke on 21.11.17.
//  Copyright © 2017 HSB. All rights reserved.
//

import Foundation
import UIKit
import SceneKit
import ARKit

let settings_cameraSpeed: Float = 0.001

// Multiple Gestures available
extension ViewControllerVFXAR: UIGestureRecognizerDelegate {
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer,
                           shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
}

// Gestures
extension ViewControllerVFXAR {
    
    // MARK: Left to the right border
    @IBAction func leftToRightGestureHandle(_ sender: UIScreenEdgePanGestureRecognizer) {
        switch appMode {
        case .idle:
            // Show Effects Menu
            if sender.state == .began && !settingsMenuIsShowing && !effectsMenuIsShowing {
                showEffectsMenu()
            }
            
            // Hide settings Menu
            if settingsMenuIsShowing {
                hideSettingsMenu()
            }
            
            UIView.animate(withDuration: 0.2, animations: {self.view.layoutIfNeeded()})
        default:
            break // Do nothing
        }
    }
    
    // MARK: Right to the left border
    @IBAction func rightToLeftGestureHandle(_ sender: UIScreenEdgePanGestureRecognizer) {
        switch appMode {
        case .idle:
            if selectedObject != nil {
                // Show settings Menu
                if sender.state == .began && !settingsMenuIsShowing && !effectsMenuIsShowing {
                    showSettingsMenu()
                }
            }
            
            // Hide Effects Menu
            if effectsMenuIsShowing {
                hideEffectsMenu()
            }
            
            UIView.animate(withDuration: 0.2, animations: {self.view.layoutIfNeeded()})
        default:
            break // Do nothing
        }
    }
    
    // MARK: Tap gesture
    @IBAction func handleTapGesture(_ sender: UITapGestureRecognizer) {
        switch appMode {
        case .idle:
            let location = sender.location(in: sceneView)
            let hitResults = sceneView.hitTest(location, options: nil)
            if hitResults.count > 0 {
                let result = hitResults.first!
                if result.node.name == "InteractivObject" {
                    selectedObject = result.node as? LUInteractivObject
                    interactionMode = .none
                    // TODO
                    selectedObject?.createTransformBackup()
                    
                    // Update UI
                    setEditionModeUI()
                }
            } else {
                // Save transform and deselect object
                selectedObject?.saveCurrentState()
                selectedObject = nil
                
                interactionMode = .none
                // Update UI
                setIdleModeUI()
            }
        case .creation:
            let location = sender.location(in: sceneView)
            let hitResults = sceneView.hitTest(location, options: nil)
            if hitResults.count > 0 {
                let result = hitResults.first!
                if result.node.name == "LUMark" {
                    selectedLUMark = result.node.parent as? LUMark
                    showMarkOptions()
                }
            } else {
                selectedLUMark = nil
                hideMarkOptions()
            }
        default:
            break // Do nothing
        }
    }
    
    // MARK: Handle rotation gesture - Rotation
    @IBAction func rotationHandle(_ sender: UIRotationGestureRecognizer) {
        switch appMode {
        case .idle:
            if selectedObject != nil {
                if selectedObject?.name == "InteractivObject" {
                    switch interactionMode {
                    case .rotation:
                        switch interactionAxis {
                        case .x: // X
                            if (selectedObject?.rotationFirstTime)! {
                                sender.rotation = CGFloat((selectedObject?.rotateFactor.x)!)
                                selectedObject?.rotationFirstTime = false
                            } else {
                                let rotationValue = Float(sender.rotation)
                                selectedObject?.rotateFactor.x = rotationValue
                            }
                        case .y: // Y
                            if (selectedObject?.rotationFirstTime)! {
                                sender.rotation = CGFloat((selectedObject?.rotateFactor.y)!)
                                selectedObject?.rotationFirstTime = false
                            } else {
                                let rotationValue = Float(sender.rotation)
                                selectedObject?.rotateFactor.y = rotationValue
                            }
                        case .z: // Z
                            if (selectedObject?.rotationFirstTime)! {
                                sender.rotation = CGFloat((selectedObject?.rotateFactor.z)!)
                                selectedObject?.rotationFirstTime = false
                            } else {
                                let rotationValue = Float(sender.rotation)
                                selectedObject?.rotateFactor.z = rotationValue
                            }
                        default:
                            break
                        }
                        // Update transform
                        selectedObject?.updateTransform()
                        // Reset gesture
                        if sender.state == .ended {
                            selectedObject?.rotationFirstTime = true
                        }
                    default:
                        return
                    }
                }
            } else {
                //showAlert(message: "No object selected")
            }
        default:
            break // Do nothing
        }
    }
    
    // MARK: Handle pan gesture
    @IBAction func panHandle(_ sender: UIPanGestureRecognizer) {
        switch appMode {
        case .idle:
            if selectedObject != nil {
                if selectedObject?.name == "InteractivObject" {
                    let location = sender.translation(in: sceneView)
                    switch interactionMode {
                    case .position:
                        switch interactionAxis {
                        case .x: // X
                            selectedObject?.translateFactor.x = Float(location.x)*settings_cameraSpeed
                        case .y: // Y
                            selectedObject?.translateFactor.y = Float(location.y)*settings_cameraSpeed
                        case .z: // Z
                            selectedObject?.translateFactor.z = Float(location.y)*settings_cameraSpeed
                        default: // XY Axis
                            selectedObject?.translateFactor.x = Float(location.x)*settings_cameraSpeed
                            selectedObject?.translateFactor.y = Float(location.y)*settings_cameraSpeed
                        }
                        // Update transform
                        selectedObject?.updateTransform()
                        // Reset gesture
                        sender.setTranslation(CGPoint(x: 0, y: 0), in: sceneView)
                    default:
                        return
                    }
                }
            } else {
                //showAlert(message: "No object selected")
            }
        default:
            break // Do nothing
        }
    }
    
    // MARK: Handle pinch gesture - Scale object
    @IBAction func pinchHandle(_ sender: UIPinchGestureRecognizer) {
        switch appMode {
        case .idle:
            if selectedObject != nil {
                if selectedObject?.name == "InteractivObject" {
                    switch interactionMode {
                    case .scale:
                        switch interactionAxis {
                        case .x: // X
                            if (selectedObject?.scaleFirstTime)! {
                                sender.scale = CGFloat((selectedObject?.scaleFactor.x)!)
                                selectedObject?.scaleFirstTime = false
                            } else {
                                let scaleValue = Float(sender.scale)
                                selectedObject?.scaleFactor = SCNVector3(scaleValue,
                                                                         (selectedObject?.scaleFactor.y)!,
                                                                         (selectedObject?.scaleFactor.z)!)
                            }
                        case .y: // Y
                            if (selectedObject?.scaleFirstTime)! {
                                sender.scale = CGFloat((selectedObject?.scaleFactor.y)!)
                                selectedObject?.scaleFirstTime = false
                            } else {
                                let scaleValue = Float(sender.scale)
                                selectedObject?.scaleFactor = SCNVector3((selectedObject?.scaleFactor.x)!,
                                                                         scaleValue,
                                                                         (selectedObject?.scaleFactor.z)!)
                            }
                        case .z: // Z
                            if (selectedObject?.scaleFirstTime)! {
                                sender.scale = CGFloat((selectedObject?.scaleFactor.z)!)
                                selectedObject?.scaleFirstTime = false
                            } else {
                                let scaleValue = Float(sender.scale)
                                selectedObject?.scaleFactor = SCNVector3((selectedObject?.scaleFactor.x)!,
                                                                         (selectedObject?.scaleFactor.y)!,
                                                                         scaleValue)
                            }
                        default: // All axis
                            if (selectedObject?.scaleFirstTime)! {
                                sender.scale = 1
                                selectedObject?.scaleFirstTime = false
                            } else {
                                let scaleValue = Float(sender.scale*sender.velocity)*settings_cameraSpeed*10
                                selectedObject?.scaleFactor = SCNVector3((selectedObject?.scaleFactor.x)! + scaleValue,
                                                                         (selectedObject?.scaleFactor.y)! + scaleValue,
                                                                         (selectedObject?.scaleFactor.z)! + scaleValue)
                            }
                        }
                        // Update transform
                        selectedObject?.updateTransform()
                        // Reset gesture
                        if sender.state == .ended {
                            selectedObject?.scaleFirstTime = true
                        }
                    default:
                        return
                    }
                }
            } else {
                //showAlert(message: "No object selected")
            }
        default:
            break // Do nothing
        }
    }
    
}
