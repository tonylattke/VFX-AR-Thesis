//
//  LU3DModel.swift
//  VFX-AR
//
//  Created by Tony Lattke on 02.04.18.
//  Copyright © 2018 HSB. All rights reserved.
//

import ARKit
import SceneKit

public class LU3DModel: LUInteractivObject {
    
    // Init
    init(transform: simd_float4x4) {
        super.init(className: "LU3DModel", transform: transform, pivot: SCNMatrix4ToSimd_float4x4(sourceMatrix: SCNMatrix4Identity))
        
        geometry = SCNSphere(radius: 0.1)
        
        let shipScene = SCNScene(named: "ship.scn", inDirectory: "art.scnassets", options: nil)!
        self.addChildNode(shipScene.rootNode)
        
        // Create material
        let material = SCNMaterial()
        material.diffuse.contents = UIColor.magenta
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
