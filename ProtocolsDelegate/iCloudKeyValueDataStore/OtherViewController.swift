//
//  OtherViewController.swift
//  iCloudKeyValueDataStore
//
//  Created by Dragon on 30/10/20.
//

import Foundation
import UIKit

/*struct Pokemon {
    var pokedexIndex: Int!
    var name: String!
}*/

protocol PokemonDataDelegate {
    
    //func setPokemonData(pokemon: Pokemon)
    func setPokemonData(pokedexId: Int, name: String)
    
}

class OtherViewController: UIViewController {
    @IBOutlet weak var labelInfo: UILabel!
    @IBOutlet weak var textField: UITextField!
    
    var delegate: PokedexActionDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func updateInfoAction(_ sender: Any) {
        if let delegate = self.delegate {
            if let text = self.textField.text {
                delegate.updatePokemonName(name: text)
            }
        }
    }
    
    @IBAction func sendEventAction(_ sender: Any) {
        if let delegate = self.delegate {
            delegate.demoAction(message: "Ahí te va un evento")
        }
    }
    
}

extension OtherViewController: PokemonDataDelegate {
    
    func setPokemonData(pokedexId: Int, name: String) {
        // TODO: Obtener la imagen del poken y mostarla
        labelInfo.text = "Pokemón: \(name) [\(pokedexId)]"
    }
    
}
