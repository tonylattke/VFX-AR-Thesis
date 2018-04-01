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

extension ViewControllerVFXAR {
    
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
        
        saveTextButton.titleLabel?.font = font
        saveTextButton.setTitle(String.fontAwesomeIcon(name: .check), for: .normal)
        cancelTextButton.titleLabel?.font = font
        cancelTextButton.setTitle(String.fontAwesomeIcon(name: .ban), for: .normal)
        
        saveEditionNumberButton.titleLabel?.font = font
        saveEditionNumberButton.setTitle(String.fontAwesomeIcon(name: .check), for: .normal)
        cancelEditionNumberButton.titleLabel?.font = font
        cancelEditionNumberButton.setTitle(String.fontAwesomeIcon(name: .ban), for: .normal)
    }
    
    // Set Idle mode
    func setIdleModeUI(){
        // Status bar label
        self.title = "Idle"
        
        // Buttons
        saveButton.isHidden = false
        readButton.isHidden = true
        resetButton.isHidden = false
        appModeControl.isHidden = false
        axisModeControl.isHidden = true
        
        checkBaseMarkButton.isHidden = true
        uncheckBaseMarkButton.isHidden = true
    }
    
    // Set Creation mode
    func setCreationModeUI(){
        // Status bar label
        self.title = "Creation Mode"
        
        // Buttons
        saveButton.isHidden = false
        readButton.isHidden = true
        resetButton.isHidden = false
        appModeControl.isHidden = false
        axisModeControl.isHidden = true
        
        checkBaseMarkButton.isHidden = true
        uncheckBaseMarkButton.isHidden = true
    }
    
    // Set Relocate mode
    func setRelocateModeUI(){
        // Status bar label
        self.title = "Relocate Mode"
        
        // Buttons
        saveButton.isHidden = true
        readButton.isHidden = false
        resetButton.isHidden = false
        appModeControl.isHidden = false
        axisModeControl.isHidden = true
        
        checkBaseMarkButton.isHidden = true
        uncheckBaseMarkButton.isHidden = true
    }
    
    // Set edition mode
    func setEditionModeUI() {
        // Status bar label
        self.title = "Object selected"
        
        // Buttons
        saveButton.isHidden = true
        readButton.isHidden = true
        resetButton.isHidden = true
        appModeControl.isHidden = true
        axisModeControl.isHidden = false
        
        checkBaseMarkButton.isHidden = true
        uncheckBaseMarkButton.isHidden = true
    }
    
    func showMarkOptions(){
        checkBaseMarkButton.isHidden = false
        uncheckBaseMarkButton.isHidden = false
    }
    
    func hideMarkOptions(){
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
    
    // Show Settings Menu
    func showSettingsMenu(){
        leadingConstraintRight.constant = 0
        settingsMenuIsShowing = true
    }
    
    // Hide Settings Menu
    func hideSettingsMenu(){
        leadingConstraintRight.constant = 240
        settingsMenuIsShowing = false
    }
    
    // Show Effects Menu
    func showEffectsMenu(){
        leadingConstraintLeft.constant = 0
        effectsMenuIsShowing = true
    }
    
    // Hide Effects Menu
    func hideEffectsMenu(){
        leadingConstraintLeft.constant = -240
        effectsMenuIsShowing = false
    }
    
    func updateUIStatus(title: String) {
        self.title = title
    }
}
