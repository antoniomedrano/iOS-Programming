//
//  MapViewController.swift
//  WorldTrotter
//
//  Created by Antonio Medrano on 3/9/17.
//  Copyright © 2017 Antonio Medrano. All rights reserved.
//

import UIKit
import MapKit

class MapViewController: UIViewController, MKMapViewDelegate, CLLocationManagerDelegate {
    
    // MKMapViewDelegate and CLLocationManagerDelegate help us with the Chapter 6 Silver Challenge:
    // Add a user localization button.
    var mapView: MKMapView!
    var locationManager: CLLocationManager!
    
    override func loadView() {
        
        // Create a map view
        mapView = MKMapView()
        mapView.delegate = self
        locationManager = CLLocationManager()
        locationManager.delegate = self
        
        // Set it as *the* view of this view controller
        view = mapView
        
        // Add segmented control buttons
        let standardString = NSLocalizedString("Standard", comment: "Standard map view")
        let satelliteString = NSLocalizedString("Satellite", comment: "Satellite map view")
        let hybridString = NSLocalizedString("Hybrid", comment: "Hybrid map view")

        let segmentedControl = UISegmentedControl(items: [standardString, hybridString, satelliteString])
        
        segmentedControl.backgroundColor = UIColor.white.withAlphaComponent(0.5)
        segmentedControl.selectedSegmentIndex = 0
        
        segmentedControl.addTarget(self, action: #selector(MapViewController.mapTypeChanged(_:)), for: .valueChanged)
        
        segmentedControl.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(segmentedControl)
        
        let topConstraint = segmentedControl.topAnchor.constraint(equalTo: topLayoutGuide.bottomAnchor, constant: 8)
        let margins = view.layoutMarginsGuide
        let leadingConstraint = segmentedControl.leadingAnchor.constraint(equalTo: margins.leadingAnchor)
        let trailingConstraint = segmentedControl.trailingAnchor.constraint(equalTo: margins.trailingAnchor)
        
        topConstraint.isActive = true
        leadingConstraint.isActive = true
        trailingConstraint.isActive = true
        
        // Initialize user location button
        initLocalizationButton(segmentedControl)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("MapViewController loaded its view.")
    }
    
    func mapTypeChanged(_ segControl: UISegmentedControl) {
        switch segControl.selectedSegmentIndex {
        case 0:
            mapView.mapType = .standard
        case 1:
            mapView.mapType = .hybrid
        case 2:
            mapView.mapType = .satellite
        default:
            break
        }
    }
    
    func initLocalizationButton(_ anyView: UIView!){
        
        // add a button that when pressed zooms to the user's location
        let localizationButton = UIButton.init(type: .system)
        localizationButton.setTitle("🎯", for: .normal)
        localizationButton.backgroundColor = UIColor.white.withAlphaComponent(0.5)
        localizationButton.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(localizationButton)
        localizationButton.layer.cornerRadius = 5
        localizationButton.layer.borderWidth = 1
        localizationButton.layer.borderColor = UIColor.black.cgColor
        
        //Constraints
        
        //Puts button at text width in the lower left
        let bottomConstraint = localizationButton.bottomAnchor.constraint(equalTo:bottomLayoutGuide.topAnchor, constant: -24 )
        let leadingConstraint = localizationButton.leadingAnchor.constraint(equalTo: view.layoutMarginsGuide.leadingAnchor)
        bottomConstraint.isActive = true
        leadingConstraint.isActive = true
        
        // This puts button full screen width and right under the segmented control
        //let topConstraint = localizationButton.topAnchor.constraint(equalTo:anyView.topAnchor, constant: 32 )
        //let leadingConstraint = localizationButton.leadingAnchor.constraint(equalTo: view.layoutMarginsGuide.leadingAnchor)
        //let trailingConstraint = localizationButton.trailingAnchor.constraint(equalTo: view.layoutMarginsGuide.trailingAnchor)
        //topConstraint.isActive = true
        //leadingConstraint.isActive = true
        //trailingConstraint.isActive = true
        
        localizationButton.addTarget(self, action: #selector(MapViewController.showLocalization(sender:)), for: .touchUpInside)
        // LOOK UP # and (sender:)
    }
    
    func showLocalization(sender: UIButton!){
        locationManager.requestWhenInUseAuthorization() //check that user location is authorized in info.plist
        mapView.showsUserLocation = true //fire up the method mapView(_ mapView: MKMapView, didUpdate userLocation: MKUserLocation)    /////////// LOOK THIS UP
        mapView.userTrackingMode = .follow   //////// LOOK THIS UP
    }
    
    func mapView(_ mapView: MKMapView, didUpdate userLocation: MKUserLocation) {
        //This is a method from MKMapViewDelegate, fires up when the user`s location changes
        let zoomedInCurrentLocation = MKCoordinateRegionMakeWithDistance(userLocation.coordinate, 500, 500)
        mapView.setRegion(zoomedInCurrentLocation, animated: true)
    }
}
