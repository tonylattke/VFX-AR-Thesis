//
//  ViewController+LU.swift
//  VFX-AR
//
//  Created by Tony Lattke on 08.02.18.
//  Copyright © 2018 HSB. All rights reserved.
//

import SceneKit
import ARKit

// Compare the proportion of sizes and return a value between 0 and 1
func sizeCompare(old: Float, new: Float) -> Float {
    let result = (old-abs(new-old))/old
    return result > 0 ? result : 0
}

extension ViewControllerVFXAR {
    
    func updateMarkIdTable() {
        
        var markMatchingPossibilities = [(UUID,[(UUID,Float)])]()
        
        for newMark in currentLUScene.marks {
            var markMatching = [(UUID,Float)]()
            
            // Matching
            for baseMark in (baseSessionScene?.marks)! {
                // Width vs Width & Height vs Height Comparison
                let widthWidthComparison = sizeCompare(old: baseMark.value.width, new: newMark.value.width)
                let heightHeightComparison = sizeCompare(old: baseMark.value.height, new: newMark.value.height)
                let averageComparison = (widthWidthComparison + heightHeightComparison)/2
                
                // Width vs Height & Height vs Width Comparison
                let widthHeightComparison = sizeCompare(old: baseMark.value.width, new: newMark.value.height)
                let heighWidthComparison = sizeCompare(old: baseMark.value.height, new: newMark.value.width)
                let averageComparisonOposite = (widthHeightComparison+heighWidthComparison)/2
                
                // Select best average comparison
                let sizeComparison = averageComparison > averageComparisonOposite ? averageComparison : averageComparisonOposite
                
                // Calculate comparison using size and position
                let comparisionLevel: Float
                if firstTimePositionCompare {
                    comparisionLevel = sizeComparison
                    firstTimePositionCompare = false
                } else {
                    let positionComparison =
                        calculatePosition(markIdTable: markIdTable,
                                          baseMark: baseMark.value,
                                          currentMark: newMark.value)
                    comparisionLevel =  sizeComparison/0.7 +
                                        positionComparison/0.3
                }
                
                // Add comparison level
                markMatching.append((baseMark.key, comparisionLevel))
            }
            
            // Sort
            markMatching.sort(by: { (arg0, arg1) -> Bool in
                return arg0.1 > arg1.1
            })
            
            // Add mark with matching values
            markMatchingPossibilities.append((newMark.key,markMatching))
        }
        
        // For each new mark order by the best matsching
        markMatchingPossibilities.sort { (a, b) -> Bool in
            if a.1.count > 0 && b.1.count == 0 {
                return true
            } else if a.1.count == 0 && b.1.count > 0 {
                return false
            } else if a.1.count > 0 && b.1.count > 0 {
                return a.1.first!.1 > b.1.first!.1
            }
            return true
        }
        
        // Setting the best matchs on the table
        var usedBaseMarks = initDictionaryUsedMarks(marks: (baseSessionScene?.marks)!)
        for possibility in markMatchingPossibilities {
            let bestMatchID = getTheBestAndNoUsed(baseMarks: possibility.1, dictionary: usedBaseMarks)
            if bestMatchID != nil {
                // Uncheck Old
                for mark in markIdTable {
                    if mark.value != nil && mark.value == bestMatchID {
                        markIdTable[mark.key] = nil
                        currentLUScene.marks[mark.key]!.setNotUsed()
                    }
                }
                
                // Set new
                markIdTable[possibility.0] = bestMatchID!
                currentLUScene.marks[possibility.0]?.setUsed()
                usedBaseMarks[bestMatchID!] = true
            }
        }
    }
    
    func relocateObjects(){
        print("relocating.......")
        print("deltas")
        var deltas = [SCNVector3]()
        for markIdTuple in markIdTable {
            let currentMark = currentLUScene.marks[markIdTuple.key]
            if let baseMark = baseSessionScene?.marks[markIdTuple.value!] {
                let x = (currentMark?.nodeInSceneRelativPosition.x)! + (currentMark?.simdTransform.columns.3.x)! - baseMark.simdTransform.columns.3.x
                let y = (currentMark?.nodeInSceneRelativPosition.y)! + (currentMark?.anchor.transform.columns.3.y)! - baseMark.simdTransform.columns.3.y
                let z = (currentMark?.nodeInSceneRelativPosition.z)! + (currentMark?.simdTransform.columns.3.z)! - baseMark.simdTransform.columns.3.z
                
                let delta = SCNVector3(x,y,z)
                print("delta \(delta)")
                deltas.append(delta)
            }
        }
        
        if deltas.count > 0 {
            for object in currentLUScene.objects {
                print("obj \(object.loadedTransform)")
                // Posible positions
                var positions = [SCNVector3]()
                for delta in deltas {
                    var result = SCNVector3Zero
                    result.x = (object.loadedTransform?.columns.3.x)! + delta.x
                    result.y = (object.loadedTransform?.columns.3.y)! + delta.y
                    result.z = (object.loadedTransform?.columns.3.z)! + delta.z
                    print(result)
                    positions.append(result)
                }
                
                // Average postion
                var averagePosition = SCNVector3Zero
                let amountOfPositions = positions.count
                for position in positions {
                    averagePosition.x = averagePosition.x + position.x
                    averagePosition.y = averagePosition.y + position.y
                    averagePosition.z = averagePosition.z + position.z
                }
                averagePosition.x =  averagePosition.x / Float(amountOfPositions)
                averagePosition.y =  averagePosition.y / Float(amountOfPositions)
                averagePosition.z =  averagePosition.z / Float(amountOfPositions)
                
                // Set result
                object.simdTransform = matrix_multiply(matrix_identity_float4x4, object.loadedTransform!)
                object.simdTransform.columns.3.x = averagePosition.x
                object.simdTransform.columns.3.y = averagePosition.y
                object.simdTransform.columns.3.z = averagePosition.z
                object.isHidden = false
                
                let base = SCNBox(width: 0.1, height: 0.1, length: 0.1, chamferRadius: 0)
                let baseNode = SCNNode(geometry: base)
                baseNode.simdTransform = matrix_multiply(matrix_identity_float4x4, object.loadedTransform!)
                mainNodeScene.addChildNode(baseNode)
                
                print("final \(averagePosition)")
            }
        }
    }
    
}
