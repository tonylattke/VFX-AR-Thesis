//
//  ViewController+ARPlanes.swift
//  VFX-AR
//
//  Created by Tony Lattke on 23.01.18.
//  Copyright © 2018 HSB. All rights reserved.
//

import Foundation
import UIKit
import SceneKit
import ARKit

extension ViewController {
    
    // Here you will have access to the news detected planes
    // To activate this function, you need in the session configuration: .planeDetection = .horizontal
    func renderer(_ renderer: SCNSceneRenderer, didAdd node: SCNNode, for anchor: ARAnchor) {
        guard let planeAnchor = anchor as? ARPlaneAnchor else {
            print(anchor)
            return
        }
        
        // When a new plane is detected we create a new SceneKit plane to visualize it in 3D
        let mark = LUMark(anchor: planeAnchor, node: node)
        currentLUScene.marks[anchor.identifier] = mark
        node.addChildNode(mark)
    }
    
    // If the plane have new dimmensions, it will be updated
    func renderer(_ renderer: SCNSceneRenderer, didUpdate node: SCNNode, for anchor: ARAnchor) {
        if !currentLUScene.marks.isEmpty {
            let mark = currentLUScene.marks[anchor.identifier]!
            guard let planeAnchor = anchor as? ARPlaneAnchor else { return }
            mark.update(anchor: planeAnchor, node: node)
        }
    }
    
    // The plane will be removed
    func renderer(_ renderer: SCNSceneRenderer, didRemove node: SCNNode, for anchor: ARAnchor) {
        if !currentLUScene.marks.isEmpty {
            currentLUScene.marks.removeValue(forKey: anchor.identifier)
        }
    }
    
}
