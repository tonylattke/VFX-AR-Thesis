//
//  ViewControllerHome.swift
//  VFX-AR
//
//  Created by Tony Lattke on 03.03.18.
//  Copyright © 2018 HSB. All rights reserved.
//

import UIKit
import SceneKit
import SwiftyJSON

let filenameDB = "database.json" //this is the file. I will write to and read from it

class ViewControllerHome: UIViewController {
    
    var currentSceneID: Int = 0
    var scenes: [SceneInfo] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Load DB
        loadDB()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Go to creation
        if let destination = segue.destination as? ViewControllerVFXAR  {
            destination.appStartMode = .creation
            destination.sceneID = currentSceneID
            
            // Update counter ID
            currentSceneID = currentSceneID + 1
            updateDBFile(filenameDB: filenameDB, counterID: currentSceneID)
            
            print("home - creation")
        }
    }
    
    // Save DB
    func saveDB() {
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
        let text = json.rawString([.castNilToNSNull: true]) //just a text
        
        // Accesing to file system
        if let dir = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first {
            // Setting URL
            let fileURL = dir.appendingPathComponent(filenameDB)
            
            //writing
            do {
                try text?.write(to: fileURL, atomically: false, encoding: .utf8)
                print("save successful")
            }
            catch {/* error handling here */}
        }
    }
    
    // Load DB
    func loadDB() {
        if let dir = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first {
            let fileURL = dir.appendingPathComponent(filenameDB)
            
            //reading
            do {
                let plaintText = try String(contentsOf: fileURL, encoding: .utf8)
                print(plaintText)
                if let dataFromString = plaintText.data(using: .utf8, allowLossyConversion: false) {
                    do {
                        let jsonData = try JSON(data: dataFromString)
                        // Load current scene ID
                        currentSceneID = jsonData["currentSceneID"].intValue
                        // Load scenes info
                        for scene in jsonData["scenes"].arrayValue {
                            scenes.append(JSONtoSceneInfo(data: scene))
                        }
                    } catch {
                        print("json error")
                    }
                }
            }
            catch {/* error handling here */}
        }
    }

}
