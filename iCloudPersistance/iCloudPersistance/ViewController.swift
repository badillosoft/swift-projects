//
//  ViewController.swift
//  iCloudPersistance
//
//  Created by Brandon Escalante on 30/10/20.
//  Copyright © 2020 Brandon Escalante. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var textLabel: UILabel!
    @IBOutlet weak var textEdit: UITextField!
    
    var keyValStore = NSUbiquitousKeyValueStore()
    

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }


    @IBAction func guardarAction(_ sender: Any) {
        
        let data = textEdit.text
        
        keyValStore.set(data, forKey: "data")
        keyValStore.synchronize()
    }
    
    
    @IBAction func cargarAction(_ sender: Any) {
        
        let newData = keyValStore.string(forKey: "data")
        keyValStore.synchronize()
        if let data = newData {
            textLabel.text = data
            print(data)
        }
        
    }
    
}

