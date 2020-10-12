//
//  AnfordernMVC.swift
//  Druber
//
//  Created by Anton Quietzsch on 31.10.17.
//  Copyright © 2017 Anton Quietzsch. All rights reserved.
//

import Foundation
import UIKit
import CoreLocation
import MapKit

class AnfordernMVC: UIViewController, UISearchBarDelegate, CLLocationManagerDelegate, MKMapViewDelegate {
    
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var weatherItem: UIButton!
    
    var searchController:UISearchController!
    var annotation:MKAnnotation!
    var localSearchRequest:MKLocalSearchRequest!
    var localSearch:MKLocalSearch!
    var localSearchResponse:MKLocalSearchResponse!
    var error:NSError!
    var pointAnnotation:MKPointAnnotation!
    var pinAnnotationView:MKPinAnnotationView!
    
    @IBOutlet weak var dialogView: UIView!
    @IBOutlet weak var iconImageView: UIImageView!
    @IBOutlet weak var goToPaketeButton: UIButton!
    @IBOutlet weak var dialogLabel2: UILabel!
    @IBOutlet weak var dialogLabel3: UILabel!
    
    var locationManager = CLLocationManager()
    
    @IBOutlet weak var paketeContainerView: UIView!
    
    override func viewDidLoad() {
        
        //Dialog
        showGoButton(a: true)
        NotificationCenter.default.addObserver(self, selector: #selector(keyBoardWillHide(notification:)), name: .UIKeyboardWillHide, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyBoardWillShow(notification:)), name: .UIKeyboardWillShow, object: nil)
        
        // SearchBar
        navigationController?.navigationBar.prefersLargeTitles = true
        let searchController = UISearchController(searchResultsController: nil)
        navigationItem.searchController = searchController
        navigationItem.hidesSearchBarWhenScrolling = false

        searchController.hidesNavigationBarDuringPresentation = true
        self.navigationItem.searchController?.searchBar.delegate = self
        
        // Weather
        updateWeather()

        // Karte und Standort
        locationManager.requestAlwaysAuthorization()
        if CLLocationManager.locationServicesEnabled() {
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyBest
            locationManager.startUpdatingLocation()
        }
        mapView.showsPointsOfInterest = true
        mapView.showsTraffic = true
        mapView.showsBuildings = true
        
        //Containern und Swipen
        paketeContainerView.isHidden = true
        /*let view = paketeContainerView //?
        let swipeUp = UISwipeGestureRecognizer(target: self, action: #selector(swiping))
        swipeUp.direction = .up
        view?.addGestureRecognizer(swipeUp)
        let swipeDown = UISwipeGestureRecognizer(target: self, action: #selector(swiping))
        swipeDown.direction = .down
        view?.addGestureRecognizer(swipeDown)
        */
        super.viewDidLoad()
    }
    
    /*@objc func swiping(sender: UISwipeGestureRecognizer) {
        if sender.direction == .up {
            print("up")
        } else if sender.direction == .down {
            print("down")
        }
    }*/
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let location = locations.first!
        let region = MKCoordinateRegionMakeWithDistance(location.coordinate, 500, 500)
        mapView.setRegion(region, animated: true)
        locationManager.stopUpdatingLocation()
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        if status == CLAuthorizationStatus.denied {
            let alertController = UIAlertController(title: nil, message: "Standortzugriff nicht erlaubt", preferredStyle: UIAlertControllerStyle.alert)
            alertController.addAction(UIAlertAction(title: "Abbrechen", style: UIAlertActionStyle.destructive, handler: nil))
            self.present(alertController, animated: true, completion: nil)
        }
    }
    
    @objc func keyBoardWillHide(notification: NSNotification) {
        avoidAnnotationConfusion()
    }
    
    @objc func keyBoardWillShow(notification: NSNotification) {
        avoidAnnotationConfusion()
        navigationController?.navigationBar.topItem?.title = "Ziel suchen"
        paketeContainerView.isHidden = true
    }
    
