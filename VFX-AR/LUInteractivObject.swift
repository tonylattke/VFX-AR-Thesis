//
//  LUInteractivObject.swift
//  VFX-AR
//
//  Created by Tony Lattke on 14.12.17.
//  Copyright © 2017 HSB. All rights reserved.
//

import Foundation
import ARKit
import SceneKit
import CoreLocation

public class LUInteractivObject: LUObject {
    
    var className: String?
    var loadedTransform: simd_float4x4?
    
    // Transformations
    var scaleFactor: SCNVector3 = SCNVector3()
    var rotateFactor: SCNVector3 = SCNVector3()
    var translateFactor: SCNVector3 = SCNVector3()
    
    // Transformation Backup
    var simdTransformBackup = simd_float4x4.init()
    var simdPivotBackup = simd_float4x4.init()
    
    // Edition controls
    var scaleFirstTime: Bool = true
    var rotationFirstTime: Bool = true
    
    // Options Settings [Name:Type]
    var optionsSettings: [String:ValueType] = [:]
    
    init(className: String, transform: simd_float4x4, pivot: simd_float4x4) {
        //model = SCNParticleSystem()
        self.className = className
        
        super.init(type: "InteractivObject")
        self.name = "InteractivObject"
        
        // Scale
        scaleFactor.x = 1
        scaleFactor.y = 1
        scaleFactor.z = 1
        
        // Rotation
        rotateFactor.x = 0
        rotateFactor.y = 0
        rotateFactor.z = 0
        
        simdPivotBackup = matrix_identity_float4x4
        
        // Translate
        translateFactor.x = 0
        translateFactor.y = 0
        translateFactor.z = 0
        
        self.simdTransform = transform
        self.simdPivot = pivot
    }
    
    // Init - Default coder
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func createTransformBackup(){
        // Column 0
        simdTransformBackup[0].x = simdTransform[0].x
        simdTransformBackup[0].y = simdTransform[0].y
        simdTransformBackup[0].z = simdTransform[0].z
        simdTransformBackup[0].w = simdTransform[0].w
        
        // Column 1
        simdTransformBackup[1].x = simdTransform[1].x
        simdTransformBackup[1].y = simdTransform[1].y
        simdTransformBackup[1].z = simdTransform[1].z
        simdTransformBackup[1].w = simdTransform[1].w
        
        // Column 2
        simdTransformBackup[2].x = simdTransform[2].x
        simdTransformBackup[2].y = simdTransform[2].y
        simdTransformBackup[2].z = simdTransform[2].z
        simdTransformBackup[2].w = simdTransform[2].w
        
        // Column 3
        simdTransformBackup[3].x = simdTransform[3].x
        simdTransformBackup[3].y = simdTransform[3].y
        simdTransformBackup[3].z = simdTransform[3].z
        simdTransformBackup[3].w = simdTransform[3].w
    }
    
    func saveCurrentState(){
        // --------------------------- Transform ---------------------------- //
        // Column 0
        simdTransformBackup[0].x = simdTransform[0].x
        simdTransformBackup[0].y = simdTransform[0].y
        simdTransformBackup[0].z = simdTransform[0].z
        simdTransformBackup[0].w = simdTransform[0].w
        
        // Column 1
        simdTransformBackup[1].x = simdTransform[1].x
        simdTransformBackup[1].y = simdTransform[1].y
        simdTransformBackup[1].z = simdTransform[1].z
        simdTransformBackup[1].w = simdTransform[1].w
        
        // Column 2
        simdTransformBackup[2].x = simdTransform[2].x
        simdTransformBackup[2].y = simdTransform[2].y
        simdTransformBackup[2].z = simdTransform[2].z
        simdTransformBackup[2].w = simdTransform[2].w
        
        // Column 3
        simdTransformBackup[3].x = simdTransform[3].x
        simdTransformBackup[3].y = simdTransform[3].y
        simdTransformBackup[3].z = simdTransform[3].z
        simdTransformBackup[3].w = simdTransform[3].w
        
        // ----------------------------- Pivot ------------------------------ //
        // Column 0
        simdPivotBackup[0].x = simdPivot[0].x
        simdPivotBackup[0].y = simdPivot[0].y
        simdPivotBackup[0].z = simdPivot[0].z
        simdPivotBackup[0].w = simdPivot[0].w
        
        // Column 1
        simdPivotBackup[1].x = simdPivot[1].x
        simdPivotBackup[1].y = simdPivot[1].y
        simdPivotBackup[1].z = simdPivot[1].z
        simdPivotBackup[1].w = simdPivot[1].w
        
        // Column 2
        simdPivotBackup[2].x = simdPivot[2].x
        simdPivotBackup[2].y = simdPivot[2].y
        simdPivotBackup[2].z = simdPivot[2].z
        simdPivotBackup[2].w = simdPivot[2].w
        
        // Column 3
        simdPivotBackup[3].x = simdPivot[3].x
        simdPivotBackup[3].y = simdPivot[3].y
        simdPivotBackup[3].z = simdPivot[3].z
        simdPivotBackup[3].w = simdPivot[3].w
        
        // ------------------------ Transform Factors ----------------------- //
        
        // Scale
        scaleFactor.x = 1
        scaleFactor.y = 1
        scaleFactor.z = 1
        
        // Rotation
        rotateFactor.x = 0
        rotateFactor.y = 0
        rotateFactor.z = 0
        
        // Translate
        translateFactor.x = 0
        translateFactor.y = 0
        translateFactor.z = 0
    }
    
    func updateTransform() {
        // Translate backup
        let positionBackup = SCNVector3(simdTransform[3].x,
                                        simdTransform[3].y,
                                        simdTransform[3].z)
        
        // Scale
        var scaleMatrix = simd_float4x4.init()
        scaleMatrix[0].x = scaleFactor.x
        scaleMatrix[1].y = scaleFactor.y
        scaleMatrix[2].z = scaleFactor.z
        scaleMatrix[3].w = 1
        
        // Apply scale transform
        simdTransform = matrix_multiply(simdTransformBackup, scaleMatrix)
        
        // Rotate
        var rotateMatrix = simd_float4x4ToSCNMatrix4(sourceMatrix: simdPivotBackup)
        rotateMatrix = SCNMatrix4Rotate(rotateMatrix, rotateFactor.x, 1, 0, 0)
        rotateMatrix = SCNMatrix4Rotate(rotateMatrix, rotateFactor.y, 0, 1, 0)
        rotateMatrix = SCNMatrix4Rotate(rotateMatrix, rotateFactor.z, 0, 0, 1)
        
        // Apply rotation Matrix
        simdPivot = SCNMatrix4ToSimd_float4x4(sourceMatrix: rotateMatrix)
        
        // Translate
        simdTransform[3].x = positionBackup.x + translateFactor.x
        simdTransform[3].y = positionBackup.y - translateFactor.y
        simdTransform[3].z = positionBackup.z + translateFactor.z
    }
    
    // Get type of attribute
    func manageOptions(selectedOption: String) -> ValueType {
        return optionsSettings[selectedOption]!
    }

    func updateAttribute(name: String, value: String) {
        
    }
    
    func getValue(attributeName: String) -> String {
        return ""
    }
}
