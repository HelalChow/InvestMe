//
//  MapViewController.swift
//  investMe
//
//  Created by Helal Chowdhury on 3/7/20.
//  Copyright © 2020 Helal. All rights reserved.
//

import UIKit
import MapKit
import NotificationCenter


class MapViewController: UIViewController {

    
    @IBOutlet weak var mapView: MKMapView!
    var animator: UIViewPropertyAnimator?
    
    
    //Location Settings
    let locationManager = CLLocationManager()
    let regionInMeters: Double = 30000
    var currentCoordinate: CLLocationCoordinate2D?
    
    let markerTitle: String = "Get Directions"
    
    
     func centerViewOnUserLocation() {
              if let location = locationManager.location?.coordinate {
                  let region = MKCoordinateRegion.init(center: location, latitudinalMeters: regionInMeters, longitudinalMeters: regionInMeters)
                  mapView.setRegion(region, animated: true)
              }
          }
    
    func setupLocationManager() {
             locationManager.delegate = self
             locationManager.desiredAccuracy = kCLLocationAccuracyBest
         }
    
    func checkLocationServices() {
             if CLLocationManager.locationServicesEnabled() {
                 setupLocationManager()
                 checkLocationAuthorization()
             } else {
                 // Show alert letting the user know they have to turn this on.
             }
         }

    //best practices for location permishh settings
    func checkLocationAuthorization() {
        switch CLLocationManager.authorizationStatus() {
        case .authorizedWhenInUse:
            mapView.showsUserLocation = true
            centerViewOnUserLocation()
            locationManager.startUpdatingLocation()
            break
        case .denied:
            // Show alert instructing them how to turn on permissions
            break
        case .notDetermined:
            locationManager.requestWhenInUseAuthorization()
        case .restricted:
            // Show an alert letting them know what's up
            break
        case .authorizedAlways:
            break
        @unknown default:
          print("fatal error unkown in case chk location")
      }
    }
    
    //JSON DATA of DIner lat long magic here
    func addAnnotations(){
        let pinOne = MKPointAnnotation()
        pinOne.title = markerTitle
        pinOne.coordinate = CLLocationCoordinate2D(latitude: 40.692040, longitude: -73.987590)
        
        
        let pinTwo = MKPointAnnotation()
        pinTwo.title = markerTitle
        pinTwo.coordinate = CLLocationCoordinate2D(latitude: 40.7484, longitude: -73.9857)
        
        let timesSqaureAnnotation = MKPointAnnotation()
        timesSqaureAnnotation.title = markerTitle
        timesSqaureAnnotation.coordinate = CLLocationCoordinate2D(latitude: 40.6602, longitude: -73.9985)
       
        let empireStateAnnotation = MKPointAnnotation()
        empireStateAnnotation.title = markerTitle
        empireStateAnnotation.coordinate = CLLocationCoordinate2D(latitude: 40.7484, longitude: -73.9857)
       
        let brooklynBridge = MKPointAnnotation()
        brooklynBridge.title = markerTitle
        brooklynBridge.coordinate = CLLocationCoordinate2D(latitude: 40.714720, longitude: -73.991130)
       
        let prospectPark = MKPointAnnotation()
        prospectPark.title = markerTitle
        prospectPark.coordinate = CLLocationCoordinate2D(latitude: 40.6602, longitude: -73.9690)
       
        let jersey = MKPointAnnotation()
        jersey.title = markerTitle
        jersey.coordinate = CLLocationCoordinate2D(latitude: 40.7178, longitude: -74.0431)
        
        var geofenceList = [CLCircularRegion]()
        let locations = [timesSqaureAnnotation.coordinate, empireStateAnnotation.coordinate, brooklynBridge.coordinate, prospectPark.coordinate, jersey.coordinate]
        for coor in locations{
            geofenceList.append(CLCircularRegion(center: coor, radius: 800, identifier: "geofence"))
        }
        for fence in geofenceList {
            let circle = MKCircle(center: fence.center, radius: fence.radius)
            circle.title = fence.identifier
            mapView.addOverlay(circle)
        }
       
        mapView.addAnnotation(timesSqaureAnnotation)
        mapView.addAnnotation(empireStateAnnotation)
        mapView.addAnnotation(brooklynBridge)
        mapView.addAnnotation(prospectPark)
        mapView.addAnnotation(jersey)

        
        
//        mapView.addAnnotation(pinOne)
//        mapView.addAnnotation(pinTwo)
        
//        mapView.selectAnnotation(pinOne, animated: true)
//        mapView.selectAnnotation(pinTwo, animated: true)
    }
        
    //GPS ROUTE
     func showRoute() {
           let sourceLocation = currentCoordinate ?? CLLocationCoordinate2D(latitude: 40.692040, longitude: -73.9857)
           let destinationLocation = CLLocationCoordinate2D(latitude: 40.7484, longitude: -73.9857)
           
           let sourcePlaceMark = MKPlacemark(coordinate: sourceLocation)
           let destinationPlaceMark = MKPlacemark(coordinate: destinationLocation)
           
           let directionRequest = MKDirections.Request()
           directionRequest.source = MKMapItem(placemark: sourcePlaceMark)
           directionRequest.destination = MKMapItem(placemark: destinationPlaceMark)
           directionRequest.transportType = .automobile
           
           let directions = MKDirections(request: directionRequest)
           directions.calculate {(response, error) in
               guard let directionResponse = response else {
                   if let error = error{
                       print("There was an error getting directions==\(error.localizedDescription)")
                   }
                   return
               }
               let route = directionResponse.routes[0]
               self.mapView.addOverlay(route.polyline, level: .aboveRoads)
               
               let rect = route.polyline.boundingMapRect
                //below not being called set Region two more
               self.mapView.setRegion(MKCoordinateRegion(rect), animated: true)
           }
           
           self.mapView.delegate = self
       }
    


