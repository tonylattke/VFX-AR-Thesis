//
//  LUText.swift
//  VFX-AR
//
//  Created by Tony Lattke on 29.03.18.
//  Copyright © 2018 HSB. All rights reserved.
//


import Foundation
import ARKit
import SceneKit
import CoreLocation

public class LUText: LUInteractivObject {
    
    var message: String
    
    // Init
    init(transform: simd_float4x4, message: String) {
        self.message = message
        
        super.init(className: "LUText", transform: transform, pivot: SCNMatrix4ToSimd_float4x4(sourceMatrix: SCNMatrix4Identity))
        
        geometry = SCNBox(width: 0.1, height: 0.1, length: 0.1, chamferRadius: 0)
        
        // Create material
        let material = SCNMaterial()
        material.diffuse.contents = UIColor.yellow
        material.transparency = 1
        material.lightingModel = .phong
        
        // Assign material
        geometry?.materials = [material]
    }
    
    // Init - Default coder
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
