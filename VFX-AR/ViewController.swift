//
//  ViewController.swift
//  VFX-AR
//
//  Created by Tony Lattke on 20.11.17.
//  Copyright © 2017 HSB. All rights reserved.
//

import UIKit
import SceneKit
import ARKit
import CoreLocation
import FontAwesome_swift
import SwiftyJSON

class ViewController: UIViewController, ARSCNViewDelegate {

    // AR
    @IBOutlet weak var sceneView: ARSCNView!
    
    // Menu - Effects
    var effectsMenuIsShowing = false
    @IBOutlet weak var effectsMenu: UITableView!
    @IBOutlet weak var leadingConstraintLeft: NSLayoutConstraint!
    let optionsEffects = ["Box","Rain", "Fire", "Smoke"]
    let identifiersEffects = ["Box","rain","fire","smoke"]
    
    // Menu - Settings
    var settingsMenuIsShowing = false
    @IBOutlet weak var settigsMenu: UITableView!
    @IBOutlet weak var leadingConstraintRight: NSLayoutConstraint!
    let optionsSettings = ["Translate", "Scale", "Rotate"]
    let identifiersSettings = ["T","S","R"]
    
    @IBOutlet weak var checkBaseMarkButton: UIButton!
    @IBOutlet weak var uncheckBaseMarkButton: UIButton!
    
    // Gestures
    @IBOutlet var tapGesture: UITapGestureRecognizer!
    @IBOutlet var rightToLeftGesture: UIScreenEdgePanGestureRecognizer!
    @IBOutlet var letToRightGesture: UIScreenEdgePanGestureRecognizer!
    
    // Scene
    var currentLUScene = LUScene()
    let scene = SCNScene()
    var mainNodeScene = SCNNode()
    
    // Location
    var locationManager:CLLocationManager = CLLocationManager()
    var currentLocation: CLLocation?
    
    // Frame counter
    var frameCounter = 0
    
    // Last session
    var baseSessionScene: LUScene?
    
    // Font UI - FontAwesome with size 40
    let font = UIFont.fontAwesome(ofSize: 40)
    @IBOutlet weak var saveButton: UIButton!
    @IBOutlet weak var readButton: UIButton!
    @IBOutlet weak var resetButton: UIButton!
    @IBOutlet weak var statusBarLabel: UINavigationItem!
    @IBOutlet weak var appModeControl: UISegmentedControl!
    
    // CoreLocation
    var saveFirstCoordinates = false
    var firstTimePositionCompare = true
    
    // Mark ids table (new: base)
    var markIdTable = [UUID: UUID?]()
    
    // Selected mark
    var selectedLUMark: LUMark?
    
    // App mode
    var appMode: AppMode = .idle
    
    // Init
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Set the view's delegate
        sceneView.delegate = self
        
        // Show statistics such as fps and timing information
        sceneView.showsStatistics = true
        
        // Set the scene to the view
        sceneView.scene = scene
        sceneView.autoenablesDefaultLighting = true
//        sceneView.debugOptions = SCNDebugOptions(rawValue: ARSCNDebugOptions.showFeaturePoints.rawValue | ARSCNDebugOptions.showWorldOrigin.rawValue)
        sceneView.debugOptions = ARSCNDebugOptions.showWorldOrigin
        scene.rootNode.addChildNode(mainNodeScene)
        
        // Set settings menu table
        settigsMenu.register(UITableViewCell.self, forCellReuseIdentifier: "cellOptions")
        
        // Set effects menu table
        effectsMenu.register(UITableViewCell.self, forCellReuseIdentifier: "cellEffects")
        
        // Location Manager set
        locationManager.requestAlwaysAuthorization()
        locationManager.requestWhenInUseAuthorization()
        if CLLocationManager.locationServicesEnabled() {
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyBest
            locationManager.distanceFilter = kCLDistanceFilterNone
            locationManager.startUpdatingLocation()
        }
        
        // Set UI
        initUI()
        
        // Set Idle
        setIdleModeUI()
        appMode = .idle
    }
    
    // Run
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // Create a session configuration
        let configuration = ARWorldTrackingConfiguration()
        configuration.planeDetection = .horizontal
        configuration.worldAlignment = .gravityAndHeading

        // Run the view's session
        sceneView.session.run(configuration)
    }
    
    // Pause
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        // Pause the view's session
        sceneView.session.pause()
    }
    
    // Main graphic render loop
    func renderer(_ renderer: SCNSceneRenderer, updateAtTime time: TimeInterval) {
        switch appMode {
        case .creation:
            // Update References
            for mark in currentLUScene.marks {
                mark.value.references.update(mark: mark.value, marks: currentLUScene.marks)
            }
        case .relocate:
            // Update References
            for mark in currentLUScene.marks {
                mark.value.references.update(mark: mark.value, marks: currentLUScene.marks)
            }
            // Update mark matching and loaded objects
            if frameCounter % 300 == 0 {
                if baseSessionScene != nil {
                    // Update the Mark id Table
                    updateMarkIdTable()
                    // Re-locate objects
                    relocateObjects()
                }
            }
        case .idle:
            break // Do nothing
        }
        
        // Update frame counter
        frameCounter = frameCounter + 1
    }
    
}