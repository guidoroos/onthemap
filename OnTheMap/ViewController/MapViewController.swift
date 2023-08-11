//
//  MapViewController.swift
//  OnTheMap
//
//  Created by Guido Roos on 01/08/2023.
//

import Foundation
import MapKit
import UIKit

class MapViewController: OverviewViewController, MKMapViewDelegate {
    @IBOutlet var mapView: MKMapView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        mapView.delegate = self
        
        super.getUserLocations {
            //on completion
            self.spinner?.startAnimating()
            self.setupUserLocations()
            self.spinner?.stopAnimating()
        }
    }
    
    func setupUserLocations() {
        var annotations = [MKPointAnnotation]()
        
        
        for loc in StudentsData.sharedInstance().students {
            guard let latitude = loc.latitude,
                  let longitude = loc.longitude,
                  let firstName = loc.firstName,
                  let lastName = loc.lastName,
                  let mediaURL = loc.mediaURL
            else {
                return
            }
            
            let lat = CLLocationDegrees(latitude)
            let long = CLLocationDegrees(longitude)
            
            let coordinate = CLLocationCoordinate2D(latitude: lat, longitude: long)
            
            let annotation = MKPointAnnotation()
            annotation.coordinate = coordinate
            annotation.title = "\(firstName) \(lastName)"
            annotation.subtitle = mediaURL
            
            annotations.append(annotation)
        }
        
        // When the array is complete, we add the annotations to the map.
        mapView.addAnnotations(annotations)
    }
    
    
    // MARK: - MKMapViewDelegate
    
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        let reuseId = "pin"
        
        var pinView = mapView.dequeueReusableAnnotationView(withIdentifier: reuseId) as? MKMarkerAnnotationView
        
        if pinView == nil {
            pinView = MKMarkerAnnotationView(annotation: annotation, reuseIdentifier: reuseId)
            pinView!.canShowCallout = true
            pinView!.markerTintColor = .red
            pinView!.rightCalloutAccessoryView = UIButton(type: .detailDisclosure)
        } else {
            pinView!.annotation = annotation
        }
        
        return pinView
    }
    
    func mapView(_: MKMapView, annotationView: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        if control == annotationView.rightCalloutAccessoryView {
            if let subtitle = annotationView.annotation?.subtitle {
                var urlString = subtitle!
                if !urlString.hasPrefix("http://") && !urlString.hasPrefix("https://") {
                    urlString = "https://" + urlString
                }
                if let url = URL(string: urlString) {
                    UIApplication.shared.open(url, options: [:], completionHandler: nil)
                }
            }
        }
    }
}


