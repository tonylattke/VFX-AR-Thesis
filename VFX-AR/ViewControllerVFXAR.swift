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

class ViewControllerVFXAR: UIViewController, ARSCNViewDelegate {
    
    // AR
    @IBOutlet weak var sceneView: ARSCNView!
    
    // Menu - Effects
    var effectsMenuIsShowing = false
    @IBOutlet weak var effectsMenu: UITableView!
    @IBOutlet weak var leadingConstraintLeft: NSLayoutConstraint!
    let optionsEffects = ["Box","Text","Sparks","Rain","Smoke","Fire", "3D Model"]
    
    // Menu - Settings
    var settingsMenuIsShowing = false
    @IBOutlet weak var settigsMenu: UITableView!
    @IBOutlet weak var leadingConstraintRight: NSLayoutConstraint!
    let baseOptionsSettings = ["Translate", "Scale", "Rotate"]
    var optionsSettings: [String] = []
    
    // Gestures
    @IBOutlet var tapGesture: UITapGestureRecognizer!
    @IBOutlet var rightToLeftGesture: UIScreenEdgePanGestureRecognizer!
    @IBOutlet var letToRightGesture: UIScreenEdgePanGestureRecognizer!
    
    var sceneID: Int = 0
    
    // Scene
    var currentLUScene:LUScene = LUScene()
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
    @IBOutlet weak var appModeControl: UISegmentedControl!
    
    @IBOutlet weak var transformAxisView: UIView!
    @IBOutlet weak var axisModeControl: UISegmentedControl!
    @IBOutlet weak var saveTransformAxisViewButton: UIButton!
    @IBOutlet weak var cancelTransformAxisViewButton: UIButton!
    
    @IBOutlet weak var markControlView: UIView!
    @IBOutlet weak var checkBaseMarkButton: UIButton!
    @IBOutlet weak var uncheckBaseMarkButton: UIButton!
    
    @IBOutlet weak var textEditorView: UIView!
    @IBOutlet weak var textField: UITextField!
    @IBOutlet weak var saveTextButton: UIButton!
    @IBOutlet weak var cancelTextButton: UIButton!
    
    @IBOutlet weak var numberEditorView: UIView!
    @IBOutlet weak var numberSliderControl: UISlider!
    @IBOutlet weak var saveEditionNumberButton: UIButton!
    @IBOutlet weak var cancelEditionNumberButton: UIButton!
    
    // CoreLocation
    var saveFirstCoordinates = false
    var firstTimePositionCompare = true
    
    // Mark ids table (new: base)
    var markIdTable = [UUID: UUID?]()
    
    // Selected mark
    var selectedLUMark: LUMark?
    
    // App mode
    var appMode: AppMode = .idle
    
    // Start mode
    var appStartMode: AppStartMode = .creation
    
    // Filename to load
    var filenameToLoad: String = ""
    
    var interactionAxis: InteractionAxis = .all
    var interactionMode: InteractionMode = .none
    var selectedObject: LUInteractivObject?
    
    var currentSelectedAttributeName: String = ""
    var currentSelectedAttributeType: ValueType?
    
    // Init
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.interactivePopGestureRecognizer?.isEnabled = false
        
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
        
        currentLUScene = LUScene()
        
        // Location Manager set
        locationManager.requestAlwaysAuthorization()
        locationManager.requestWhenInUseAuthorization()
        if CLLocationManager.locationServicesEnabled() {
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyBest
            locationManager.distanceFilter = kCLDistanceFilterNone
            locationManager.startUpdatingLocation()
        }
        
        // Init UI
        initUI()
        
        switch appStartMode {
        case .creation:
            currentLUScene.id = sceneID
            
            // Set Idle mode
            setIdleModeUI()
            appMode = .idle
            
            print("creation mode started")
        case .load:
            load(sceneFilename: filenameToLoad)
            currentLUScene.id = (baseSessionScene?.id)!
            
            // Set Idle mode
            setRelocateModeUI()
            appModeControl.selectedSegmentIndex = 2
            appMode = .relocate
            
            print("load mode started")
        }
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
            if frameCounter % 120 == 0 {
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
    
    func load(sceneFilename: String) {
        // Set URL of cache directory
        let documentsUrl =  FileManager.default.urls(for: .cachesDirectory, in: .userDomainMask).first! as NSURL
        // Adding filename DB
        let documentsPath = documentsUrl.appendingPathComponent(sceneFilename)
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
                        let loadedSceneID = jsonData["id"].intValue
                        // - Initial position
                        let loadedBaseInitialPosition = jsonToCLLocation(data: jsonData["initialPosition"])
                        // - Marks
                        var loadedBaseMarks = [UUID: LUMark]()
                        for mark in jsonData["marks"].arrayValue {
                            let baseMark = JSONToLUMark(data: mark)
                            loadedBaseMarks[baseMark.id] = baseMark
                        }
                        // - Objects
                        var loadedBaseObjects = [LUInteractivObject]()
                        for object in jsonData["objects"].arrayValue {
                            let oldObject = JSONToLUInteractivObject(data: object)
                            loadedBaseObjects.append(oldObject)
                        }
                        
                        // Result
                        baseSessionScene = LUScene(id: loadedSceneID, location: loadedBaseInitialPosition,
                                                   marks: loadedBaseMarks, objects: loadedBaseObjects)
                        
                        // Set Marks as not used
                        for baseMark in (baseSessionScene?.marks)! {
                            markIdTable[baseMark.key] = nil
                        }
                        
                        // Update Mark table
                        updateMarkIdTable()
                        
                        // Adding objects to scene
                        for object in (baseSessionScene?.objects)! {
                            object.isHidden = true
                            currentLUScene.objects.append(object)
                            mainNodeScene.addChildNode(object)
                        }
                        
                        print("Load scene successful")
                    } catch {
                        print("json error")
                    }
                }
            } catch {
                print("Cannot load \(sceneFilename)")
            }
        }
    }
    
}
