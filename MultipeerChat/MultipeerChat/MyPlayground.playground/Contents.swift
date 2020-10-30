class Persona {
    var nombre = "sin nombre"
    init(nombre: String) {
        self.nombre = nombre
    }
}

let personas = [
    Persona(nombre: "pepe"),
    Persona(nombre: "paco"),
    Persona(nombre: "luis"),
]

let nombres = personas.map{ persona in
    return persona.nombre
}

let nombres2 = personas.map{ persona in persona.nombre }

let nombres3 = personas.map{ $0.nombre }
