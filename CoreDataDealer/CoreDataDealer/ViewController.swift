//
//  ViewController.swift
//  CoreDataDealer
//
//  Created by sergio nieto on 27/10/20.
//  Copyright © 2020 sergio nieto. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    var counter = 0
    private let manager = CoreDataManager()
    
    @IBOutlet weak var summaryLabel: UILabel! {
       didSet {
            summaryLabel.text = "Intento: \(counter)\r\nRegistros en la base: \(0)\r\nÚltimo registro: nil"
       }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }

    @IBAction func createRecords(_ sender: UIButton) {
        manager.createUser(name: "Juan", age: 19, lastName: "Perez", email: "juanp@gmail.com", initialAmount: 2000.5) { [weak self] in
            self?.updateUI()
        }
    }
    
    func updateUI() {
        counter = counter + 1
        let users = manager.fetchUsers()
        summaryLabel.text = "Intento: \(counter) \r\nRegistros en la base: \(users.count) \r\nÚltimo registro: \(users.last?.name)"
    }
    
    
    @IBAction func deleteRecords(_ sender: UIButton) {
        manager.deleteUsers()
        updateUI()
    }
    
}

