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
        
        if let dir = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first {
            let fileURL = dir.appendingPathComponent(selectedScene)
            
            //reading
            do {
                let plaintText = try String(contentsOf: fileURL, encoding: .utf8)
                print(plaintText)
                if let dataFromString = plaintText.data(using: .utf8, allowLossyConversion: false) {
                    do {
                        let jsonData = try JSON(data: dataFromString)
                        
                        // Rebuild last session
                        // - Initial position
                        let loadedBaseInitialPosition = jsonToCLLocation(data: jsonData["initialPosition"])
                        
                        print("load successful")
                        
                        let storyboard = UIStoryboard(name: "Main", bundle: nil)
                        let arcl = storyboard.instantiateViewController(withIdentifier: "findStartPoint") as! ViewControllerARCL
                        
                        arcl.initialLocation = double3(loadedBaseInitialPosition.coordinate.latitude,
                                                       loadedBaseInitialPosition.coordinate.longitude,
                                                       loadedBaseInitialPosition.altitude)
                        arcl.filenameToLoad = selectedScene
                        
                        self.navigationController?.pushViewController(arcl, animated: true)
                    } catch {
                        print("json error")
                    }
                }
            }
            catch {/* error handling here */}
        }
        
        
        
    }
    
}
