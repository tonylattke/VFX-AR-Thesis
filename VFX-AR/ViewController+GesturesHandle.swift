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

// Multiple Gestures available
extension ViewControllerVFXAR: UIGestureRecognizerDelegate {
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer,
                           shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
}

// Gestures
extension ViewControllerVFXAR {
    
    // Left to the right border
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
    
    // Right to the left border
    @IBAction func rightToLeftGestureHandle(_ sender: UIScreenEdgePanGestureRecognizer) {
        switch appMode {
        case .idle:
            // Show settings Menu
            if sender.state == .began && !settingsMenuIsShowing && !effectsMenuIsShowing {
                showSettingsMenu()
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
    
    // Tap
    @IBAction func handleTapGesture(_ sender: UITapGestureRecognizer) {
        switch appMode {
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
    
}
