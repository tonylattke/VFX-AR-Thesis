//
//  LUCoders.swift
//  VFX-AR
//
//  Created by Tony Lattke on 24.01.18.
//  Copyright © 2018 HSB. All rights reserved.
//

import UIKit
import SceneKit
import ARKit
import CoreLocation
import FontAwesome_swift
import SwiftyJSON

///////////////////////////// CLLocation - JSON ////////////////////////////////

// CLLocation to JSON
func CLLocationToJSON(location: CLLocation) -> [String:Double] {
    var result = [String:Double]()
    
    result["latitude"] = location.coordinate.latitude
    result["longitude"] = location.coordinate.longitude
    result["altitude"] = location.altitude
    
    return result
}

// JSON to CLLocation
func jsonToCLLocation(data: JSON) -> CLLocation {
    let result = CLLocation(coordinate: CLLocationCoordinate2D(latitude: data["latitude"].double!,
                                                               longitude: data["longitude"].double!),
                            altitude: data["altitude"].double!,
                            horizontalAccuracy: CLLocationAccuracy(),
                            verticalAccuracy: CLLocationAccuracy(),
                            timestamp: Date(timeIntervalSinceNow: 0))
    
    return result
}

/////////////////////////////// Matrix - JSON //////////////////////////////////

// simd_float4x4 to JSON
func simd_float4x4ToJSON(matrix: simd_float4x4) -> [[Float]] {
    var result = [[Float]]()
    
    // Column 0
    result.append([matrix[0].x,
                   matrix[0].y,
                   matrix[0].z,
                   matrix[0].w])
    
    // Column 1
    result.append([matrix[1].x,
                   matrix[1].y,
                   matrix[1].z,
                   matrix[1].w])
    
    // Column 2
    result.append([matrix[2].x,
                   matrix[2].y,
                   matrix[2].z,
                   matrix[2].w])
    
    // Column 3
    result.append([matrix[3].x,
                   matrix[3].y,
                   matrix[3].z,
                   matrix[3].w])
    
    return result
}

// JSON to simd_float4x4
func jsonToSimd_float4x4(data: JSON) -> simd_float4x4 {
    var result = simd_float4x4.init()
    
    // Column 0
    result[0].x = data[0][0].floatValue
    result[0].y = data[0][1].floatValue
    result[0].z = data[0][2].floatValue
    result[0].w = data[0][3].floatValue
    
    // Column 1
    result[1].x = data[1][0].floatValue
    result[1].y = data[1][1].floatValue
    result[1].z = data[1][2].floatValue
    result[1].w = data[1][3].floatValue
    
    // Column 2
    result[2].x = data[2][0].floatValue
    result[2].y = data[2][1].floatValue
    result[2].z = data[2][2].floatValue
    result[2].w = data[2][3].floatValue
    
    // Column 3
    result[3].x = data[3][0].floatValue
    result[3].y = data[3][1].floatValue
    result[3].z = data[3][2].floatValue
    result[3].w = data[3][3].floatValue
    
    return result
}

/////////////////////////////// LUMark - JSON //////////////////////////////////

// LUMark to JSON
func LUMarkToJSON(mark: LUMark, references: LUReferencePosition) -> JSON {
    let references: JSON = [
        "x": LUComparedPairToJSON(pair: references.x),
        "y": LUComparedPairToJSON(pair: references.y),
        "z": LUComparedPairToJSON(pair: references.z)
    ]
    
    var result: JSON = [
        "id": mark.id.uuidString,
        "transform": simd_float4x4ToJSON(matrix: mark.simdTransform),
        "width": mark.width,
        "height": mark.height,
        "references": references
    ]
    result["transform"][3][0] = JSON(mark.simdTransform.columns.3.x + mark.nodeInSceneRelativPosition.x)
    result["transform"][3][1] = JSON(mark.anchor.transform.columns.3.y)
    result["transform"][3][2] = JSON(mark.simdTransform.columns.3.z + mark.nodeInSceneRelativPosition.z)
    
    return result
}

// LUMark loaded to JSON
func LUMarkToJSON(mark: LUMark) -> JSON {
    let references: JSON = [
        "x": LUComparedPairToJSON(pair: mark.references.x),
        "y": LUComparedPairToJSON(pair: mark.references.y),
        "z": LUComparedPairToJSON(pair: mark.references.z)
    ]
    
    let result: JSON = [
        "id": mark.id.uuidString,
        "transform": simd_float4x4ToJSON(matrix: mark.simdTransform),
        "width": mark.width,
        "height": mark.height,
        "references": references
    ]
    
    return result
}

// JSON to LUMark
func JSONToLUMark(data: JSON) -> LUMark {
    let references = LUReferencePosition(x: JSONToLUComparedPair(data: data["references"]["x"]),
                                         y: JSONToLUComparedPair(data: data["references"]["y"]),
                                         z: JSONToLUComparedPair(data: data["references"]["z"]))
    return LUMark(id: UUID(uuidString: data["id"].stringValue)!,
                  transform: jsonToSimd_float4x4(data: data["transform"]),
                  width: data["width"].floatValue,
                  height: data["height"].floatValue,
                  references: references)
}

/////////////////////////// LUComparedPair - JSON //////////////////////////////

