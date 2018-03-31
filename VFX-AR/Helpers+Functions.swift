//
//  Helpers+Functions.swift
//  VFX-AR
//
//  Created by Tony Lattke on 08.02.18.
//  Copyright © 2018 HSB. All rights reserved.
//

import Foundation
import UIKit
import SwiftyJSON
import SceneKit

// From SCNMatrix4 to matrix_float4x4
func SCNMatrix4ToSimd_float4x4(sourceMatrix: SCNMatrix4) -> simd_float4x4 {
    var resultMatrix = simd_float4x4.init()
    
    // Column 0
    resultMatrix.columns.0.x = sourceMatrix.m11
    resultMatrix.columns.0.y = sourceMatrix.m12
    resultMatrix.columns.0.z = sourceMatrix.m13
    resultMatrix.columns.0.w = sourceMatrix.m14
    
    // Column 1
    resultMatrix.columns.1.x = sourceMatrix.m21
    resultMatrix.columns.1.y = sourceMatrix.m22
    resultMatrix.columns.1.z = sourceMatrix.m23
    resultMatrix.columns.1.w = sourceMatrix.m24
    
    // Column 2
    resultMatrix.columns.2.x = sourceMatrix.m31
    resultMatrix.columns.2.y = sourceMatrix.m32
    resultMatrix.columns.2.z = sourceMatrix.m33
    resultMatrix.columns.2.w = sourceMatrix.m34
    
    // Column 3
    resultMatrix.columns.3.x = sourceMatrix.m41
    resultMatrix.columns.3.y = sourceMatrix.m42
    resultMatrix.columns.3.z = sourceMatrix.m43
    resultMatrix.columns.3.w = sourceMatrix.m44
    
    return resultMatrix
}

// From SCNMatrix4 to matrix_float4x4
func simd_float4x4ToSCNMatrix4(sourceMatrix: simd_float4x4) -> SCNMatrix4 {
    var resultMatrix = SCNMatrix4()
    
    // Column 0
    resultMatrix.m11 = sourceMatrix.columns.0.x
    resultMatrix.m12 = sourceMatrix.columns.0.y
    resultMatrix.m13 = sourceMatrix.columns.0.z
    resultMatrix.m14 = sourceMatrix.columns.0.w
    
    // Column 1
    resultMatrix.m21 = sourceMatrix.columns.1.x
    resultMatrix.m22 = sourceMatrix.columns.1.y
    resultMatrix.m23 = sourceMatrix.columns.1.z
    resultMatrix.m24 = sourceMatrix.columns.1.w
    
    // Column 2
    resultMatrix.m31 = sourceMatrix.columns.2.x
    resultMatrix.m32 = sourceMatrix.columns.2.y
    resultMatrix.m33 = sourceMatrix.columns.2.z
    resultMatrix.m34 = sourceMatrix.columns.2.w
    
    // Column 3
    resultMatrix.m41 = sourceMatrix.columns.3.x
    resultMatrix.m42 = sourceMatrix.columns.3.y
    resultMatrix.m43 = sourceMatrix.columns.3.z
    resultMatrix.m44 = sourceMatrix.columns.3.w
    
    return resultMatrix
}

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

// Create UIImage
func getImageWithColor(color: UIColor, size: CGSize) -> UIImage {
    let rect = CGRect(x: 0, y: 0, width: size.width, height: size.height)
    UIGraphicsBeginImageContextWithOptions(size, false, 0)
    color.setFill()
    UIRectFill(rect)
    let image: UIImage = UIGraphicsGetImageFromCurrentImageContext()!
    UIGraphicsEndImageContext()
    return image
}

func updateDBFile(filenameDB: String, counterID: Int) {
    // Set URL of cache directory
    let documentsUrl =  FileManager.default.urls(for: .cachesDirectory, in: .userDomainMask).first! as NSURL
    // Adding filename DB
    let documentsPath = documentsUrl.appendingPathComponent(filenameDB)
    if let dbUrl = documentsPath {
        // ----------------------------- Reading -------------------------------
        do {
            let plaintText = try String(contentsOf: dbUrl, encoding: .utf8)
            if let dataFromString = plaintText.data(using: .utf8, allowLossyConversion: false) {
                do {
                    let jsonData = try JSON(data: dataFromString)
                    
                    // ------------------------ Save ---------------------------
                    
                    // Coding final json object
                    var json: JSON =  [
                        "currentSceneID": counterID
                    ]
                    json["scenes"] = jsonData["scenes"]
                    
                    // JSON to string
                    let text = json.rawString([.castNilToNSNull: true]) //just a text
                    //writing
                    do {
                        try text?.write(to: dbUrl, atomically: false, encoding: .utf8)
                        print("Save DB successful")
                    } catch {
                        print("Error saving DB")
                    }
                } catch {
                    print("json error")
                }
            }
        } catch {
            print("Cannot load DB")
        }
    }
}

func updateDBFile(filenameDB: String, newSceneFile: String, sceneId: Int) {
    var currentSceneID: Int = 0
    var scenes: [SceneInfo] = []
    
    // Set URL of cache directory
    let documentsUrl =  FileManager.default.urls(for: .cachesDirectory, in: .userDomainMask).first! as NSURL
    // Adding filename DB
    let documentsPath = documentsUrl.appendingPathComponent(filenameDB)
    if let dbUrl = documentsPath {
        // ----------------------------- Reading -------------------------------
        do {
            // Getting the data from File
            let plaintText = try String(contentsOf: dbUrl, encoding: .utf8)
            if let dataFromString = plaintText.data(using: .utf8, allowLossyConversion: false) {
                do {
                    let jsonData = try JSON(data: dataFromString)
                    
                    // Load scene id
                    currentSceneID = jsonData["currentSceneID"].intValue
                    
                    // Load scenes info
                    var existOnDB = false
                    for scene in jsonData["scenes"].arrayValue {
                        let loadedScene = JSONtoSceneInfo(data: scene)
                        if sceneId != loadedScene.id {
                            scenes.append(loadedScene)
                        } else {
                            existOnDB = true
                        }
                    }
                    
                    if !existOnDB {
                        let newScene = SceneInfo(id: sceneId, name: newSceneFile)
                        scenes.append(newScene)
                        
                        // ---------------------- Save -------------------------
                        
                        // Coding scenes
                        var scenesJSON: [JSON] = []
                        for scene in scenes {
                            let sceneJSON = SceneInfoToJSON(sceneInfo: scene)
                            scenesJSON.append(sceneJSON)
                        }
                        
                        // Coding final json object
                        let json: JSON =  [
                            "currentSceneID": currentSceneID,
                            "scenes": scenesJSON
                        ]
                        
                        // JSON to string
                        let text = json.rawString([.castNilToNSNull: true])
                        
                        //writing
                        do {
                            try text?.write(to: dbUrl, atomically: false, encoding: .utf8)
                            print("Save DB successful")
                        } catch {
                            print("Error saving DB")
                        }
                    }
                } catch {
                    print("Json error")
                }
            }
        } catch {
            print("Cannot load DB")
        }
    }

}
