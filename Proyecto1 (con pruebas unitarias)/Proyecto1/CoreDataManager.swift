//
//  CoreDataManager.swift
//  Proyecto1
//
//  Created by Brandon Escalante on 29/10/20.
//  Copyright © 2020 Brandon Escalante. All rights reserved.
//

import Foundation
import CoreData
import MapKit

class CoreDataManager {
    
    var container: NSPersistentContainer
    
    init() {
        container = NSPersistentContainer(name: "Encuesta")
        
        container.loadPersistentStores { (desc, error) in
            if let mensaje = error {
                print("Error: \(mensaje)")
                return
            }
            print("Encuesta cargada correctamente!")
        }
    }
    
    func guardarUbicacion(titulo: String, latitud: Double, longitud: Double, complete: @escaping(Ubicacion) -> Void) {
        let context = container.viewContext
        let id = getUbicacionesCount() + 1
        
        let ubicacion = Ubicacion(context: context)
        ubicacion.id = Int64(id)
        ubicacion.titulo = titulo
        ubicacion.latitud = latitud
        ubicacion.longitud = longitud
        
        do {
            try context.save()
            complete(ubicacion)
        } catch {
            print("Error: \(error)")
        }
    }
    
    func crearEntrevista(ubicacion: Ubicacion, nombre: String, complete: @escaping(Entrevista) -> Void){
        let context = container.viewContext
        
        let entrevista = Entrevista(context: context)
        if let entrevistas = ubicacion.entrevistas {
            entrevista.id = Int32(entrevistas.count + 1)
        } else {
            entrevista.id = 1
        }
        entrevista.nombre = nombre
        entrevista.fecha = Date()
        entrevista.url = "entrevista-\(ubicacion.id)-\(entrevista.id)"
        entrevista.ubicacion = ubicacion
        ubicacion.addToEntrevistas(entrevista)
        
        do {
            try context.save()
            complete(entrevista)
        } catch {
            print("Error: \(error)")
        }
    }
    
    func save(complete: @escaping() -> Void){
        let context = container.viewContext
        
        do {
            try context.save()
            complete()
        } catch {
            print("Error: \(error)")
        }
    }
    
    func getUbicacionesCount() -> Int {
        let context = container.viewContext
        let fetchRequest = NSFetchRequest<Ubicacion>(entityName: "Ubicacion")
        
        do {
            let resultado = try context.fetch(fetchRequest)
            return resultado.count
        } catch {
            print("Error: \(error)")
        }
        return 0
    }
    
    func getEntrevistasCount() -> Int {
        let context = container.viewContext
        let fetchRequest = NSFetchRequest<Entrevista>(entityName: "Entrevista")
        
        do {
            let resultado = try context.fetch(fetchRequest)
            return resultado.count
        } catch {
            print("Error: \(error)")
        }
        return 0
    }
    
    func getUbicaciones() -> [Ubicacion] {
        let context = container.viewContext
        let fetchRequest = NSFetchRequest<Ubicacion>(entityName: "Ubicacion")
        
        do {
            let resultado = try context.fetch(fetchRequest)
            return resultado
        } catch {
            print("Error: \(error)")
        }
        return []
    }
    
    func getUbicaciones(workRegion: WorkRegion) -> [Ubicacion] {
        let context = container.viewContext
        let fetchRequest = NSFetchRequest<Ubicacion>(entityName: "Ubicacion")
        
        do {
            let resultado = try context.fetch(fetchRequest)
            let ubicacionesEnRegion = resultado.filter { ubicacion in
                let coordenada = CLLocationCoordinate2DMake(ubicacion.latitud, ubicacion.longitud)
                return workRegion.containsPoint(location: coordenada)
            }
            return ubicacionesEnRegion
        } catch {
            print("Error: \(error)")
        }
        return []
    }
    
    func clearUbicaciones() -> Bool {
        let context = container.viewContext
        let fetchRequest = NSFetchRequest<Ubicacion>(entityName: "Ubicacion")
        let deleteBatch = NSBatchDeleteRequest(fetchRequest: fetchRequest as! NSFetchRequest<NSFetchRequestResult>)
        do {
            try context.execute(deleteBatch)
            return true
        } catch {
            print("Error: \(error)")
        }
        return false
    }
    
    
}
