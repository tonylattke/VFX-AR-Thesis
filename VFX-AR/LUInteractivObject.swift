//
//  LUInteractivObject.swift
//  VFX-AR
//
//  Created by Tony Lattke on 14.12.17.
//  Copyright © 2017 HSB. All rights reserved.
//

import Foundation
import ARKit
import SceneKit
import CoreLocation

public class LUInteractivObject: LUObject {
    
    // var model: SCNParticleSystem? // TODO
    var className: String?
    var loadedTransform: simd_float4x4?
    
    init(className: String, transform: simd_float4x4) {
        //model = SCNParticleSystem()
        self.className = className
        
        super.init(type: "InteractivObject")
        
        self.simdTransform = transform
    }
    
    // Init - Default coder
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
}
