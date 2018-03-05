//
//  LUReferencePosition.swift
//  VFX-AR
//
//  Created by Tony Lattke on 07.02.18.
//  Copyright © 2018 HSB. All rights reserved.
//

import ARKit

struct LUComparedPair {
    var lessEqualThan: [UUID]
    var greaterThan: [UUID]
}

class LUReferencePosition {
    var x: LUComparedPair
    var y: LUComparedPair
    var z: LUComparedPair
    
    // Init - Creator
    init() {
        // X
        x = LUComparedPair(lessEqualThan: [UUID](), greaterThan: [UUID]())
        // Y
        y = LUComparedPair(lessEqualThan: [UUID](), greaterThan: [UUID]())
        // Z
        z = LUComparedPair(lessEqualThan: [UUID](), greaterThan: [UUID]())
    }
    
    // Init - Used to load data
    init(x: LUComparedPair, y: LUComparedPair, z: LUComparedPair) {
        self.x = x
        self.y = y
        self.z = z
    }
    
    // Update
    func update(mark: LUMark, marks: [UUID:LUMark]) {
        // X
        x = LUComparedPair(lessEqualThan: comparisonX(mark: mark, marks: marks, comparison: <=),
                         greaterThan: comparisonX(mark: mark, marks: marks, comparison: >))
        // Y
        y = LUComparedPair(lessEqualThan: comparisonY(mark: mark, marks: marks, comparison: <=),
                         greaterThan: comparisonY(mark: mark, marks: marks, comparison: >))
        // Z
        z = LUComparedPair(lessEqualThan: comparisonZ(mark: mark, marks: marks, comparison: <=),
                         greaterThan: comparisonZ(mark: mark, marks: marks, comparison: >))
    }
}

// Compare the X axis of the mark with the another marks using de gived comparison function
func comparisonX(mark: LUMark, marks: [UUID:LUMark], comparison: (Float,Float) -> Bool) -> [UUID] {
    var result = [UUID]()
    for otherMark in marks {
        if mark.id != otherMark.value.id &&
           comparison(otherMark.value.simdTransform.columns.3.x + otherMark.value.nodeInSceneRelativPosition.x, mark.simdTransform.columns.3.x) {
            result.appendUnique(newElement: otherMark.value.id)
        }
    }
    
    return result
}

// Compare the Y axis of the mark with the another marks using de gived comparison function
func comparisonY(mark: LUMark, marks: [UUID:LUMark], comparison: (Float,Float) -> Bool) -> [UUID] {
    var result = [UUID]()
    // Inspect all the marks
    for otherMark in marks {
        if mark.id != otherMark.value.id { // If it is not the same mark
            if (!mark.loaded && !otherMark.value.loaded && // They are no loaded marks
               comparison(otherMark.value.anchor.transform.columns.3.y + otherMark.value.nodeInSceneRelativPosition.y,
                          mark.anchor.transform.columns.3.y + mark.nodeInSceneRelativPosition.y)) ||
               (mark.loaded && otherMark.value.loaded &&  // They are loaded marks
               comparison(otherMark.value.simdTransform.columns.3.y + otherMark.value.nodeInSceneRelativPosition.y,
                          mark.simdTransform.columns.3.y + mark.nodeInSceneRelativPosition.y)) {
                result.appendUnique(newElement: otherMark.value.id)
            }
        }
    }
    
    return result
}

// Compare the Z axis of the mark with the another marks using de gived comparison function
func comparisonZ(mark: LUMark, marks: [UUID:LUMark], comparison: (Float,Float) -> Bool) -> [UUID] {
    var result = [UUID]()
    for otherMark in marks {
        if mark.id != otherMark.value.id &&
           comparison(otherMark.value.simdTransform.columns.3.z + otherMark.value.nodeInSceneRelativPosition.z, mark.simdTransform.columns.3.z + mark.nodeInSceneRelativPosition.z) {
            result.appendUnique(newElement: otherMark.value.id)
        }
    }
    return result
}

