//
//  ViewController.swift
//  CallingMessagingMailing
//
//  Created by Dragon on 30/10/20.
//

import UIKit
import MessageUI
import ContactsUI

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }

    @IBAction func sendMessage(_ sender: Any) {
        if MFMessageComposeViewController.canSendText() {
            print("Se pueden enviar mensajes")
            
            let messageController = MFMessageComposeViewController()
            
            messageController.body = "Hola mundo"
            messageController.recipients = ["1234567890"]
            
            messageController.messageComposeDelegate = self
            
            self.present(messageController, animated: true, completion: nil)
        } else {
            print("No se pueden enviar mensajes")
        }
    }
    
    @IBAction func sendEmailAction(_ sender: Any) {
        if MFMailComposeViewController.canSendMail() {
            print("Se pueden enviar correos")
            
            let mailController = MFMailComposeViewController()
            
            mailController.setToRecipients([
                "badillo.soft@hotmail.com"
            ])
            
            mailController.setMessageBody("<h1>Hola mundo</h1>", isHTML: true)
            
            mailController.mailComposeDelegate = self
            
            self.present(mailController, animated: true, completion: nil)
        } else {
            print("No se pueden enviar correos")
        }
    }
    
    @IBAction func makeCallAction(_ sender: Any) {
        let url = URL(string: "TEL://5512345678")! as NSURL
        UIApplication.shared.open(url as URL, options: [:]) {
            success in
            print("Se puedo realizar la llamada? \(success)")
        }
    }
    
    @IBAction func selectContactAction(_ sender: Any) {
        let contactPickerViewController = CNContactPickerViewController()
        contactPickerViewController.delegate = self
        
        self.present(contactPickerViewController, animated: true, completion: nil)
        
        /*let contactController = CNContactViewController()
        
        contactController.hidesBottomBarWhenPushed = true
        contactController.allowsEditing = false
        contactController.allowsActions = false
        
        self.present(contactController, animated: true, completion: nil)*/
    }
}

extension ViewController: MFMessageComposeViewControllerDelegate {
    
    func messageComposeViewController(_ controller: MFMessageComposeViewController, didFinishWith result: MessageComposeResult) {
        print("Resultado")
        controller.dismiss(animated: true, completion: nil)
    }
    
}

extension ViewController: MFMailComposeViewControllerDelegate {
    
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        controller.dismiss(animated: true, completion: nil)
    }
    
}

extension ViewController: CNContactPickerDelegate {
    
    /*func contactPicker(_ picker: CNContactPickerViewController, didSelect contacts: [CNContact]) {
        <#code#>
    }*/
    
    func contactPicker(_ picker: CNContactPickerViewController, didSelect contact: CNContact) {
        print("Contacto seleccionado \(contact.nickname)")
    }
    
}
