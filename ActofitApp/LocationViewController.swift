//
//  LocationViewController.swift
//  ActofitApp
//
//  Created by Apple on 10/03/22.
//

import UIKit
import MapKit

class LocationViewController: UIViewController  {
    let locationManager = CLLocationManager()
    let addAnotation = MKPointAnnotation()
    var timer: Timer?
    
    @IBOutlet weak var map: MKMapView!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        self.locationManager.requestAlwaysAuthorization()
        // For use in foreground
        self.locationManager.requestWhenInUseAuthorization()

        if CLLocationManager.locationServicesEnabled() {
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
            locationManager.startUpdatingLocation()
        }
        
        getUserLocation()
    }
    
    func getUserLocation() {
        locationManager.allowsBackgroundLocationUpdates = true
    }
}
extension LocationViewController: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let location = locations.last! as CLLocation
        addAnotation.title = "CURRENT LOCATION"
        addAnotation.coordinate = CLLocationCoordinate2D(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude)
        self.map.addAnnotation(addAnotation)
        let center = CLLocationCoordinate2D(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude)
        let region = MKCoordinateRegion(center: center, span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01))
        self.map.setRegion(region, animated: true)
        
        let locationString = String(location.coordinate.latitude) + String(location.coordinate.longitude)
        let documentDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
        let fileURL = documentDirectory.appendingPathComponent("LocationData.txt")
        if let handle = try? FileHandle(forWritingTo: fileURL) {
           handle.seekToEndOfFile() // moving pointer to the end
           handle.write(locationString.data(using: .utf8)!) // adding content
           handle.closeFile() // closing the file
       }
       
    }
    
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        
        guard annotation is MKPointAnnotation else { return nil }

        let identifier = "Annotation"
        var annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: identifier)

        if annotationView == nil {
            annotationView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: identifier)
            annotationView!.canShowCallout = true
        } else {
            annotationView!.annotation = annotation
        }

        return annotationView
    }

}
