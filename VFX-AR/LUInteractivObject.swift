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
    
    // var model: SCNParticleSystem? // TODO
    var className: String?
    var loadedTransform: simd_float4x4?
    
    // Transformations
    var scaleFactor: SCNVector3 = SCNVector3()
    var rotateFactor: SCNVector3 = SCNVector3()
    var translateFactor: SCNVector3 = SCNVector3()
    
    // Transformation Backup
    var simdTransformBackup = simd_float4x4.init()
    
    // Edition controls
    var scaleFirstTime: Bool = true
    var rotationFirstTime: Bool = true
    
    init(className: String, transform: simd_float4x4) {
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
        
        // Translate
        translateFactor.x = 0
        translateFactor.y = 0
        translateFactor.z = 0
        
        self.simdTransform = transform
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
    
    func saveTransformBackup(){
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
        var rotateMatrix = SCNMatrix4Identity
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
    
}
