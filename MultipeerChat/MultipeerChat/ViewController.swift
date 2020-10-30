//
//  ViewController.swift
//  MultipeerChat
//
//  Created by Dragon on 30/10/20.
//

import UIKit

class ViewController: UIViewController {
    
    // Control de chat
    let chatService = ChatService()
    
    var devices = [String]()
    var messages = [String]()
    
    @IBOutlet weak var devicesLabel: UILabel!
    @IBOutlet weak var devicesTextView: UITextView!
    @IBOutlet weak var massagesLabel: UILabel!
    @IBOutlet weak var messagesTextView: UITextView!
    @IBOutlet weak var messageTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        // Delegamos acciones mediante el protocolo delegado
        chatService.deletegate = self
    }
    
    @IBAction func searchDevicesAction(_ sender: Any) {
        self.chatService.startBrowser()
    }
    
    @IBAction func sendMessageAction(_ sender: Any) {
        if let message = self.messageTextField.text {
            chatService.sendMessage(message: message)
        }
    }

}

extension ViewController: ChatServiceDelegate {
    
    func connectedDevicesChanged(manager: ChatService, connectedDevices: [String]) {
        self.devices = connectedDevices
        
        self.devicesLabel.text = "Dispositivos (\(self.devices.count))"
        var text = ""
        for device in self.devices {
            text += "\(device)\n"
        }
        self.devicesTextView.text = text
        
    }
    
    func messageReceived(manager: ChatService, message: String) {
        self.messages.append(message)
        
        self.massagesLabel.text = "Mensajes (\(self.messages.count))"
        var text = ""
        for message in self.messages {
            text += "\(message)\n"
        }
        self.messagesTextView.text = text
    }
    
}
