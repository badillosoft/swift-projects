//
//  ViewController.swift
//  Proyecto1
//
//  Created by Brandon Escalante on 29/10/20.
//  Copyright © 2020 Brandon Escalante. All rights reserved.
//

import UIKit
import MapKit

class ViewController: UIViewController, MKMapViewDelegate{
    
    var manager = CoreDataManager()
    
    @IBOutlet weak var mapView: MKMapView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setup()
        
    }
    
    func setup(){
        mapView.delegate = self
        
        let location = CLLocationCoordinate2DMake(19.413044, -99.177307)
        let span = MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01)
        let region = MKCoordinateRegion(center: location, span: span)
        
        mapView.setRegion(region, animated: true)
        
        
        let longTapGesture = UILongPressGestureRecognizer(target: self, action: #selector(self.longTap(_:)))
        mapView.addGestureRecognizer(longTapGesture)
        
        //TODO: Recuperar los pines en CoreData
        for ubicacion in manager.getUbicaciones() {
            //let coordinate = CLLocationCoordinate2DMake(ubicacion.latitud, ubicacion.longitud)
            addAnnotation(ubicacion: ubicacion)
        }

    }


    @objc func longTap(_ sender: UIGestureRecognizer){
        if sender.state == .began {
            print("long tap")
            let locationInView = sender.location(in: mapView)
            let locationOnMap = mapView.convert(locationInView, toCoordinateFrom: mapView)
            manager.guardarUbicacion(titulo: "Sin titulo modificado", latitud: locationOnMap.latitude, longitud: locationOnMap.longitude) { [weak self] ubicacion in
                self?.addAnnotation(ubicacion: ubicacion)
            }
        }
    }
    
    func addAnnotation(ubicacion: Ubicacion) {
        let annotation = UbicacionAnnotation()
        annotation.ubicacion = ubicacion
        annotation.coordinate = CLLocationCoordinate2DMake(ubicacion.latitud, ubicacion.longitud)
        annotation.title = ubicacion.titulo
        
        annotation.onUpdateAnnotation = { ubicacion in
            self.manager.save {
                print("Ubicaciones actualizadas")
            }
        }
        
        mapView.addAnnotation(annotation)
    }
    
    
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        if let annotation = view.annotation {
            print("Anotacion de click: ", annotation.coordinate)
            //let viewController = VistaAnotacionController()
            /*self.present(viewController, animated: true) {
                () in 
                if annotation is MKPointAnnotation{
                    viewController.setAnnotation(annotation: annotation as! MKPointAnnotation)
                }
            }*/
            
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let vc = storyboard.instantiateViewController(withIdentifier: "vistaAnotacion") as! VistaAnotacionController
            self.present(vc, animated: true) {
                () in
                if annotation is MKPointAnnotation{
                    vc.setAnnotation(annotation: annotation as! UbicacionAnnotation)
                    vc.manager = self.manager
                }
            }
            
        }
    }

}

