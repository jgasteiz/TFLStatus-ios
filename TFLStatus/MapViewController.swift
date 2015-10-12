//
//  MapViewController.swift
//  TFLStatus
//
//  Created by Javi Manzano on 08/10/2015.
//  Copyright © 2015 Javi Manzano. All rights reserved.
//

import CoreLocation
import CoreData
import MapKit
import UIKit

class MapViewController: UIViewController, MKMapViewDelegate, CLLocationManagerDelegate {
    
    let regionRadius: CLLocationDistance = 1000
    
    let locationManager = CLLocationManager()
    
    var userLocated: Bool = false
    
    @IBOutlet weak var mapView: MKMapView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        // Ask for Authorisation from the User.
        self.locationManager.requestAlwaysAuthorization()
        // For use in foreground
        self.locationManager.requestWhenInUseAuthorization()
        
        mapView.showsUserLocation = true
        mapView.delegate = self
        
        self.fetchStations()
        
        if CLLocationManager.locationServicesEnabled() {
            self.locationManager.delegate = self
            self.locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
            self.locationManager.startUpdatingLocation()
        }
    }
    
    func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if userLocated == false {
            let locValue: CLLocationCoordinate2D = manager.location!.coordinate
            let coordinateRegion = MKCoordinateRegionMakeWithDistance(locValue,
                regionRadius * 2.0, regionRadius * 2.0)
            mapView.setRegion(coordinateRegion, animated: true)
            userLocated = true
        }
    }
    
    func mapView(mapView: MKMapView, viewForAnnotation annotation: MKAnnotation) -> MKAnnotationView? {
        if let annotation = annotation as? Station {
            let identifier = "pin"
            var view: MKPinAnnotationView
            if let dequeuedView = mapView.dequeueReusableAnnotationViewWithIdentifier(identifier)
                as? MKPinAnnotationView { // 2
                    dequeuedView.annotation = annotation
                    view = dequeuedView
            } else {
                view = MKPinAnnotationView(annotation: annotation, reuseIdentifier: identifier)
                view.canShowCallout = true
                view.calloutOffset = CGPoint(x: -5, y: 5)
                view.rightCalloutAccessoryView = UIButton(type: UIButtonType.ContactAdd)
                
            }
            return view
        }
        return nil
    }
    
    func mapView(mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        let station: Station = view.annotation as! Station
        
        // Create new entity
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        let moc = appDelegate.managedObjectContext
        
        let entity = NSEntityDescription.entityForName("FavoriteStation", inManagedObjectContext: moc)
        let favoriteStation = FavoriteStation(entity:entity!, insertIntoManagedObjectContext: moc)
        
        favoriteStation.setValue(station.id, forKey: "id")
        favoriteStation.setValue(station.name, forKey: "name")
        
        // save our entity
        do {
            try moc.save()
        } catch {
            fatalError("Failure to save context: \(error)")
        }
        
        performSegueWithIdentifier("showStatus", sender: self)
    }
    
    func fetchStations() -> Void {

        let fetchStatusTask = FetchStatusTask()
        var allStations: [Station] = fetchStatusTask.getStations()
        
        allStations = allStations.sort({$0.name < $1.name})
        
        // Add them to the map
        mapView.addAnnotations(allStations)
        mapView.showAnnotations(allStations, animated: false)
    }
}