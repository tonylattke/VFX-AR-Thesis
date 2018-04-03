//
//  VC-ARCL+CL.swift
//  VFX-AR
//
//  Created by Tony Lattke on 06.03.18.
//  Copyright © 2018 HSB. All rights reserved.
//

import UIKit
import ARKit
import SceneKit
import CoreLocation

extension ViewControllerARCL: CLLocationManagerDelegate {
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        // Update current position
        currentPostion = locations.last
        
        if !flag {
            let distance = startPoint?.distance(from: currentPostion!)
            print(distance)
        }
    }
}
