//
//  VC-Home+TableView.swift
//  VFX-AR
//
//  Created by Tony Lattke on 20.03.18.
//  Copyright © 2018 HSB. All rights reserved.
//

import UIKit
import SceneKit
import SwiftyJSON

extension ViewControllerHome: UITableViewDelegate, UITableViewDataSource {
    
    // Init tables
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return scenes.count
    }
    
    // Init cells
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell:UITableViewCell?
        
        cell = UITableViewCell(style: .default, reuseIdentifier: "cellScenes")
        cell?.textLabel?.text = scenes[indexPath.row].name
        
        return cell!
    }
    
    // Option selected
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedScene = scenes[indexPath.row].name
        
        // Set URL of cache directory
        let documentsUrl =  FileManager.default.urls(for: .cachesDirectory, in: .userDomainMask).first! as NSURL
        // Adding filename DB
        let documentsPath = documentsUrl.appendingPathComponent(selectedScene)
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
                        
                        // Rebuild last session
                        // - Initial position
                        let loadedBaseInitialPosition = jsonToCLLocation(data: jsonData["initialPosition"])
                        print("Load successful")
                        
                        // Redirect to Find start point view
                        let storyboard = UIStoryboard(name: "Main", bundle: nil)
                        let arcl = storyboard.instantiateViewController(withIdentifier: "findStartPoint") as! ViewControllerARCL
                        arcl.initialLocation = double3(loadedBaseInitialPosition.coordinate.latitude,
                                                       loadedBaseInitialPosition.coordinate.longitude,
                                                       loadedBaseInitialPosition.altitude)
                        arcl.filenameToLoad = selectedScene
                        
                        self.navigationController?.pushViewController(arcl, animated: true)
                    } catch {
                        print("Json error")
                    }
                }
            } catch {
                print("Cannot load \(selectedScene)")
            }
        }
    }
    
}
