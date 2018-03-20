//
//  VC-Home+Coders.swift
//  VFX-AR
//
//  Created by Tony Lattke on 20.03.18.
//  Copyright © 2018 HSB. All rights reserved.
//

import SwiftyJSON

///////////////////////////// SceneInfo - JSON /////////////////////////////////

// JSON to SceneInfo
func JSONtoSceneInfo(data: JSON) -> SceneInfo {
    let result = SceneInfo(id: data["id"].intValue,
                           name: data["name"].stringValue)
    
    return result
}

// SceneInfo to JSON
func SceneInfoToJSON(sceneInfo: SceneInfo) -> JSON {
    let result: JSON = [
        "id": sceneInfo.id,
        "name": sceneInfo.name
    ]
    
    return result
}
