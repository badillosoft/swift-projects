//
//  ViewController.swift
//  MediaPlayer
//
//  Created by Dragon on 28/10/20.
//

import UIKit
import AVFoundation

class ViewController: UIViewController {

    var player: AVAudioPlayer?
    
    var timer: Timer!
    
    @IBOutlet weak var play: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        let path = Bundle.main.path(forResource: "song.mp3", ofType: nil)
        let url = URL(fileURLWithPath: path!)
        
        do {
            player = try AVAudioPlayer(contentsOf: url)
            
            timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(updateTime), userInfo: nil, repeats: true)
        } catch {
            print("Error: \(error)")
        }
    }
    
    @objc func updateTime() {
        print(player?.currentTime)
        // actualizar label o slider
    }
    
    @IBAction func playAction(_ sender: Any) {
        player?.play()
    }
    @IBAction func pauseAction(_ sender: Any) {
        player?.pause()
    }
    
    @IBAction func stopAction(_ sender: Any) {
        player?.stop()
    }
    
}

