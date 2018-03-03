//
//  Helpers+Functions.swift
//  VFX-AR
//
//  Created by Tony Lattke on 08.02.18.
//  Copyright © 2018 HSB. All rights reserved.
//

import Foundation

// Compare the base marks with the current marks
func baseMarksVSCurrentMarks(markIdTable: [UUID: UUID?], baseMarks: [UUID], currentMarks: [UUID]) -> Float {
    if baseMarks.count > 0 {
        var matched: Float = 0
        for baseMark in baseMarks {
            for currentMark in currentMarks {
                if markIdTable[currentMark] != nil &&
                    baseMark == markIdTable[currentMark]! {
                    matched = matched + 1
                }
            }
        }
        return matched/Float(baseMarks.count)
    }
    return 1 // It means that the mark match 100%, because it is alone
}

// Get the best matching mark and not used
func getTheBestAndNoUsed(baseMarks: [(UUID,Float)], dictionary: [UUID:Bool]) -> UUID? {
    for markTuple in baseMarks {
        if !dictionary[markTuple.0]! {
            return markTuple.0
        }
    }
    return nil
}

// Init the marks as not match
func initDictionaryUsedMarks(marks: [UUID:LUMark]) -> [UUID:Bool] {
    var result = [UUID:Bool]()
    for mark in marks {
        result[mark.key] = false
    }
    return result
}

// Calculate the match comparing the position of the current mark
func calculatePosition(markIdTable: [UUID: UUID?], baseMark: LUMark, currentMark: LUMark) -> Float {
    // X
    let letX = baseMarksVSCurrentMarks(markIdTable: markIdTable,
                                       baseMarks: baseMark.references.x.lessEqualThan,
                                       currentMarks: currentMark.references.x.lessEqualThan)
    let gtX = baseMarksVSCurrentMarks(markIdTable: markIdTable,
                                      baseMarks: baseMark.references.x.greaterThan,
                                      currentMarks: currentMark.references.x.greaterThan)
    // Y
    let letY = baseMarksVSCurrentMarks(markIdTable: markIdTable,
                                       baseMarks: baseMark.references.y.lessEqualThan,
                                       currentMarks: currentMark.references.y.lessEqualThan)
    let gtY = baseMarksVSCurrentMarks(markIdTable: markIdTable,
                                      baseMarks: baseMark.references.y.greaterThan,
                                      currentMarks: currentMark.references.y.greaterThan)
    // Z
    let letZ = baseMarksVSCurrentMarks(markIdTable: markIdTable,
                                       baseMarks: baseMark.references.z.lessEqualThan,
                                       currentMarks: currentMark.references.z.lessEqualThan)
    let gtZ = baseMarksVSCurrentMarks(markIdTable: markIdTable,
                                      baseMarks: baseMark.references.z.greaterThan,
                                      currentMarks: currentMark.references.z.greaterThan)
    
    return (letX + gtX + letY + gtY + letZ + gtZ)/6
}

// Filter base marks on the structure reference
func filterBaseMarkReferences(references: LUReferencePosition,
                              marks: [UUID : LUMark]) -> LUReferencePosition {
    // X
    let x = LUComparedPair(lessEqualThan: filterIDs(referenceIDs: references.x.lessEqualThan,
                                                    marks: marks),
                           greaterThan: filterIDs(referenceIDs: references.x.greaterThan,
                                                  marks: marks))
    // Y
    let y = LUComparedPair(lessEqualThan: filterIDs(referenceIDs: references.y.lessEqualThan,
                                                    marks: marks),
                           greaterThan: filterIDs(referenceIDs: references.y.greaterThan,
                                                  marks: marks))
    // Z
    let z = LUComparedPair(lessEqualThan: filterIDs(referenceIDs: references.z.lessEqualThan,
                                                    marks: marks),
                           greaterThan: filterIDs(referenceIDs: references.z.greaterThan,
                                                  marks: marks))
    
    return LUReferencePosition(x: x, y: y, z: z)
    
}

// Filter the base marks on the list referenceIDs
func filterIDs(referenceIDs: [UUID], marks: [UUID : LUMark]) -> [UUID] {
    var result = [UUID]()
    for markID in referenceIDs {
        if (marks[markID]?.isBaseMark)! {
            result.append(markID)
        }
    }
    
    return result
}
