//
//  LUSparks.swift
//  VFX-AR
//
//  Created by Tony Lattke on 01.04.18.
//  Copyright © 2018 HSB. All rights reserved.
//

import Foundation
import ARKit
import SceneKit
import CoreLocation

public class LUSparks: LUInteractivObject {
    
    var particleSys: SCNParticleSystem? // TODO
    var amountOfParticles: Int = 0
    
    // Init
    init(transform: simd_float4x4, amountOfParticles: Int) {
        self.amountOfParticles = amountOfParticles
        
        super.init(className: "LUSparks", transform: transform, pivot: SCNMatrix4ToSimd_float4x4(sourceMatrix: SCNMatrix4Identity))
        
        
        
        optionsSettings["Amount of particle"] = "Int"
    }
    
    // Init - Default coder
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func updateAttribute(name: String, value: String) {
        switch name {
        case "Amount of particle":
            self.amountOfParticles = Int(value)!
        case "TODO":
            //self.attribute = value Float(value), Int(value)
            print("TODO")
        default:
            print("No available Attribute")
        }
    }
    
    override func getValue(attributeName: String) -> String {
        switch attributeName {
        case "Amount of particle":
            return "\(amountOfParticles)"
        default:
            return ""
        }
    }
    
}
