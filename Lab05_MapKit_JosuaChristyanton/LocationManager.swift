//
//  LocationManager.swift
//  Lab05_MapKit_JosuaChristyanton
//
//  Created by Josua Christyanton on 2022-10-18.
//

import Foundation
import CoreLocation

// ViewModel to hold the user location data
class LocationManager: NSObject, CLLocationManagerDelegate, ObservableObject
{
    // properties
    @Published var location = CLLocation()
    @Published var userTracking = true
    let locationManager = CLLocationManager()

    override init() {
        super.init()
        
        // get the current user location
        locationManager.requestWhenInUseAuthorization()
        if CLLocationManager.locationServicesEnabled()
        {
            locationManager.delegate = self // set the delegate to itself
            locationManager.desiredAccuracy = kCLLocationAccuracyBestForNavigation // BesForNavigation uses other sensors, like gyroscope and wifi, and cell towers, additional information for better location
            locationManager.startUpdatingLocation()
            userTracking = true
        }
    }
    
    func startTracking()
    {
        locationManager.startUpdatingLocation()
        userTracking = true
    }
    
    func stopTracking()
    {
        locationManager.stopUpdatingLocation()
        userTracking = false
    }
    
    // delegate for LocationManagerDelegate
    func locationManager(_ manager: CLLocationManager,
                         didUpdateLocations locations: [CLLocation])
    {
        // get the current location
        if let location = locations.last
        {
            self.location = location
        }
    }
    
}
