//
//  CoreDataManager.swift
//  CoreDataPredicates
//
//  Created by Dragon on 28/10/20.
//

import Foundation
import CoreData

enum SegmentoEdad: Int {
    case Todos = -1
    case Infante = 0
    case Adolescente = 12
    case Joven = 16
    case Adulto = 21
    case Mayor = 65
    // Este range pertence a la intancia (accede a un self)
    // Ejemplo .Infante.range() -> (0, 12)
    func range() -> (Int, Int) {
        let inf = self.rawValue
        var sup: Int
        switch self {
            case .Infante:
                sup = SegmentoEdad.Adolescente.rawValue
            case .Adolescente:
                sup = SegmentoEdad.Joven.rawValue
            case .Joven:
                sup = SegmentoEdad.Adulto.rawValue
            case .Adulto:
                sup = SegmentoEdad.Mayor.rawValue
            default:
                sup = Int(Int16.max)
        }
        return (inf, sup)
    }
    // Este range es independiente de una enumeración instanciada (no accede a un self)
    // Ejemplo SegmentoEdad.range(.Infante) -> (0, 12)
    static func range(segmento: SegmentoEdad) -> (Int, Int) {
        let inf = segmento.rawValue
        var sup: Int
        switch segmento {
            case .Infante:
                sup = SegmentoEdad.Adolescente.rawValue
            case .Adolescente:
                sup = SegmentoEdad.Joven.rawValue
            case .Joven:
                sup = SegmentoEdad.Adulto.rawValue
            case .Adulto:
                sup = SegmentoEdad.Mayor.rawValue
            default:
                sup = Int(Int16.max)
        }
        return (inf, sup)
    }
}

class CoreDataManager {
    
    var container: NSPersistentContainer
    
    init() {
        container = NSPersistentContainer(name: "Encuestas")
        
        container.loadPersistentStores {
            (desc, error) in
            if let message = error {
                print("Error: \(message)")
                return
            }
            
            print("Persona container ready")
        }

    }
    
    func populatePersonas(times: Int, complete: @escaping() -> Void) {
        let context = container.viewContext
        
        for i in 0...times {
            let persona = Persona(context: context)
            persona.edad = Int16.random(in: 18...100)
            persona.nombre = "Persona \(i + 1) Edad \(persona.edad)"
            
        }
        
        do {
            try context.save()
            complete()
        } catch {
            print("Error \(error)")
        }
    }
    
    func getPersonasInSegmento(segmento: SegmentoEdad) -> [Persona] {
        let context = container.viewContext
        
        //let (inf, sup) = SegmentoEdad.range(segmento: segmento)
        let (inf, sup) = segmento.range()
        
        print("inf \(inf) sup \(sup) segmento \(segmento)")
        
        let fetchRequest = NSFetchRequest<Persona>(entityName: "Persona")
        
        fetchRequest.predicate = NSPredicate(format: "edad >= %i AND edad < %i", inf, sup)
        
        do {
            let result = try context.fetch(fetchRequest)
            
            return result
        } catch {
            print("Error: \(error)")
        }
        
        return []
    }
}
