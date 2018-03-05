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

    @IBOutlet weak var viewAreaARCL: UIView!
    var sceneLocationView = SceneLocationView()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Create Scene
        sceneLocationView.run()
        sceneLocationView.showsStatistics = true
        sceneLocationView.debugOptions = SCNDebugOptions(rawValue: ARSCNDebugOptions.showFeaturePoints.rawValue | ARSCNDebugOptions.showWorldOrigin.rawValue)
        viewAreaARCL.addSubview(sceneLocationView)
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
