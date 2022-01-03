//
//  LocationService.swift


import Foundation
import CoreLocation
import UIKit

protocol LocationServiceDelegate {
    func tracingLocation(currentLocation: CLLocation)
    func tracingLocationDidFailWithError(error: Error)
}

class LocationService: NSObject, CLLocationManagerDelegate {
    
    class var sharedInstance: LocationService {
        struct Static {
            static var instance = LocationService()
        }
        return Static.instance
    }

    var locationManager: CLLocationManager?
    var currentLocation: CLLocation?
    var delegate: LocationServiceDelegate?

    override init() {
        super.init()

        self.locationManager = CLLocationManager()
        self.locationManager?.desiredAccuracy = kCLLocationAccuracyBest
        guard let locationManager = self.locationManager else {
            return
        }
        
        let status = CLLocationManager.authorizationStatus()
        if status == .notDetermined {
            self.locationManager?.requestWhenInUseAuthorization()
        }
        
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.delegate = self
    }
    
    func startUpdatingLocation() {
        print("Starting Location Updates")
        
        let status = CLLocationManager.authorizationStatus()
        if status == .notDetermined {
            self.locationManager?.requestWhenInUseAuthorization()
            
        }else if status == .denied || status == .restricted{
            Utilities.showAlertWithTitleFromWindow(title: "", andMessage:"Location service is disabled. To re-enable, please go to Settings and turn on Location Service for this application.", buttons: ["Cancel", "Settings"]) { (index) in
                if index == 1{
                    if let settingsAppURL = URL(string: UIApplication.openSettingsURLString){
                        UIApplication.shared.open(settingsAppURL, options: [:], completionHandler: nil)
                    }
                }
            }
        }
        self.locationManager?.startUpdatingLocation()
    }
    
    func stopUpdatingLocation() {
        print("Stop Location Updates")
        self.locationManager?.stopUpdatingLocation()
    }
    
   func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {

        guard let location = locations.last else {
            return
        }
        
        self.currentLocation = location
    SingletonClass.sharedInstance.userCurrentLocation = CLLocation(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude)
    
        updateLocation(currentLocation: location)
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        updateLocationDidFailWithError(error: error)
    }
    
    private func updateLocation(currentLocation: CLLocation){

        guard let delegate = self.delegate else {
            return
        }
        SingletonClass.sharedInstance.userCurrentLocation = CLLocation(latitude: currentLocation.coordinate.latitude, longitude: currentLocation.coordinate.longitude)
        delegate.tracingLocation(currentLocation: currentLocation)
    }
    
    private func updateLocationDidFailWithError(error: Error) {
        
        guard let delegate = self.delegate else {
            return
        }
        delegate.tracingLocationDidFailWithError(error: error)
    }
}
