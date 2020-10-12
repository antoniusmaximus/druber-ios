//
//  WartenTVC.swift
//  Druber
//
//  Created by Anton Quietzsch on 28.11.17.
//  Copyright © 2017 Anton Quietzsch. All rights reserved.
//

import Foundation
import UIKit
import MapKit
import CoreLocation

class WartenTVC: UITableViewController, CLLocationManagerDelegate, MKMapViewDelegate {
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var typLabel: UILabel!
    @IBOutlet weak var entfernungLabel: UILabel!
    @IBOutlet weak var geschwindigkeitLabel: UILabel!
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var waitingProgressView: UIProgressView!
    
    var locationManager = CLLocationManager()
    
    override func viewDidLoad() {
        
        if CLLocationManager.locationServicesEnabled() {
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyBest
            locationManager.startUpdatingLocation()
        }
        mapView.showsUserLocation = true
        mapView.showsPointsOfInterest = true
        mapView.showsTraffic = true
        mapView.showsBuildings = true
        
        super.viewDidLoad()
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let location = locations.first!
        let region = MKCoordinateRegionMakeWithDistance(location.coordinate, 500, 500)
        mapView.setRegion(region, animated: true)
    }
    
}
