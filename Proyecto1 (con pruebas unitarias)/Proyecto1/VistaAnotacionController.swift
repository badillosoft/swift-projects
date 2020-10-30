//
//  VistaAnotacion.swift
//  Proyecto1
//
//  Created by Brandon Escalante on 29/10/20.
//  Copyright © 2020 Brandon Escalante. All rights reserved.
//

import Foundation
import UIKit
import MapKit

class VistaAnotacionController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    var anotacion : UbicacionAnnotation?
    @IBOutlet weak var tituloAnotacion: UILabel!
    @IBOutlet weak var latitud: UILabel!
    @IBOutlet weak var longitud: UILabel!
    @IBOutlet weak var tableView: UITableView!
    
    public var manager : CoreDataManager!
    
    var entrevistaSeleccionada : Entrevista?
    
    override func viewDidLoad(){
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        
    }
    
    func setAnnotation(annotation: UbicacionAnnotation) {
        
        if let title = annotation.title {
            tituloAnotacion.text = "\(title) [\(annotation.ubicacion!.id)]"
        }
        latitud.text = "\(annotation.coordinate.latitude)"
        longitud.text = "\(annotation.coordinate.longitude)"
        
        //TODO:
        //Cargar la informacion realacionada a la anotación desde el core data
        self.anotacion = annotation
        tableView.reloadData()
        
    }
    
    
    @IBAction func editarAnotacion(_ sender: UIButton) {
        /*if let annotation = anotacion {
            annotation.actualizarUbicacion(titulo: "Titulo cambiado", latitud: annotation.ubicacion.latitud, longitud: annotation.ubicacion.longitud) { [weak self] ubicacion in
                
                self?.latitud.text = "\(ubicacion.latitud)"
                self?.longitud.text = "\(ubicacion.longitud)"
                self?.tituloAnotacion.text = "\(ubicacion.titulo!) [\(ubicacion.id)]"
            }
        }*/
    }
    
    
    @IBAction func agregarGrabacionAction(_ sender: Any) {
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let viewController = segue.destination as? EditarAnotacionController {
            if let anotacion = self.anotacion {
                viewController.reciveUbicacion(ubicacion: anotacion.ubicacion)
                
                viewController.onUpdateData = { (titulo, latitud, longitud) in
                    
                    anotacion.actualizarUbicacion(titulo: titulo, latitud: latitud, longitud: longitud) { [weak self] ubicacion in
                        
                        self?.latitud.text = "\(ubicacion.latitud)"
                        self?.longitud.text = "\(ubicacion.longitud)"
                        self?.tituloAnotacion.text = "\(ubicacion.titulo!) [\(ubicacion.id)]"
                    }
                }
            }
        }
        
        if let viewController = segue.destination as? SoundRecordController {
            //TODO: Crear la entrevista, recibirla y enviarla al SoundRecordController
            if let anotacion = self.anotacion {
                manager.crearEntrevista(ubicacion: anotacion.ubicacion, nombre: "sin-nombre") { entrevista in
                    viewController.entrevista = entrevista
                    
                    viewController.onFinalizado = { entrevista in
                        self.manager.save {
                            print("Contexto actualizado")
                        }
                    }
                }
            }
        }
        
        if let viewController = segue.destination as? SounPlayerController {
            if let entrevista = self.entrevistaSeleccionada {
                viewController.entrevista = entrevista
            }
        }
    }
    
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let annotation = self.anotacion{
            if let entrevistas = annotation.ubicacion.entrevistas {
                return entrevistas.count
            }
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let annotation = self.anotacion{
            if let entrevistas = annotation.ubicacion.entrevistas {
                if let cell = tableView.dequeueReusableCell(withIdentifier: "tableCell") {
                    let entrevista = (entrevistas.allObjects as! [Entrevista])[indexPath.row]
                    cell.textLabel?.text = "(\(entrevista.id)) \(entrevista.nombre!) \(entrevista.fecha!)"
                    return cell
                }
                
            }
        }
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let annotation = self.anotacion{
            if let entrevistas = annotation.ubicacion.entrevistas {
                entrevistaSeleccionada = (entrevistas.allObjects as! [Entrevista])[indexPath.row]
                let storyboard = UIStoryboard(name: "Main", bundle: nil)
                let vc = storyboard.instantiateViewController(withIdentifier: "soundController") as! SounPlayerController
                self.present(vc, animated: true) {
                   () in
                    vc.entrevista = self.entrevistaSeleccionada
                    vc.setup()
               }
            }
        }
    }
    
    
}
