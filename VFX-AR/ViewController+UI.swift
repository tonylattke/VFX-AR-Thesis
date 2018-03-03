//
//  ViewController+UI.swift
//  VFX-AR
//
//  Created by Tony Lattke on 20.02.18.
//  Copyright © 2018 HSB. All rights reserved.
//

import SceneKit
import ARKit
import CoreLocation
import FontAwesome_swift
import SwiftyJSON

extension ViewController {
    
    // Init
    func initUI(){
        // Set UI style
        saveButton.titleLabel?.font = font
        saveButton.setTitle(String.fontAwesomeIcon(name: .save), for: .normal)
        readButton.titleLabel?.font = font
        readButton.setTitle(String.fontAwesomeIcon(name: .calculator), for: .normal)
        resetButton.titleLabel?.font = font
        resetButton.setTitle(String.fontAwesomeIcon(name: .repeat), for: .normal)
        checkBaseMarkButton.titleLabel?.font = font
        checkBaseMarkButton.setTitle(String.fontAwesomeIcon(name: .check), for: .normal)
        uncheckBaseMarkButton.titleLabel?.font = font
        uncheckBaseMarkButton.setTitle(String.fontAwesomeIcon(name: .ban), for: .normal)
    }
    
    // Set Idle mode
    func setIdleModeUI(){
        // Status bar label
        statusBarLabel.title = "Idle"
        
        // Buttons
        saveButton.isHidden = false
        readButton.isHidden = true
        resetButton.isHidden = false
        
        checkBaseMarkButton.isHidden = true
        uncheckBaseMarkButton.isHidden = true
    }
    
    // Set Creation mode
    func setCreationModeUI(){
        // Status bar label
        statusBarLabel.title = "Creation Mode"
        
        // Buttons
        saveButton.isHidden = false
        readButton.isHidden = true
        resetButton.isHidden = false
        
        checkBaseMarkButton.isHidden = true
        uncheckBaseMarkButton.isHidden = true
    }
    
    // Set Relocate mode
    func setRelocateModeUI(){
        // Status bar label
        statusBarLabel.title = "Relocate Mode"
        
        // Buttons
        saveButton.isHidden = true
        readButton.isHidden = false
        resetButton.isHidden = false
        
        checkBaseMarkButton.isHidden = true
        uncheckBaseMarkButton.isHidden = true
    }
    
    // Show alert with message
    func showAlert(message: String) {
        let alertController =
            UIAlertController(title: "Status",
                              message: message,
                              preferredStyle: UIAlertControllerStyle.alert)
        alertController.addAction(UIAlertAction(title: "Understood",
                                                style: UIAlertActionStyle.default,
                                                handler: nil))
        self.present(alertController, animated: true, completion: nil)
    }
    
}
