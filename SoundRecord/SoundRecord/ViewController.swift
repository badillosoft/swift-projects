//
//  ViewController.swift
//  SoundRecord
//
//  Created by Dragon on 29/10/20.
//

import UIKit
import AVFoundation

class ViewController: UIViewController, AVAudioRecorderDelegate {

    var recordingSession: AVAudioSession!
    var audioRecorder: AVAudioRecorder!
    
    // Reproductor
    var audioPlayer: AVAudioPlayer!
    
    @IBOutlet weak var recordButton: UIButton!
    @IBOutlet weak var stopRecorderButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        recordingSession = AVAudioSession.sharedInstance()
        
        do {
            try recordingSession.setCategory(.playAndRecord, mode: .default)
            try recordingSession.setActive(true)
            
            recordingSession.requestRecordPermission() {
                [unowned self] allowed in
                DispatchQueue.main.async {
                    if allowed {
                        print("Permisos concedidos para grabar sonido")
                        recordButton.isEnabled = true
                        return
                    }
                    print("No hay permisos para grabar sonido")
                }
            }
        } catch {
            print("Error: \(error)")
        }
    }
    
    func getDocumentDirectory() -> URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return paths.first!
    }

    @IBAction func startRecordAction(_ sender: Any) {
        let audioFilename = getDocumentDirectory().appendingPathComponent("recording.m4a")
        
        let settings = [
            AVFormatIDKey: Int(kAudioFormatMPEG4AAC),
            AVSampleRateKey: 12000,
            AVNumberOfChannelsKey: 1,
            AVEncoderAudioQualityKey: AVAudioQuality.high.rawValue
        ]
        
        do {
            audioRecorder = try AVAudioRecorder(url: audioFilename, settings: settings)
            audioRecorder.delegate = self
            audioRecorder.record()
            
            recordButton.isEnabled = false
            stopRecorderButton.isEnabled = true
        } catch {
            print("Error: \(error)")
        }
        
    }
    
    @IBAction func stopRecordAction(_ sender: Any) {
        audioRecorder.stop()
        audioRecorder = nil
        
        stopRecorderButton.isEnabled = false
    }
    
    func audioRecorderDidFinishRecording(_ recorder: AVAudioRecorder, successfully flag: Bool) {
        print("Grabación finalizada \(flag)")
        if flag {
            recordButton.isEnabled = true
        }
    }
    
    @IBAction func playRecordAction(_ sender: Any) {
        let audioFilename = getDocumentDirectory().appendingPathComponent("recording.m4a")
        
        if FileManager.default.fileExists(atPath: audioFilename.path) {
            do {
                audioPlayer = try AVAudioPlayer(contentsOf: audioFilename)
                audioPlayer.prepareToPlay()
            } catch {
                print("Error: \(error)")
                return
            }
            
            audioPlayer.play()
        }
        
    }
    
}

