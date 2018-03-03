//
//  LUObject.swift
//  VFX-AR
//
//  Created by Tony Lattke on 14.12.17.
//  Copyright © 2017 HSB. All rights reserved.
//

import Foundation
import ARKit

public class LUObject: SCNNode {
    
    var positionGPS: float3?
    var type: String?
    // TODO: new variables
    
    init(type: String) {
        positionGPS = float3()
        
        super.init()
        
        self.type = type
    }
    
    // Init - Default coder
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
