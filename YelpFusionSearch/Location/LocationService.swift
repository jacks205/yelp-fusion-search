//
//  LocationManager.swift
//  YelpFusionSearch
//
//  Created by Mark Jackson on 2/27/18.
//  Copyright © 2018 Mark Jackson. All rights reserved.
//

import Foundation
import CoreLocation

let locationService = LocationService()

class LocationService: NSObject, CLLocationManagerDelegate {
    
    private let manager = CLLocationManager()
    private var getLocationCompletion: ((CLLocation) -> ())?
    
    public var location: CLLocation? {
        return manager.location
    }
    
    override init() {
        super.init()
        manager.delegate = self
    }
    
    func getLocation(completion: @escaping (CLLocation) -> ()) {
        getLocationCompletion = completion
        if location == nil {
            manager.requestWhenInUseAuthorization()
            manager.requestLocation()
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        getLocationCompletion?(locations[0])
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        switch status {
        case .notDetermined:
            manager.requestWhenInUseAuthorization()
        case .denied:
            return
        case .restricted:
            return
        default:
            manager.requestLocation()
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        debugPrint(error)
    }
    
}
