//
//  MapViewController.swift
//  stopwatch
//
//  Created by Wittmayer,Jack T on 2/17/20.
//  Copyright © 2020 Jack Wittmayer. All rights reserved.
//

import UIKit
import MapKit

class MapViewController: UIViewController {
    
    private let locationManager = CLLocationManager()
    private var currentCoordinate: CLLocationCoordinate2D?
    @IBOutlet weak var mapView: MKMapView!
    override func viewDidLoad() {
        super.viewDidLoad()
        configureLocationServices()

        // Do any additional setup after loading the view.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    private func configureLocationServices()
    {
        locationManager.delegate = self
        
        let status = CLLocationManager.authorizationStatus()
        
        if status == .notDetermined
        {
            locationManager.requestWhenInUseAuthorization()
        }
        else if status == .authorizedAlways || status == .authorizedWhenInUse
        {
            mapView.showsUserLocation = true
            locationManager.desiredAccuracy = kCLLocationAccuracyBestForNavigation
            locationManager.startUpdatingLocation()
        }
    }
    
    private func beginLocationUpdates(locationManager: CLLocationManager)
    {
        mapView.showsUserLocation = true
        locationManager.desiredAccuracy = kCLLocationAccuracyBestForNavigation
        locationManager.startUpdatingLocation()
    }
    private func zoomToLatestLocation(with coordinate: CLLocationCoordinate2D)
    {
        let zoomRegion = MKCoordinateRegion.init(center: coordinate, latitudinalMeters: 10000, longitudinalMeters: 10000)
        mapView.setRegion(zoomRegion, animated: true)
    }
}

extension MapViewController: CLLocationManagerDelegate
{
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        print("Did get latest location")
        
        guard let latestLocation = locations.first else {return}
        
        if currentCoordinate == nil
        {
            zoomToLatestLocation(with: latestLocation.coordinate)
        }
        currentCoordinate = latestLocation.coordinate
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        print("The status changed.")
        if status == .authorizedAlways || status == .authorizedWhenInUse
        {
            beginLocationUpdates(locationManager: manager)
        }
    }
}
