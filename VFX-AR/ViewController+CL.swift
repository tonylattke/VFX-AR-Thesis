//
//  ViewController+CL.swift
//  VFX-AR
//
//  Created by Tony Lattke on 13.12.17.
//  Copyright © 2017 HSB. All rights reserved.
//

import Foundation
import CoreLocation
import SceneKit

extension ViewControllerVFXAR: CLLocationManagerDelegate {
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let lastPosition = locations.last
//        let latitude = lastPosition!.coordinate.latitude
//        let longitude = lastPosition!.coordinate.longitude
//        let altitude = lastPosition!.altitude
        
        if !saveFirstCoordinates {
            currentLUScene.positionGPS = lastPosition!
            saveFirstCoordinates = true
        }
        
//        print("lat: \(latitude) lon: \(longitude) alt: \(altitude)")
        
        currentLocation = lastPosition
    }
}

// https://arxiv.org/pdf/1512.02758.pdf
func gpsCoordinatesTo3D(location: CLLocation) -> simd_float3 {
    let a: Float = 6378137 // it is the WGS84 ellipsoid constant for equatorial earth radius
    let e: Float = 6.69437999 * powf(10, -3)
    let N: Float = a / sqrtf(1.0 - powf(e, 2)*powf(Float(sin(location.coordinate.latitude)), 2))
    
    let x: Float = (N + Float(location.altitude)) *
        cosf(Float(location.coordinate.latitude)) * cosf(Float(location.coordinate.longitude))
    let y: Float = (N + Float(location.altitude)) *
        cosf(Float(location.coordinate.latitude)) * sinf(Float(location.coordinate.longitude))
    let z: Float = ((1 - powf(e, 2)) * N + Float(location.altitude)) *
        sinf(Float(location.coordinate.latitude))
    
    return simd_float3(x,y,z)
}
