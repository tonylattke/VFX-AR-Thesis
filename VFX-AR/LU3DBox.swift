//
//  LU3DObject.swift
//  VFX-AR
//
//  Created by Tony Lattke on 31.01.18.
//  Copyright © 2018 HSB. All rights reserved.
//

import Foundation
import ARKit
import SceneKit
import CoreLocation

public class LU3DBox: LUInteractivObject {
    
    // Init
    init(transform: simd_float4x4, width: CGFloat, height: CGFloat, length: CGFloat, chamferRadius: CGFloat) {
        super.init(className: "LU3DBox", transform: transform)

        geometry = SCNBox(width: width, height: height, length: length, chamferRadius: chamferRadius)
        
        // Create material
        let material = SCNMaterial()
        material.diffuse.contents = UIColor.green
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
