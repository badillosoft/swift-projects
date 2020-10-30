//
//  CoreDataManager.swift
//  CoreDataPredicateAdvance
//
//  Created by Dragon on 28/10/20.
//

import Foundation
import CoreData

enum PreguntaTipo: Int16 {
    case Simple = 0
    case Multiple
    case Abierta
}

class CoreDataManager {
    
    var container : NSPersistentContainer
    
    init() {
        container = NSPersistentContainer(name: "Encuestas")
        
        container.loadPersistentStores {
            (desc, error) in
            if let error = error {
                print("Error: \(error)")
                return
            }
            print("CoreData Encuestas cargadas")
        }
    }
    
    func createPersona(id: String, nombre: String, edad: Int16, complete: @escaping() -> Void) {
        let context = container.viewContext
        
        let persona = Persona(context: context)
        
        persona.id = id
        persona.nombre = nombre
        persona.edad = edad
        
        do {
            try context.save()
            complete()
        } catch {
            print("Error: \(error)")
        }
    }
    
    func createEncuenta(id: String, nombre: String, fechaInicio: Date, fechaFin: Date, complete: @escaping() -> Void) {
        let context = container.viewContext
        
        let encuesta = Encuesta(context: context)
        
        encuesta.id = id
        encuesta.nombre = nombre
        encuesta.fechaInicio = fechaInicio
        encuesta.fechaFin = fechaFin
        
        do {
            try context.save()
            complete()
        } catch {
            print("Error: \(error)")
        }
    }
    
    func createPregunta(id: String, titulo: String, descripcion: String, tipo: PreguntaTipo, complete: @escaping() -> Void) {
        let context = container.viewContext
        
        let pregunta = Pregunta(context: context)
        
        pregunta.id = id
        pregunta.titulo = titulo
        pregunta.descripcion = descripcion
        pregunta.tipo = tipo.rawValue
        
        do {
            try context.save()
            complete()
        } catch {
            print("Error: \(error)")
        }
    }
    
    func getPersona(id: String) -> Persona? {
        let fetchRequest = NSFetchRequest<Persona>(entityName: "Persona")
        fetchRequest.predicate = NSPredicate(format: "id == %@", id)
        do {
            let result = try container.viewContext.fetch(fetchRequest)
            return result.first
        } catch {
            print("Error: \(error)")
        }
        return nil
    }
    
    func getEncuesta(id: String) -> Encuesta? {
        let fetchRequest = NSFetchRequest<Encuesta>(entityName: "Encuesta")
        fetchRequest.predicate = NSPredicate(format: "id == %@", id)
        do {
            let result = try container.viewContext.fetch(fetchRequest)
            return result.first
        } catch {
            print("Error: \(error)")
        }
        return nil
    }
    
    func getPregunta(id: String) -> Pregunta? {
        let fetchRequest = NSFetchRequest<Pregunta>(entityName: "Pregunta")
        fetchRequest.predicate = NSPredicate(format: "id == %@", id)
        do {
            let result = try container.viewContext.fetch(fetchRequest)
            return result.first
        } catch {
            print("Error: \(error)")
        }
        return nil
    }
    
    func agregarEncuestaPersona(persona: Persona, encuesta: Encuesta) {
        let encuestas = persona.mutableSetValue(forKey: "encuestas")
        encuestas.add(encuesta)
    }
    
    func agregarPreguntaEncuesta(encuesta: Encuesta, pregunta: Pregunta) {
        let preguntas = encuesta.mutableSetValue(forKey: "preguntas")
        preguntas.add(pregunta)
    }
    
    func responderPregunta(preguntaId: String, valor: String) {
        let pregunta = getPregunta(id: preguntaId)
        pregunta?.valor = valor
    }
    
    func getPersonaDescription(personaId: String) -> String {
        var report = ""
        if let persona = getPersona(id: personaId) {
            report += "Persona: \(persona.nombre!) [\(persona.id!)]\n"
            report += "Edad: \(persona.edad)\n\n"
            for encuesta in persona.encuestas?.allObjects as! [Encuesta] {
                report += "Encuesta: \(encuesta.nombre!)\n\n"
                for pregunta in encuesta.preguntas!.allObjects as! [Pregunta] {
                    report += "Pregunta: \(pregunta.titulo!)\n"
                    report += "Descripción: \(pregunta.descripcion!)\n"
                    report += "Tipo: \(PreguntaTipo(rawValue: pregunta.tipo))\n"
                    report += "Respuesta: \(pregunta.valor!)\n"
                }
            }
        }
        return report
    }
    
    /*func getEncuestasReport() -> String {
        
    }
    
    func getPersonaReport(persona: Persona) -> String {
        
    }*/
    
    
}