// ComparedPair to JSON
func LUComparedPairToJSON(pair: LUComparedPair) -> JSON {
    var resultLessEqualThan = [String]()
    for lt in pair.lessEqualThan {
        resultLessEqualThan.append(lt.uuidString)
    }
    
    var resultGreaterThan = [String]()
    for gt in pair.greaterThan {
        resultGreaterThan.append(gt.uuidString)
    }
    
    let result: JSON = [
        "<=": resultLessEqualThan,
        ">": resultGreaterThan
    ]
    return result
}

// JSON to ComparedPair
func JSONToLUComparedPair(data: JSON) -> LUComparedPair {
    var resultLessEqualThan = [UUID]()
    var resultGreaterThan = [UUID]()
    
    // <=
    for lt in data["<="].arrayValue {
        resultLessEqualThan.append(UUID(uuidString: lt.stringValue)!)
    }
    // >
    for gt in data[">"].arrayValue {
        resultGreaterThan.append(UUID(uuidString: gt.stringValue)!)
    }
    
    return LUComparedPair(lessEqualThan: resultLessEqualThan,
                        greaterThan: resultGreaterThan)
}

///////////////////////// LUInteractivObject - JSON ////////////////////////////

// LUInteractivObject to JSON
func LUInteractivObjectToJSON(object: LUInteractivObject) -> JSON {
    let result: JSON = [
        "transform": simd_float4x4ToJSON(matrix: object.simdTransform),
        "pivot": simd_float4x4ToJSON(matrix: object.simdPivot),
        "className": object.className,
        "subClassInfo": LUInteractiveObjectSubClassToJSON(object: object)
    ]
    
    return result
}

// JSON to LUInteractivObject
func JSONToLUInteractivObject(data: JSON) -> LUInteractivObject {
    let result: LUInteractivObject
    switch data["className"].string! {
    // LU3DBox
    case "LU3DBox":
        result = LU3DBox(transform: matrix_identity_float4x4,
                         width: CGFloat(data["subClassInfo"]["width"].floatValue),
                         height: CGFloat(data["subClassInfo"]["height"].floatValue),
                         length: CGFloat(data["subClassInfo"]["length"].floatValue),
                         chamferRadius: CGFloat(data["subClassInfo"]["chamferRadius"].floatValue))
    // LUText
    case "LUText":
        result = LUText(transform: matrix_identity_float4x4,
                        message: data["subClassInfo"]["message"].stringValue)
    // LUSparks
    case "LUSparks":
        result = LUSparks(transform: matrix_identity_float4x4,
                          amountOfParticles: data["subClassInfo"]["Amount of particles"].floatValue)
    // LURain
    case "LURain":
        result = LURain(transform: matrix_identity_float4x4,
                        amountOfParticles: data["subClassInfo"]["Amount of particles"].floatValue)
    // LUSmoke
    case "LUSmoke":
        result = LUSmoke(transform: matrix_identity_float4x4,
                         amountOfParticles: data["subClassInfo"]["Amount of particles"].floatValue)
    // LUFire
    case "LUFire":
        result = LUFire(transform: matrix_identity_float4x4,
                        amountOfParticles: data["subClassInfo"]["Amount of particles"].floatValue)
    // LU3DModel
    case "LU3DModel":
        result = LU3DModel(transform: matrix_identity_float4x4)
    // Otherwise
    default:
        result = LUInteractivObject(className: data["className"].string!,
                                    transform: jsonToSimd_float4x4(data: data["transform"]),
                                    pivot: jsonToSimd_float4x4(data: data["pivot"]))
    }
    result.loadedTransform = jsonToSimd_float4x4(data: data["transform"])
    result.simdPivot = jsonToSimd_float4x4(data: data["pivot"])
    result.simdPivotBackup = jsonToSimd_float4x4(data: data["pivot"])
    
    return result
}

// LUInteractiveObjectSubClass to JSON
func LUInteractiveObjectSubClassToJSON(object: LUInteractivObject) -> JSON {
    var result: JSON = []
    switch object.className {
    // LU3DObject
    case "LU3DBox":
        result = [
            "width": (object.geometry as! SCNBox).width,
            "height": (object.geometry as! SCNBox).height,
            "length": (object.geometry as! SCNBox).length,
            "chamferRadius": (object.geometry as! SCNBox).chamferRadius
        ]
    // LUText
    case "LUText":
        if let luText = object as? LUText {
            result = [
                "message": luText.message
            ]
        }
    // LUSparks
    case "LUSparks":
        if let luSparks = object as? LUSparks {
            result = [
                "Amount of particles": Float((luSparks.particleSystem?.birthRate)!)
            ]
        }
    // LURain
    case "LURain":
        if let luRain = object as? LURain {
            result = [
                "Amount of particles": Float((luRain.particleSystem?.birthRate)!)
            ]
        }
    // LUSmoke
    case "LUSmoke":
        if let luSmoke = object as? LUSmoke {
            result = [
                "Amount of particles": Float((luSmoke.particleSystem?.birthRate)!)
            ]
        }
    // LUFire
    case "LUFire":
        if let luFire = object as? LUFire {
            result = [
                "Amount of particles": Float((luFire.particleSystem?.birthRate)!)
            ]
        }
    // LU3DModel
    case "LU3DModel":
        if let lu3DModel = object as? LU3DModel {
            result = []
        }
    // Otherwise
    default:
        result = []
    }
    
    return result
}
