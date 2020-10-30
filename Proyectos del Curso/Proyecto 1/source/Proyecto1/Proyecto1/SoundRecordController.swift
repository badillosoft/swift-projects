//
//  SoundRecordController.swift
//  Proyecto1
//
//  Created by Brandon Escalante on 29/10/20.
//  Copyright © 2020 Brandon Escalante. All rights reserved.
//

import Foundation
import UIKit
import AVFoundation

class SoundRecordController: UIViewController, AVAudioRecorderDelegate{
    
    var entrevista : Entrevista!
    
    @IBOutlet weak var labelTiempo: UILabel!
    @IBOutlet weak var buttonRecord: UIButton!
    @IBOutlet weak var buttonStop: UIButton!
    @IBOutlet weak var buttonFinalizar: UIButton!
    
    var recordingSession : AVAudioSession!
    var audioRecorder: AVAudioRecorder!
    var timer : Timer!
    var fechaInicio: Date?
    var isRecording = false
    
    var onFinalizado : ((Entrevista) -> Void)?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setup()
    }
    
    func setup(){
        timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(updateTime), userInfo: nil, repeats: true)
        
        recordingSession = AVAudioSession.sharedInstance()
        
        do {
            try recordingSession.setCategory(.playAndRecord, mode: .default)
            try recordingSession.setActive(true)
            
            recordingSession.requestRecordPermission() { [unowned self] allowed in
                DispatchQueue.main.async {
                    if allowed{
                        print("Permisos concedidos para grabar sonido")
                        self.buttonRecord.isEnabled = true
                        return
                    }
                    print("Permisos no concedidos para grabar sonido")
                }
            }
        } catch {
            print("Error: \(error)")
        }
    }
    
    @objc func updateTime() {
        if !isRecording {
            return
        }
        
        if let fechaInicio = self.fechaInicio {
            let now = Date()
            let difference = now.timeIntervalSince(fechaInicio)
            let seconds = Int(difference)%60
            let minutes = Int(difference)/60
            // actualizar label o slider
            labelTiempo.text = "\(minutes):\(seconds)"
        }
    }
    
    func getDocumentDirectory() -> URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return paths.first!
    }
    
    
    @IBAction func recordAction(_ sender: Any) {
        let audioFilename = getDocumentDirectory().appendingPathComponent("\(entrevista.url!).m4a")
        
        let settings = [
            AVFormatIDKey: Int(kAudioFormatMPEG4AAC),
            AVSampleRateKey: 12000,
            AVNumberOfChannelsKey: 1,
            AVEncoderAudioQualityKey: AVAudioQuality.high.rawValue
        ]
        
        do {
            audioRecorder = try AVAudioRecorder(url: audioFilename, settings: settings)
            fechaInicio = Date()
            audioRecorder.delegate = self
            isRecording = true
            audioRecorder.record()
            buttonRecord.isEnabled = false
            buttonStop.isEnabled = true
        } catch {
            print("Error: \(error)")
        }

    }
    
    
    @IBAction func stopAction(_ sender: Any) {
        audioRecorder.stop()
        isRecording = false
        audioRecorder = nil
        
        buttonStop.isEnabled = false
    }
    
    
    func audioRecorderDidFinishRecording(_ recorder: AVAudioRecorder, successfully flag: Bool) {
        print("Grabacion finalizada")
        if flag {
            buttonFinalizar.isEnabled = true
        }
    }
    
    @IBAction func finalizarAction(_ sender: Any) {
        if let handler = onFinalizado {
            handler(self.entrevista)
        }
        self.dismiss(animated: true, completion: nil)
    }
}
