//
//  Helpers+Classes.swift
//  VFX-AR
//
//  Created by Tony Lattke on 20.02.18.
//  Copyright © 2018 HSB. All rights reserved.
//

import Foundation
import UIKit
import SceneKit

// AppMode
public enum AppMode:Int {
    case idle = 0
    case creation = 1
    case relocate = 2
}

// AppMode
public enum AppStartMode:Int {
    case creation = 0
    case load = 1
}

// Interaction transform
public enum InteractionMode:Int {
    case none = 0
    case scale = 1
    case position = 2
    case rotation = 3
}

// Interaction Axis
public enum InteractionAxis:Int {
    case all = 0
    case x = 1
    case y = 2
    case z = 3
}

// SceneInfo
public class SceneInfo {
    let id: Int
    let name: String
    
    init(id: Int, name: String) {
        self.id = id
        self.name = name
    }
}

public class ValueType {
    let name: String
    let rangeType: String
    
    init(name: String, rangeType: String) {
        self.name = name
        self.rangeType = rangeType
    }
}

public class RangeNumber: ValueType {
    let min: Float
    let max: Float
    
    init(min: Float, max: Float) {
        self.min = min
        self.max = max
        super.init(name: "Float", rangeType: "RangeNumber")
    }
    
}
