//
//  LocatonViewController.swift
//  Weather
//
//  Created by Kalpit Patil on 2021-06-17.
//

import UIKit
import CoreLocation
import MapKit

class LocatonViewController: UIViewController, CLLocationManagerDelegate {
    
    @IBOutlet weak var imgLocationOnMap: MKMapView!
    @IBOutlet weak var navBarHeightConstant: NSLayoutConstraint!
    let locationManager = CLLocationManager()
    var cityname = String()
        
        
    override func viewDidLoad() {
        super.viewDidLoad()
        if !UIDevice.current.hasNotch {
            navBarHeightConstant.constant = 66
           
        }
        self.locationManager.requestAlwaysAuthorization()
        
        // For use in foreground
        self.locationManager.requestWhenInUseAuthorization()
        
        if CLLocationManager.locationServicesEnabled() {
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
            locationManager.startUpdatingLocation()
        
    
        }
    }
        func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
            guard let locValue: CLLocationCoordinate2D = manager.location?.coordinate else { return }
            mapView(lati: locValue.latitude, longi: locValue.longitude)
            
        }
    func mapView(lati: Double, longi: Double) {
        //the red bubble on map
        let annotation = MKPointAnnotation()
        annotation.title = cityname
        annotation.coordinate = CLLocationCoordinate2D.init(latitude: (lati), longitude: (longi))
        imgLocationOnMap.addAnnotation(annotation)

    }
}
