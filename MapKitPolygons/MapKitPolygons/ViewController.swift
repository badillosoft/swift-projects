//
//  ViewController.swift
//  MapKitPolygons
//
//  Created by Dragon on 28/10/20.
//

import UIKit
import MapKit

class CustomPointAnnotation: MKPointAnnotation {
    var pinImage: String!
}

extension UIImage {
    func renderResizedImage (newWidth: CGFloat) -> UIImage {
        let scale = newWidth / self.size.width
        let newHeight = self.size.height * scale
        let newSize = CGSize(width: newWidth, height: newHeight)

        let renderer = UIGraphicsImageRenderer(size: newSize)

        let image = renderer.image { (context) in
            self.draw(in: CGRect(origin: CGPoint(x: 0, y: 0), size: newSize))
        }
        return image
    }
}

class ViewController: UIViewController, MKMapViewDelegate {

    @IBOutlet weak var mapView: MKMapView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        setupMap()
        
    }

    func setupMap() {
        mapView.delegate = self
        
        let location = CLLocationCoordinate2DMake(19.413044, -99.177307)
        let span = MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01)
        let region = MKCoordinateRegion(center: location, span: span)
        
        let annotation = MKPointAnnotation()
        annotation.coordinate = location
        
        let pinLocation = CLLocationCoordinate2DMake(19.412044, -99.176307)
        
        let customAnnotation = CustomPointAnnotation()
        customAnnotation.pinImage = "my_pin.png"
        customAnnotation.coordinate = pinLocation
        
        mapView.addAnnotation(annotation)
        
        mapView.addAnnotation(customAnnotation)
        
        mapView.setRegion(region, animated: true)
        
        addPolygonRegion()
        
        addPolyline()
    }
    
    func addPolyline() {
        let points = [
            CLLocationCoordinate2DMake(19.412044, -99.176307),
            CLLocationCoordinate2DMake(19.414044, -99.177307),
            CLLocationCoordinate2DMake(19.412044, -99.178307)
        ]
        
        let polyline = MKPolyline(coordinates: points, count: points.count)
        
        mapView.addOverlay(polyline)
    }
    
    func addPolygonRegion() {
        let points = [
            CLLocationCoordinate2DMake(19.412044, -99.176307),
            CLLocationCoordinate2DMake(19.412044, -99.178307),
            CLLocationCoordinate2DMake(19.414044, -99.178307),
            CLLocationCoordinate2DMake(19.414044, -99.176307)
        ]
        
        let polygon = MKPolygon(coordinates: points, count: points.count)
        
        mapView.addOverlay(polygon)
    }
    
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        if overlay is MKPolygon {
            let polygonView = MKPolygonRenderer(overlay: overlay)
            polygonView.fillColor = UIColor(red: 0, green: 0, blue: 1, alpha: 0.1)
            return polygonView
        }
        
        if overlay is MKPolyline {
            let polylineView = MKPolylineRenderer(overlay: overlay)
            polylineView.strokeColor = UIColor.red
            polylineView.lineWidth = 4
            return polylineView
        }
        
        return MKOverlayRenderer(overlay: overlay)
    }
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        if let customAnnotation = annotation as? CustomPointAnnotation {
            
            let customAnnotationView = MKPinAnnotationView(annotation: customAnnotation, reuseIdentifier: "pin")
            
            let pinImage = UIImage(named: customAnnotation.pinImage)!.renderResizedImage(newWidth: 50)
            
            customAnnotationView.image = pinImage
            
            return customAnnotationView
        }
        
       return nil
    }

}

