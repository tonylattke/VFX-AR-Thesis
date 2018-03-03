//
//  Helpers.swift
//  VFX-AR
//
//  Created by Tony Lattke on 09.01.18.
//  Copyright © 2018 HSB. All rights reserved.
//

import Foundation

// Double
extension Double {
    func toRadians() -> Double {
        return self * .pi / 180.0
    }
    
    func toDegrees() -> Double {
        return self * 180.0 / .pi
    }
}

// Float
extension Float {
    func toRadians() -> Float {
        return self * .pi / 180.0
    }
    
    func toDegrees() -> Float {
        return self * 180.0 / .pi
    }
}

// [UUID]
extension Array where Element == UUID {
    
    mutating func appendUnique(newElement: UUID){
        for element in self {
            if element == newElement {
                return
            }
        }
        self.append(newElement)
    }
    
}
