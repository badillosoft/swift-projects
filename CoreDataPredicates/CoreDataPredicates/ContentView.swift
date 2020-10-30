//
//  ContentView.swift
//  CoreDataPredicates
//
//  Created by Dragon on 28/10/20.
//

import SwiftUI
//import Combine

/*class ViewContext: BindableObject {
    
}*/

/*extension View {
    func onLoad(perform action: (() -> Void)? = nil) -> some View {
        var actionPerformed = false
        return self.onAppear {
            guard !actionPerformed else {
                return
            }
            actionPerformed = true
            action?()
        }
    }
}*/

struct ContentView: View {
    @State var personas = [Persona]()
    var manager = CoreDataManager()
    @State private var selection = SegmentoEdad.Todos.rawValue
    
    //@EnvironmentObject var context : ViewContext
    
    var body: some View {
        VStack {
            Button(action: {
                manager.populatePersonas(times: 100) {
                    print("Generando 100 personas")
                    personas = manager.getPersonasInSegmento(segmento: SegmentoEdad(rawValue: selection)!)
                    print("total personas \(personas.count)")
                }
            }) {
                Text("Cargar 100 personas")
            }
            
            Picker(selection: $selection, label: /*@START_MENU_TOKEN@*/Text("Picker")/*@END_MENU_TOKEN@*/) /*@START_MENU_TOKEN@*/{
                Text("Todos").tag(SegmentoEdad.Todos.rawValue)
                Text("Infante").tag(SegmentoEdad.Infante.rawValue)
                Text("Adolescente").tag(SegmentoEdad.Adolescente.rawValue)
                Text("Joven").tag(SegmentoEdad.Joven.rawValue)
                Text("Adulto").tag(SegmentoEdad.Adulto.rawValue)
                Text("Mayor").tag(SegmentoEdad.Mayor.rawValue)
            }.onChange(of: selection, perform: {
                _ in
                print("seleccionado \(selection)")
                personas = manager.getPersonasInSegmento(segmento: SegmentoEdad(rawValue: selection)!)
            })/*@END_MENU_TOKEN@*/
            
            List(personas, id: \.self) {
                persona in
                persona.nombre.map(Text.init)
            }
        }
        .padding()
        .onAppear {
            loadPersonas()
            print("Cargando vista")
        }
    }
    
    func loadPersonas() {
        /*manager.populatePersonas(times: 100) {
            print("Personas listas")
            personas = manager.getPersonasInSegmento(segmento: .Todos)
            print("personas \(personas)")
        }*/
        personas = manager.getPersonasInSegmento(segmento: .Todos)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        let personas = ["Pepe", "Paco", "Pedro", "Alfred"]
        ContentView()
    }
}
