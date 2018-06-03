//
//  LUSmoke.swift
//  VFX-AR
//
//  Created by Tony Lattke on 01.04.18.
//  Copyright © 2018 HSB. All rights reserved.
//

import Foundation
import ARKit
import SceneKit

public class LUSmoke: LUInteractivObject {
    
    var particleSystem: SCNParticleSystem?
    
    // Init
    init(transform: simd_float4x4, amountOfParticles: Float) {
        super.init(className: "LUSmoke", transform: transform, pivot: SCNMatrix4ToSimd_float4x4(sourceMatrix: SCNMatrix4Identity))
        
        particleSystem = SCNParticleSystem(named: "Smoke", inDirectory: "art.scnassets")
        self.addParticleSystem(particleSystem!)
        particleSystem?.birthRate = CGFloat(amountOfParticles)
        
        // Create anchor
        geometry = SCNSphere(radius: 0.1)
        geometry?.materials = [createPhongMaterial(color: UIColor.cyan)]
        
        optionsSettings["Amount of particles"] = RangeNumber(min: 10, max: 100)
    }
    
    // Init - Default coder
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func updateAttribute(name: String, value: String) {
        switch name {
        case "Amount of particles":
            particleSystem?.birthRate = CGFloat(Float(value)!)
        default:
            print("No available Attribute")
        }
    }
    
    override func getValue(attributeName: String) -> String {
        switch attributeName {
        case "Amount of particles":
            let value = particleSystem?.birthRate
            return "\(value!)"
        default:
            return ""
        }
    }
    
}

