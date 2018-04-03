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
    @IBOutlet weak var tableViewScenes: UITableView!
    @IBOutlet weak var messageNoDataFound: UILabel!
    
    var currentSceneID: Int = 0
    var scenes: [SceneInfo] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //resetDB()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        // Load DB
        loadDB()
        
        // Update UI
        if scenes.count > 0 {   // Show Table
            messageNoDataFound.isHidden = true
            tableViewScenes.isHidden = false
        } else {                // Show message
            messageNoDataFound.isHidden = false
            tableViewScenes.isHidden = true
        }
        
        // Reload data on tables
        tableViewScenes.reloadData()
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
            
            print("Home - creation")
        }
    }
    
    // Load DB
    func loadDB() {
        // Set URL of cache directory
        let documentsUrl =  FileManager.default.urls(for: .cachesDirectory, in: .userDomainMask).first! as NSURL
        // Adding filename DB
        let documentsPath = documentsUrl.appendingPathComponent(filenameDB)
        if let dbUrl = documentsPath {
            do {
                // Getting the data from File
                let plaintText = try String(contentsOf: dbUrl, encoding: .utf8)
                print(plaintText)
                // Text formating
                if let dataFromString = plaintText.data(using: .utf8, allowLossyConversion: false) {
                    do {
                        // Data to Json
                        let jsonData = try JSON(data: dataFromString)
                        // Load current scene ID
                        currentSceneID = jsonData["currentSceneID"].intValue
                        // Load scenes info
                        scenes = []
                        for scene in jsonData["scenes"].arrayValue {
                            scenes.append(JSONtoSceneInfo(data: scene))
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
    
    func resetDB() {
        // Clean Data
        let json: JSON =  [
            "currentSceneID": 0,
            "scenes": []
        ]
        
        // JSON to string
        let text = json.rawString([.castNilToNSNull: true])
        
        // Set File Manager
        let fileManager = FileManager.default
        let documentsUrl =  FileManager.default.urls(for: .cachesDirectory, in: .userDomainMask).first! as NSURL
        // Adding filename DB
        let documentsPath = documentsUrl.appendingPathComponent(filenameDB)
        do {
            // Saving DB
            try text?.write(to: documentsPath!, atomically: false, encoding: .utf8)
            
            // Delete current scenes on cache directory
            if let urlDirectory = documentsUrl.path {
                // Getting filenames
                let fileNames = try fileManager.contentsOfDirectory(atPath: "\(urlDirectory)")
                print("All files in cache: \(fileNames)")
                
                // Deleting files
                for fileName in fileNames {
                    if fileName.hasPrefix("scene") && fileName.hasSuffix(".json") {
                        let filePathName = "\(urlDirectory)/\(fileName)"
                        try fileManager.removeItem(atPath: filePathName)
                    }
                }
                
                // Cheking the files
                let files = try fileManager.contentsOfDirectory(atPath: "\(urlDirectory)")
                print("All files in cache after deleting scenes: \(files)")
            }
            
        } catch {
            print("Cannot save DB")
        }
    }

    func firstTimeApp() {
        // Set URL of cache directory
        let documentsUrl =  FileManager.default.urls(for: .cachesDirectory, in: .userDomainMask).first! as NSURL
        // Adding filename DB
        let documentsPath = documentsUrl.appendingPathComponent(filenameDB)
        if let dbUrl = documentsPath {
            do {
                loadDB()
            } catch {
                resetDB()
            }
        }
    }
}
