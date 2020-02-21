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
    
    private var destintations: [MKPointAnnotation] = []
    private var currentRoute: MKRoute?
    @IBOutlet weak var mapView: MKMapView!
    override func viewDidLoad() {
        super.viewDidLoad()
        configureLocationServices()
        mapView.delegate = self

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
    
    private func addAnnotations() {
        let chickfilaAnnotation = MKPointAnnotation()
        chickfilaAnnotation.title = "Chick-Fil-A"
        chickfilaAnnotation.coordinate = CLLocationCoordinate2D(latitude: 29.647371, longitude:  -82.342457)
        
        let freshFoodAnnotation = MKPointAnnotation()
        freshFoodAnnotation.title = "Fresh Food Company"
        freshFoodAnnotation.coordinate = CLLocationCoordinate2D(latitude: 29.647462, longitude: -82.34289)
        
        destintations.append(chickfilaAnnotation)
        destintations.append(freshFoodAnnotation)
        
        mapView.addAnnotation(chickfilaAnnotation)
        mapView.addAnnotation(freshFoodAnnotation)
    }
    private func constructRoute(userLocation: CLLocationCoordinate2D)
    {
        let directionsRequest = MKDirections.Request()
        directionsRequest.source = MKMapItem(placemark: MKPlacemark(coordinate: userLocation))
        directionsRequest.destination = MKMapItem(placemark: MKPlacemark(coordinate: destintations[0].coordinate))
        directionsRequest.requestsAlternateRoutes = true
        directionsRequest.transportType = .walking
        
        let directions = MKDirections(request: directionsRequest)
        directions.calculate { [weak self] (directionsResponse, error) in
            guard let strongSelf = self else {return}
            
            if let error = error
            {
                print(error.localizedDescription)
            }
            else if let response = directionsResponse, response.routes.count > 0
            {
                strongSelf.currentRoute = response.routes[0]
                
                strongSelf.mapView.addOverlay(response.routes[0].polyline)
                strongSelf.mapView.setVisibleMapRect(response.routes[0].polyline.boundingMapRect, animated: true)
            }
            
        }
        
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
            addAnnotations()
            constructRoute(userLocation: latestLocation.coordinate)
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

extension MapViewController: MKMapViewDelegate
{
    
    func mapView(_ _mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer
    {
        guard let currentRoute = currentRoute else {
            return MKOverlayRenderer()
        }
        let polyLineRenderer = MKPolylineRenderer(polyline: currentRoute.polyline)
        polyLineRenderer.strokeColor = UIColor.orange
        polyLineRenderer.lineWidth = 5
        return polyLineRenderer
    }
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView?
    {
        var annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: "Annotation View")
        if annotationView == nil
        {
            annotationView = MKAnnotationView(annotation: annotation, reuseIdentifier: "AnnotationView")
        }
        
        if let title = annotation.title, title == "Fresh Food Company"
        {
            annotationView?.image = resizeImage(image: UIImage(named: "running_icon")!, targetSize: CGSize(width: 50.0,height: 50.0))
        }
        else if let title = annotation.title, title == "Chick-Fil-A"
        {
            annotationView?.image = resizeImage(image: UIImage(named: "biking_icon")!, targetSize: CGSize(width: 50.0,height: 50.0))
        }
        else if annotation === mapView.userLocation
        {
            annotationView?.image = resizeImage(image: UIImage(named: "walking_icon")!, targetSize: CGSize(width: 50.0,height: 50.0))
        }
        
        annotationView?.canShowCallout = true
        return annotationView
    }
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        print("the annotation was selected: \(view.annotation?.title)")
    }
}