    func avoidAnnotationConfusion() {
        if self.navigationItem.searchController?.searchBar.text == "" {
        showGoButton(a: true)
        annotation = self.mapView.annotations[0]
        self.mapView.removeAnnotation(annotation)
        }
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar){

        //Start
        searchBar.resignFirstResponder()
        dismiss(animated: true, completion: nil)
        if self.mapView.annotations.count != 0{
            annotation = self.mapView.annotations[0]
            self.mapView.removeAnnotation(annotation)
        }
        
        //Geomapping
        localSearchRequest = MKLocalSearchRequest()
        localSearchRequest.naturalLanguageQuery = searchBar.text
        localSearch = MKLocalSearch(request: localSearchRequest)
        
        //Unbekannte Adresse
        localSearch.start { (localSearchResponse, error) -> Void in
            if localSearchResponse == nil{
                let alertController = UIAlertController(title: nil, message: "Adresse unbekannt", preferredStyle: UIAlertControllerStyle.alert)
                alertController.addAction(UIAlertAction(title: "Anderes Ziel wählen", style: UIAlertActionStyle.destructive, handler: nil))
                self.present(alertController, animated: true, completion: nil)
                return
            }
            
            //Bekannte Adresse
            self.pointAnnotation = MKPointAnnotation()
            self.pointAnnotation.title = searchBar.text
            self.pointAnnotation.coordinate = CLLocationCoordinate2D(latitude: localSearchResponse!.boundingRegion.center.latitude, longitude:     localSearchResponse!.boundingRegion.center.longitude)
            self.pinAnnotationView = MKPinAnnotationView(annotation: self.pointAnnotation, reuseIdentifier: nil)
            self.mapView.centerCoordinate = self.pointAnnotation.coordinate
            self.mapView.addAnnotation(self.pinAnnotationView.annotation!)
            let annotationLocation = CLLocation(latitude: localSearchResponse!.boundingRegion.center.latitude, longitude:     localSearchResponse!.boundingRegion.center.longitude)
            
            //Dialog erzeugen
            self.showGoButton(a: false)
            if self.navigationItem.searchController?.searchBar.text == nil {
                self.showGoButton(a: true)
            }
            self.dialogView.layer.cornerRadius = 15
            self.dialogLabel2.text = "Nach: \(searchBar.text!)"
            let entfernung = Int((self.locationManager.location?.distance(from: annotationLocation))!)
            self.dialogLabel3.text = "Entfernung: \(entfernung/1000) km"
            self.goToPaketeButton.setTitleColor(UIColor.white, for: .normal)
            self.goToPaketeButton.setTitle("   WÄHLEN   ", for: .normal)
            self.goToPaketeButton.layer.cornerRadius = 13.0
            //self.goToPaketeButton.backgroundColor = UIColor.init(red: 0.0, green: 0.0, blue: 0.0, alpha: 1.0)
            self.dialogView.backgroundColor = UIColor.init(red: 1.0, green: 1.0, blue: 1.0, alpha: 0.95)
            
            //Routenübersicht
            let start = self.locationManager.location?.coordinate
            let ziel = self.pointAnnotation.coordinate
            let startPlacemark = MKPlacemark(coordinate: start!)
            let zielPlacemark = MKPlacemark(coordinate: ziel)
            let startItem = MKMapItem(placemark: startPlacemark)
            let zielItem = MKMapItem(placemark: zielPlacemark)
            let directionRequest = MKDirectionsRequest()
            directionRequest.source = startItem
            directionRequest.destination = zielItem
            
            directionRequest.transportType = .automobile
            let directions = MKDirections(request: directionRequest)
            directions.calculate(completionHandler: {
                response, error in
                guard let response = response else {
                    if let error = error {
                        print("Ups")
                    }
                    return
                }
                let route = response.routes[0]
                self.mapView.add(route.polyline, level: .aboveRoads)
                let rectangle = route.polyline.boundingMapRect
                self.mapView.setRegion(MKCoordinateRegionForMapRect(rectangle), animated: true)
            })
        }
    }
    
    func mapView(_mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        if overlay is MKPolyline {
            let renderer = MKPolylineRenderer(overlay: overlay)
            renderer.strokeColor = UIColor.blue
            renderer.lineWidth = 5.0
            return renderer
        }
        return MKOverlayRenderer()
    }
    
    func showGoButton(a: Bool) {
        dialogView.isHidden = a
        goToPaketeButton.isHidden = a
        dialogLabel2.isHidden = a
        iconImageView.isHidden = a
    }

    @IBAction func goToPakete(_ sender: UIButton) {
        paketeContainerView.isHidden = false
        navigationController?.navigationBar.topItem?.title = "Paket wählen"
    }
        
    func updateWeather() {
        let min : UInt32 = 0
        let max : UInt32 = 80
        let randomNumber = arc4random_uniform(max - min) + min
        let windSpeed = String(randomNumber)
        weatherItem.setTitle("   Wind: \(windSpeed) km/h   ", for: .normal)
        weatherItem.setTitleColor(UIColor.white, for: .normal)
        weatherItem.layer.cornerRadius = 13.0
        if (randomNumber < 30) {
            weatherItem.backgroundColor = UIColor.init(red: 0.0, green: 0.75, blue: 0.0, alpha: 1.0)
            goToPaketeButton.backgroundColor = UIColor.init(red: 0.0, green: 0.75, blue: 0.0, alpha: 1.0)
            //self.dialogView.backgroundColor = UIColor.init(red: 0.0, green: 0.75, blue: 0.0, alpha: 0.95)
            navigationItem.searchController?.searchBar.placeholder = "Zieladresse eingeben"
            navigationItem.searchController?.searchBar.isUserInteractionEnabled = true
        } else if (randomNumber < 60) {
            weatherItem.backgroundColor = UIColor.init(red: 1.0, green: 0.8, blue: 0.0, alpha: 1.0)
            goToPaketeButton.backgroundColor = UIColor.init(red: 1.0, green: 0.8, blue: 0.0, alpha: 1.0)
            //self.dialogView.backgroundColor = UIColor.init(red: 1.0, green: 0.8, blue: 0.0, alpha: 0.95)
            navigationItem.searchController?.searchBar.placeholder = "Turbulenzen möglich"
            navigationItem.searchController?.searchBar.isUserInteractionEnabled = true
        } else {
            weatherItem.backgroundColor = UIColor.init(red: 0.75, green: 0.0, blue: 0.0, alpha: 1.0)
            navigationItem.searchController?.searchBar.placeholder = "Keine Flüge bei Unwetter"
            navigationItem.searchController?.searchBar.isUserInteractionEnabled = false
        }
    }

    @IBAction func generateWeather(_ sender: UIButton) {
        updateWeather()
    }
    
    func centerMapOnLocation(location: CLLocation) {
        let regionRadius: CLLocationDistance = 350
        let coordinateRegion = MKCoordinateRegionMakeWithDistance(location.coordinate, regionRadius, regionRadius)
        mapView.setRegion(coordinateRegion, animated: true)
    }
    
}
