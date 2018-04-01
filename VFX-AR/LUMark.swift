//
//  LUMark.swift
//  VFX-AR
//
//  Created by Tony Lattke on 14.12.17.
//  Copyright © 2017 HSB. All rights reserved.
//

import Foundation
import ARKit

public class LUMark: LUObject {
    
    let id: UUID
    var width: Float
    var height: Float
    var anchor: ARPlaneAnchor!
    var planeGeometry: SCNPlane
    var loaded: Bool
    var references: LUReferencePosition
    var isBaseMark: Bool
    var nodeInSceneRelativPosition: SCNVector3
    
    // Init
    init(anchor: ARPlaneAnchor, node: SCNNode) {
        width = anchor.extent.x
        height = anchor.extent.z
        
        // Set ID
        id = anchor.identifier
        
        // Set anchor
        self.anchor = anchor
        
        // Set plane geometry
        self.planeGeometry = SCNPlane(width: CGFloat(anchor.extent.x),
                                      height: CGFloat(anchor.extent.z))
        
        // Create Material
        let material = SCNMaterial()
        material.transparency = 1
        material.diffuse.contents = UIColor.red
        planeGeometry.materials = [material]
        
        // Create plane
        let planeNode = SCNNode(geometry: planeGeometry)
        highlightNode(planeNode)
        
        // Transform
        // Set Rotation around X 90 degrees (pi/2)
        planeNode.transform = SCNMatrix4MakeRotation(Float(-Double.pi/2.0), 1.0, 0.0, 0.0)
        // Set Position
        planeNode.transform.m41 = anchor.center.x   // X
        planeNode.transform.m42 = 0                 // Y
        planeNode.transform.m43 = anchor.center.z   // Z
        
        loaded = false
        
        references = LUReferencePosition()
        
        isBaseMark = false
        
        nodeInSceneRelativPosition = node.position
        
        super.init(type: "Mark")
        // Add planeNode to node
        self.addChildNode(planeNode)
        
        planeNode.name = "LUMark"
    }

    // Init - Used to load data
    init(id: UUID, transform: simd_float4x4, width: Float, height: Float, references: LUReferencePosition) {
        self.id = id
        
        self.width = width
        self.height = height
        
        // Set plane geometry
        self.planeGeometry = SCNPlane(width: CGFloat(width),
                                      height: CGFloat(height))
        
        self.loaded = true
        
        self.references = references
        
        self.isBaseMark = true
        self.nodeInSceneRelativPosition = SCNVector3Zero
        
        super.init(type: "Mark")
        
        self.simdTransform = transform
        
        self.name = "LUMark"
    }
    
    // Init - Default coder
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // Update the position and size of Mark
    func update(anchor: ARPlaneAnchor, node: SCNNode) {
        width = anchor.extent.x
        height = anchor.extent.z
        
        // As the user moves around the extend and location of the plane
        // may be updated. We need to update our 3D geometry to match the
        // new parameters of the plane.
        self.planeGeometry.width = CGFloat(width)
        self.planeGeometry.height = CGFloat(height)
        
        //position = SCNVector3Make(anchor.center.x, 0, anchor.center.z)
        simdTransform.columns.3.x = anchor.center.x
        simdTransform.columns.3.z = anchor.center.z
        
        nodeInSceneRelativPosition = node.position
    }
    
    func setUsed() {
        // Change color
        planeGeometry.materials.first?.diffuse.contents = UIColor.blue
    }
    
    func setNotUsed() {
        // Change color
        planeGeometry.materials.first?.diffuse.contents = UIColor.red
    }
    
    func setAsBaseMark() {
        isBaseMark = true
        // Change color
        planeGeometry.materials.first?.diffuse.contents = UIColor.gray
    }
    
    func setAsNotBaseMark() {
        isBaseMark = false
        // Change color
        planeGeometry.materials.first?.diffuse.contents = UIColor.red
    }
}
