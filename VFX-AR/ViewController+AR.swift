//
//  ViewController+AR.swift
//  VFX-AR
//
//  Created by Tony Lattke on 21.11.17.
//  Copyright © 2017 HSB. All rights reserved.
//


import UIKit
import SceneKit
import ARKit

extension ViewControllerVFXAR {
    
    // Present an error message to the user
    func session(_ session: ARSession, didFailWithError error: Error) {
        
    }
    
    // Inform the user that the session has been interrupted, for example, by
    // presenting an overlay
    func sessionWasInterrupted(_ session: ARSession) {
        
    }
    
    // Reset tracking and/or remove existing anchors if consistent tracking is
    // required
    func sessionInterruptionEnded(_ session: ARSession) {
        
    }
    
    // Update the status bar
    func session(_ session: ARSession, cameraDidChangeTrackingState camera: ARCamera) {
        var status = "Loading..."
        switch camera.trackingState {
        case ARCamera.TrackingState.notAvailable:
            status = "Not available"
        case ARCamera.TrackingState.limited(_):
            status = "Analyzing..."
        case ARCamera.TrackingState.normal:
            status = "Ready"
        }
        
        // Update label
        self.title = status
    }
}
