//
//  WorkRegion.swift
//  Proyecto1
//
//  Created by Brandon Escalante on 30/10/20.
//  Copyright © 2020 Brandon Escalante. All rights reserved.
//

import Foundation
import MapKit

class WorkRegion : MKPolygon {
    
    func containsPoint(location: CLLocationCoordinate2D) -> Bool{
        let polygonRenderer = MKPolygonRenderer(polygon: self)
        let currentMapPoint = MKMapPoint(location)
        let polygonViewpoint = polygonRenderer.point(for: currentMapPoint)
        
        if polygonRenderer.path == nil {
            return false
        }
        
        return polygonRenderer.path.contains(polygonViewpoint)
    }
}
