//
//  LUScene.swift
//  VFX-AR
//
//  Created by Tony Lattke on 14.12.17.
//  Copyright © 2017 HSB. All rights reserved.
//

import Foundation
import SceneKit
import CoreLocation

public class LUScene {
    
    var id: Int
    var description: String
    var positionGPS: CLLocation? // float3???
    var objects: [LUInteractivObject]
    var marks: [UUID: LUMark]
    
    // Init
    init() {
        self.id = 0
        description = ""
        positionGPS = CLLocation()
        objects = [LUInteractivObject]()
        marks = [UUID: LUMark]()
    }
    
    // Init - Used to load data
    init(id: Int, description: String, location: CLLocation,
         marks: [UUID: LUMark], objects: [LUInteractivObject]) {
        self.id = id
        self.description = description
        self.positionGPS = location
        self.marks = marks
        self.objects = objects
    }
    
}


