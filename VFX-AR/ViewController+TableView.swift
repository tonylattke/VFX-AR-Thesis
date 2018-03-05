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
            let selectedEffect = identifiersEffects[indexPath.row]
            switch selectedEffect {
            case "Box":
                guard let currentFrame = sceneView.session.currentFrame else {
                    return
                }
                
                // Calculate position
                var translation = matrix_identity_float4x4
                translation.columns.3.z = -0.3
                translation = matrix_multiply(currentFrame.camera.transform, translation)
                
                let box = LU3DBox(transform: translation,
                                  width: 0.1, height: 0.1, length: 0.1, chamferRadius: 0)
                
                currentLUScene.objects.append(box)
                mainNodeScene.addChildNode(box)
            default:
                print("TODO")
            }
        }
        
        // Settings
        if tableView == settigsMenu {
            let selectedOption = identifiersSettings[indexPath.row]
            print(selectedOption)
        }
    }

}

