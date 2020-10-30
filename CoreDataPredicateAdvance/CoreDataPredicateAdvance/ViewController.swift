//
//  ViewController.swift
//  CoreDataPredicateAdvance
//
//  Created by Dragon on 28/10/20.
//

import UIKit

class ViewController: UIViewController {

    var manager = CoreDataManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        /*manager.createPersona(id: "uno", nombre: "Paco", edad: 16) {
            print("Persona creada")
        }*/
        
        /*manager.createEncuenta(id: "partido-politico", nombre: "Encuesta sobre partidos políticos", fechaInicio: Date(), fechaFin: Date()) {
            print("Encuesta creada")
        }*/
        
        /*manager.createPregunta(id: "partido", titulo: "A qué partido perteneces?", descripcion: "Selecciona algún partido", tipo: .Simple) {
            print("Pregunta creada")
        }*/
        
        /*if let personaUno = manager.getPersona(id: "uno") {
            print("Persona: \(personaUno.nombre!)")
            
            if let encuesta = manager.getEncuesta(id: "partido-politico") {
                print("Encuesta: \(encuesta.nombre!)")
                
                if let pregunta = manager.getPregunta(id: "partido") {
                    print("Pregunta: \(pregunta.titulo!)")
                    
                    pregunta.valor = "ND"
                    
                    encuesta.addToPreguntas(pregunta)
                }
                
                personaUno.addToEncuestas(encuesta)
            }
        }*/
        
        //print("----------------------------------------")
        
        //print(manager.getPersonaDescription(personaId: "uno"))
        
        // Responder una encuesta por persona
        
        let context = manager.container.viewContext
        
        // 1. Crear a la persona
        //let persona = Persona(context: context)
        //persona.nombre = "Pepe"
        
        // 2. Para una persona pueda responder su propia encuesta, debería brindar las
        // respuestas para su encuesta especìfica, la cuál se puede basar en una encuesta
        // ya defina y crearle una copia
        
        // 1. Crear / eliminar personas
        // 2. Seleccionar una persona en especìfico
        // 3. Abrir una encuesta en especìfico
        // 4. Obtener las respuestas de la encuesta (valores de las preguntas)
        // 5. Registrar las preguntas a la encuesta específica del usuario
        // 6. Registrar la encuesta específica a la persona
        
        // 1. Crear la persona
        /*manager.createPersona(id: "uno", nombre: "Paco", edad: 16) {
            print("Persona creada")
        }*/
        // 2. Seleccionar la persona
        let persona = manager.getPersona(id: "uno")!
        
        // 3. Seleccionar la encuesta plantilla
        let encuestaPlantilla = manager.getEncuesta(id: "partido-politico")!
        // 4. Seleccionar la pregunta plantilla
        let preguntaPlantilla = manager.getPregunta(id: "partido")!
        
        // 5. Crear la encuesta específica para la persona
        let encuestaPersona = Encuesta(context: manager.container.viewContext)
        encuestaPersona.id = "\(encuestaPlantilla.id!)-\(persona.id!)"
        encuestaPersona.nombre = encuestaPlantilla.nombre!
        encuestaPersona.addToPersonas(persona)
        
        
        // 6. Crear las preguntas/respuestas específicas para la encuesta específica
        let preguntaEncuesta = Pregunta(context: manager.container.viewContext)
        preguntaEncuesta.id = "\(preguntaPlantilla.id!)-\(encuestaPersona.id!)"
        preguntaEncuesta.titulo = preguntaPlantilla.titulo!
        preguntaEncuesta.descripcion = preguntaPlantilla.descripcion!
        preguntaEncuesta.tipo = preguntaPlantilla.tipo
        preguntaEncuesta.encuesta = encuestaPersona
        preguntaEncuesta.valor = "RESPUESTA"
        
        // preguntaId: partido-partido-politico-uno
        
        // 7. Agregar la encuesta específica de la persona a la persona
        persona.addToEncuestas(encuestaPersona)
        
        print("----------------------------------------")
        
        print(manager.getPersonaDescription(personaId: "uno"))
        
        let encuestasPorPersona = NSPredicate(format: "id == %@", "\(encuestaPlantilla.id)-\(persona.id)")
        
        let preguntaPorPersona = NSPredicate(format: "id == %@", "\(preguntaPlantilla.id)-*-\(persona.id)")
        
        let respuestasAPregunta = NSPredicate(format: "id == %@", "\(preguntaPlantilla.id)-*")
    }


}

