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

public class LUText: LUInteractivObject {
    
    var message: String
    
    // Init
    init(transform: simd_float4x4, message: String) {
        self.message = message
        
        super.init(className: "LUText", transform: transform, pivot: SCNMatrix4ToSimd_float4x4(sourceMatrix: SCNMatrix4Identity))
        
        // Anchor
        geometry = SCNSphere(radius: 0.1)
        geometry?.materials = [createPhongMaterial(color: UIColor.yellow)]
        
        optionsSettings["Edit Text"] = ValueType(name: "String", rangeType: "None")
    }
    
    // Init - Default coder
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func updateAttribute(name: String, value: String) {
        switch name {
        case "Edit Text":
            self.message = value
        default:
            print("No available Attribute")
        }
    }
    
    override func getValue(attributeName: String) -> String {
        switch attributeName {
        case "Edit Text":
            return message
        default:
            return ""
        }
    }
    
}
