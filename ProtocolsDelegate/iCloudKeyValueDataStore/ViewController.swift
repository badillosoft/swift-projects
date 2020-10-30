//
//  ViewController.swift
//  iCloudKeyValueDataStore
//
//  Created by Dragon on 28/10/20.
//

import UIKit

protocol PokedexActionDelegate {
    
    func updatePokemonName(name: String)
    
    func demoAction(message: String)
    
}

class ViewController: UIViewController {

    @IBOutlet weak var textField: UITextField!
    @IBOutlet weak var textViewEvents: UITextView!
    @IBOutlet weak var labelInformation: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }

    @IBAction func abrirOtraVistaAction(_ sender: Any) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        
        let otherViewController = storyboard.instantiateViewController(withIdentifier: "OtherViewController") as! OtherViewController
        
        self.present(otherViewController, animated: true) {
            print("La otra vista está cargada")
            // Si tiene la extensión que implementa al delagado
            otherViewController.delegate = self
            
            if let pokemonData = otherViewController as? PokemonDataDelegate {
                if let text = self.textField.text {
                    pokemonData.setPokemonData(pokedexId: 1, name: text)
                }
            }
        }
    }
    
}

extension ViewController: PokedexActionDelegate {
    
    func updatePokemonName(name: String) {
        labelInformation.text = "Ahora se llama \(name)?"
    }
    
    func demoAction(message: String) {
        print("Se ha recibido el mensaje \(message)")
        
        // TODO: Actualizar el textview con los eventos
    }
    
}
