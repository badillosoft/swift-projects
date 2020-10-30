//
//  EditarAnotacionController.swift
//  Proyecto1
//
//  Created by Brandon Escalante on 29/10/20.
//  Copyright © 2020 Brandon Escalante. All rights reserved.
//

import Foundation
import  UIKit

class EditarAnotacionController: UIViewController {
    
    @IBOutlet weak var textTitulo: UITextField!
    @IBOutlet weak var textLatitud: UITextField!
    @IBOutlet weak var textLongitud: UITextField!
    
    var onUpdateData : ((String, Double, Double) -> Void)?
    
    var ubicacion: Ubicacion!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
    }
    
    func setup(){
        textTitulo.text = ubicacion.titulo
        textLatitud.text = "\(ubicacion.latitud)"
        textLongitud.text = "\(ubicacion.longitud)"
    }
    
    @IBAction func guardarAction(_ sender: Any) {
        //ubicacion.titulo = textTitulo.text
        
        if let handler = onUpdateData {
            handler(textTitulo.text!, Double(textLatitud.text!)!, Double(textLongitud.text!)!)
            self.dismiss(animated: true, completion: nil)
        }
    }
    
    func reciveUbicacion(ubicacion: Ubicacion) {
        self.ubicacion = ubicacion
    }
}
