//
//  VC-ARCL+Buttons.swift
//  VFX-AR
//
//  Created by Tony Lattke on 20.03.18.
//  Copyright © 2018 HSB. All rights reserved.
//

import UIKit
import ARKit
import SceneKit
import CoreLocation

import ARCL

extension ViewControllerARCL {
    
    // Load scene button handler
    @IBAction func readyButtonHandle(_ sender: UIButton) {
        performSegue(withIdentifier: "loadSceneConnection", sender: self)
    }
    
    @IBAction func startFindGoalHandle(_ sender: UIButton) {
        startPoint = CLLocation(coordinate: CLLocationCoordinate2D(latitude: initialLocation.x,
                                                                   longitude: initialLocation.y),
                                altitude: initialLocation.z,
                                horizontalAccuracy: CLLocationAccuracy(),
                                verticalAccuracy: CLLocationAccuracy(),
                                timestamp: Date(timeIntervalSinceNow: 0))
        
        let image2 = getImageWithColor(color: .green, size: CGSize(width:100,height:100))
        let annotationNode2 = LocationAnnotationNode(location: startPoint, image: image2)
        
        // Add Annotation to Scene
        sceneLocationView.addLocationNodeWithConfirmedLocation(locationNode: annotationNode2)
        print(annotationNode2.worldPosition)
        
        let geom2 = SCNBox(width: 0.1, height: 0.1, length: 0.1, chamferRadius: 0)
        let geomN2 = SCNNode(geometry: geom2)
        geomN2.worldPosition = annotationNode2.worldPosition
        sceneLocationView.scene.rootNode.addChildNode(geomN2)
        
        flag = false
    }
}
