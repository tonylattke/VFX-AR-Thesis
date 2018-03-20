//
//  ViewControllerARCL.swift
//  VFX-AR
//
//  Created by Tony Lattke on 03.03.18.
//  Copyright © 2018 HSB. All rights reserved.
//

import UIKit
import ARKit
import SceneKit
import CoreLocation

import ARCL

class ViewControllerARCL: UIViewController {

    // Scene View ARCL
    @IBOutlet weak var viewAreaARCL: UIView!
    var sceneLocationView = SceneLocationView()
    
    // Location manager
    var locationManager:CLLocationManager = CLLocationManager()
    
    var flag = true
    
    var initialLocation = double3.init() // Interface
    var startPoint: CLLocation?
    var currentPostion: CLLocation?
    
    var filenameToLoad: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Create Scene
        sceneLocationView.run()
        sceneLocationView.showsStatistics = true
        sceneLocationView.debugOptions = SCNDebugOptions(rawValue: ARSCNDebugOptions.showFeaturePoints.rawValue | ARSCNDebugOptions.showWorldOrigin.rawValue)
        viewAreaARCL.addSubview(sceneLocationView)
        
        // Location Manager set
        locationManager.requestAlwaysAuthorization()
        locationManager.requestWhenInUseAuthorization()
        if CLLocationManager.locationServicesEnabled() {
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyBest
            locationManager.distanceFilter = kCLDistanceFilterNone
            locationManager.startUpdatingLocation()
        }
        
        startPoint = CLLocation(coordinate: CLLocationCoordinate2D(latitude: initialLocation.x,
                                                                   longitude: initialLocation.y),
                                altitude: initialLocation.z,
                                horizontalAccuracy: CLLocationAccuracy(),
                                verticalAccuracy: CLLocationAccuracy(),
                                timestamp: Date(timeIntervalSinceNow: 0))
    }
    
    // Main graphic render loop
    func renderer(_ renderer: SCNSceneRenderer, updateAtTime time: TimeInterval) {
        if flag {
//            let coordinate = CLLocationCoordinate2D(latitude: 53.0547941615774, longitude:  8.78312816819939)
//            let location = CLLocation(coordinate: coordinate, altitude: 2.67797017097473)
            let image = getImageWithColor(color: .green, size: CGSize(width:100,height:100))
            let annotationNode = LocationAnnotationNode(location: startPoint, image: image)
            
            // Add Annotation to Scene
            sceneLocationView.addLocationNodeWithConfirmedLocation(locationNode: annotationNode)
            print(annotationNode.worldPosition)
            
            let geom = SCNBox(width: 0.1, height: 0.1, length: 0.1, chamferRadius: 0)
            let geomN = SCNNode(geometry: geom)
            geomN.worldPosition = annotationNode.worldPosition
            sceneLocationView.scene.rootNode.addChildNode(geomN)
            
            flag = false
        }
        
        let distance = startPoint?.distance(from: currentPostion!)
        print(distance)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Go to load
        if let destination = segue.destination as? ViewControllerVFXAR  {
            destination.appStartMode = .load
            destination.filenameToLoad = filenameToLoad
            
            print("find marks - load")
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        sceneLocationView.frame = view.bounds
    }
    
}


