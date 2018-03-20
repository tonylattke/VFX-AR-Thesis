//
//  VC-ARCL+Buttons.swift
//  VFX-AR
//
//  Created by Tony Lattke on 20.03.18.
//  Copyright © 2018 HSB. All rights reserved.
//

import UIKit

extension ViewControllerARCL {
    
    @IBAction func readyButtonHandle(_ sender: UIButton) {
        performSegue(withIdentifier: "loadSceneConnection", sender: self)
    }
}
