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
        
        saveTransformAxisViewButton.titleLabel?.font = font
        saveTransformAxisViewButton.setTitle(String.fontAwesomeIcon(name: .check), for: .normal)
        cancelTransformAxisViewButton.titleLabel?.font = font
        cancelTransformAxisViewButton.setTitle(String.fontAwesomeIcon(name: .ban), for: .normal)
        
        deleteObjectButton.titleLabel?.font = font
        deleteObjectButton.setTitle(String.fontAwesomeIcon(name: .trash), for: .normal)
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
        
        transformAxisView.isHidden = true
        markControlView.isHidden = true
        numberEditorView.isHidden = true
        textEditorView.isHidden = true
        
        deleteObjectButton.isHidden = true
        
        for mark in currentLUScene.marks {
            mark.value.isHidden = true
        }
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
        
        transformAxisView.isHidden = true
        markControlView.isHidden = true
        numberEditorView.isHidden = true
        textEditorView.isHidden = true
        
        deleteObjectButton.isHidden = true
        
        for mark in currentLUScene.marks {
            mark.value.isHidden = false
        }
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
        
        transformAxisView.isHidden = true
        markControlView.isHidden = true
        numberEditorView.isHidden = true
        textEditorView.isHidden = true
        
        deleteObjectButton.isHidden = true
        
        for mark in currentLUScene.marks {
            mark.value.isHidden = false
        }
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
        
        transformAxisView.isHidden = true
        markControlView.isHidden = true
        numberEditorView.isHidden = true
        textEditorView.isHidden = true
        
        deleteObjectButton.isHidden = false
        
        for mark in currentLUScene.marks {
            mark.value.isHidden = true
        }
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
    
    // Update status label
    func updateUIStatus(title: String) {
        self.title = title
    }
    
    // ------------------------- Mark menu control -------------------------- //
    
    // Show mark UI options
    func showMarkOptions(){
        markControlView.isHidden = false
        deleteObjectButton.isHidden = true
    }
    
    // Hide mark UI options
    func hideMarkOptions(){
        markControlView.isHidden = true
        deleteObjectButton.isHidden = true
    }
    
    // ----------------------- Transform axis control ----------------------- //
    
    func showTranformAxisMenu() {
        transformAxisView.isHidden = false
        deleteObjectButton.isHidden = true
    }
    
    func hideTranformAxisMenu() {
        transformAxisView.isHidden = true
        deleteObjectButton.isHidden = true
    }
    
    // ----------------------- Settings menu control ------------------------ //
    
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
    
    // ------------------------ Effects menu control ------------------------ //
    
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
    
    // ----------------------- number editor control ------------------------ //
    
    // Show Number editor
    func showNumberEditor() {
        numberEditorView.isHidden = false
        deleteObjectButton.isHidden = true
    }
    
    // Hide number editor
    func hideNumberEditor() {
        numberEditorView.isHidden = true
        deleteObjectButton.isHidden = true
    }
    
    // ------------------------ text editor control ------------------------- //
    
    // Show Text editor
    func showTextEditor() {
        textEditorView.isHidden = false
        deleteObjectButton.isHidden = true
    }
    
    // Hide text editor
    func hideTextEditor() {
        textEditorView.isHidden = true
        deleteObjectButton.isHidden = true
    }
    
}
