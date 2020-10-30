//
//  SoundPlayerController.swift
//  Proyecto1
//
//  Created by Brandon Escalante on 29/10/20.
//  Copyright © 2020 Brandon Escalante. All rights reserved.
//

import Foundation
import UIKit
import AVFoundation

class SounPlayerController: UIViewController{
    
    var entrevista: Entrevista?
    var player: AVAudioPlayer!
    
    @IBOutlet weak var labelTitulo: UILabel!
    @IBOutlet weak var buttonPlay: UIButton!
    @IBOutlet weak var buttonPause: UIButton!
    @IBOutlet weak var buttonStop: UIButton!
    @IBOutlet weak var buttonCerrar: UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setup()
    }
    
    func setup(){
        print(entrevista)
        if let entrevista = self.entrevista {
            labelTitulo.text = entrevista.nombre
        }
    }
    
    func getDocumentDirectory() -> URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return paths.first!
    }
    
    @IBAction func playAction(_ sender: Any) {
        if let entrevista = self.entrevista {
            let audioFilename = getDocumentDirectory().appendingPathComponent("\(entrevista.url!).m4a")
            
            if FileManager.default.fileExists(atPath: audioFilename.path) {
                do {
                    player = try AVAudioPlayer(contentsOf: audioFilename)
                    player.prepareToPlay()
                } catch {
                    print("Error: \(error)")
                    return
                }
                
                player.play()
            }

        }
    }
    
    @IBAction func pauseAction(_ sender: Any) {
        player.pause()
    }
    
    
    @IBAction func stopAction(_ sender: Any) {
        player.stop()
    }
    
    
    @IBAction func cerrarAction(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
}