    func createBottomView() {
        guard let sub = storyboard!.instantiateViewController(withIdentifier: "CompanyViewController") as? CompanyViewController else { return }
        self.addChild(sub)
        self.view.addSubview(sub.view)
        sub.didMove(toParent: self)
        sub.view.frame = CGRect(x: 0, y: view.frame.maxY, width: view.frame.width, height: view.frame.height)
        sub.minimize(completion: nil)
    }

    func subViewGotPanned(_ percentage: Int) {
        guard let propAnimator = animator else {
            animator = UIViewPropertyAnimator(duration: 3, curve: .linear, animations: {
                self.mapView.alpha = 1
//                self.someView.transform = CGAffineTransform(scaleX: 0.8, y: 0.8).concatenating(CGAffineTransform(translationX: 0, y: -20))
            })
            animator?.startAnimation()
            animator?.pauseAnimation()
            return
        }
        propAnimator.fractionComplete = CGFloat(percentage) / 100
    }

    func receiveNotification(_ notification: Notification) {
        guard let percentage = notification.userInfo?["percentage"] as? Int else { return }
        subViewGotPanned(percentage)
    }
    
    //MARK BOTTOM VIEW SEGUE HERE

    override func viewDidLoad() {
        super.viewDidLoad()
        addAnnotations()
//        createBottomView()
        checkLocationServices()
        mapView.delegate = self
        

        let name = NSNotification.Name(rawValue: "BottomViewMoved")
        NotificationCenter.default.addObserver(forName: name, object: nil, queue: nil, using: receiveNotification(_:))
    }
    
    //alret notification
    @IBAction func alertButtonPressed(_ sender: Any) {
        createAlert(title: "A new startup near you is looking for investors", message: "Are you looking to invest?")
    }
    
    
    func createAlert (title: String, message: String){
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertController.Style.alert)
        
        alert.addAction(UIAlertAction(title: "Yes", style: UIAlertAction.Style.default))
            
        alert.addAction(UIAlertAction(title: "No", style: UIAlertAction.Style.default))
        
        self.present(alert, animated:true, completion: nil)
        
    }
}

extension MapViewController: CLLocationManagerDelegate {
      
      func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
            //Dif between last and first? ...locations.first / .last chk array in given input
          guard let latestLocation = locations.first else { return }
        
            //to make user location in center of mapview chnage the center coord
            //is there a cicumference for the span what user views
            //below span is the exact same as the setreigon above span is like pertange of lat long instead of 10k meters
           let span = MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05)
                 let region = MKCoordinateRegion(center: latestLocation.coordinate, span: span)
        
//          mapView.setRegion(region, animated: true)
        
          //invoke once at launch (most likely)
          if currentCoordinate == nil{
//              centerViewOnUserLocation()
              addAnnotations()
          }
          
          
          currentCoordinate = latestLocation.coordinate
      }
      
      //best practices to check and catch exceptions for location permisshh
      func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
          checkLocationAuthorization()
      }
    
    //GEOFENCES
    func locationManager(_ manager: CLLocationManager, didEnterRegion region: CLRegion) {
    print("centrer")
    }
     
    func locationManager(_ manager: CLLocationManager, didExitRegion region: CLRegion) {
    print("left")
    }
    
    /**Some where above
        let geoFenceRegion: CLCircularRegion = CLCircularRegion(center: CLLocationCoordinate2DMake(43.61871, -116.214607), radius: 100, identifier: "boise")
         
        locationManager.startMonitoring(for: geoFenceRegion)
    
     */
    
  }

extension MapViewController: MKMapViewDelegate {
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
          guard let circleOverlay = overlay as? MKCircle else { return MKOverlayRenderer()}
          let circleRenderer = MKCircleRenderer(circle: circleOverlay)
          circleRenderer.strokeColor = .blue
          circleRenderer.fillColor = .blue
          circleRenderer.alpha = 0.3
          return circleRenderer
    }
    
    //add pin hover
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        if annotation is MKUserLocation {
            //we dont want to do anything because of this is the blue dot we want only custom pins
            return nil
        }
        else{
            let pin = MKPinAnnotationView(annotation: annotation, reuseIdentifier: "pin")
            pin.canShowCallout = true
//            pin.image = UIImage(named: "office_icon")
            //the button when tapped goto gps
            pin.rightCalloutAccessoryView = UIButton(type: .detailDisclosure)
            return pin
        }
    }
    
    //segue to details vc
    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        createBottomView()
        showRoute() //for destination gps
//         let annView = view.annotation
//
//       let storyboard = UIStoryboard(name: "Main", bundle: Bundle.main)
//       guard let detailVC = storyboard.instantiateViewController(withIdentifier: "DineDetailsViewController") as? DineDetailsViewController else {
//           print("detals vc not founds")
//           return
//       }
//
//
//
//       self.navigationController?.pushViewController(detailVC, animated: true)
    }
    
    //color overlay over the geofences
//    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
//         let renderer = MKPolylineRenderer(overlay: overlay)
//               renderer.strokeColor = UIColor.blue
//               renderer.lineWidth = 4.0
//               return renderer
//    }
}
