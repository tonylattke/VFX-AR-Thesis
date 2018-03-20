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

// SceneInfo
public class SceneInfo {
    let id: Int
    let name: String
    
    init(id: Int, name: String) {
        self.id = id
        self.name = name
    }
}
