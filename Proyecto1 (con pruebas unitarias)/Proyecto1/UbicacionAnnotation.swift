//
//  UbicacionAnnotation.swift
//  Proyecto1
//
//  Created by Brandon Escalante on 29/10/20.
//  Copyright © 2020 Brandon Escalante. All rights reserved.
//

import Foundation
import MapKit

class UbicacionAnnotation : MKPointAnnotation {
    var ubicacion: Ubicacion!
    var onUpdateAnnotation : ((Ubicacion) -> Void)?
    
    func actualizarUbicacion(titulo: String, latitud: Double, longitud: Double, completion: @escaping(Ubicacion) -> Void) {
        ubicacion.titulo = titulo;
        ubicacion.latitud = latitud;
        ubicacion.longitud = longitud
        self.coordinate = CLLocationCoordinate2DMake(latitud, longitud)
        self.title = titulo
        
        if let handler = onUpdateAnnotation {
            handler(ubicacion)
            completion(ubicacion)
        }
    }
}
