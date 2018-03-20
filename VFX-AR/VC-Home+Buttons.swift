//
//  VC-Home+Buttons.swift
//  VFX-AR
//
//  Created by Tony Lattke on 20.03.18.
//  Copyright © 2018 HSB. All rights reserved.
//

import UIKit
import SceneKit

extension ViewControllerHome {
    
    @IBAction func createSceneHandle(_ sender: UIButton) {
        performSegue(withIdentifier: "createSceneConnection", sender: self)
    }
    
}
