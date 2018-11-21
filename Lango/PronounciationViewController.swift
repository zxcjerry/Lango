//
//  PronounciationViewController.swift
//  Lango
//
//  Created by  jerry on 11/14/18.
//  Copyright © 2018  jerry. All rights reserved.
//

import UIKit
import AVFoundation
import googleapis

let SAMPLE_RATE = 16000

class PronounciationViewController: UIViewController, AudioControllerDelegate , UIPickerViewDelegate, UIPickerViewDataSource, UITextFieldDelegate {
    

    // MARK: - Properties
    let category = ["Food", "Transportation", "Culture", "Health"]
    let level = ["Beginner", "Intermidate", "Advanced"]
    
    var audioData: NSMutableData!
    var isRecording: Bool = false
    
    @IBOutlet weak var cateTextField: UITextField!
    @IBOutlet weak var levelTextField: UITextField!
    
    @IBOutlet weak var catePicker: UIPickerView!
    @IBOutlet weak var levelPicker: UIPickerView!
    
    @IBOutlet weak var recognizeText: UITextView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        catePicker.isHidden = true
        levelPicker.isHidden = true
        cateTextField.delegate = self
        levelTextField.delegate = self
        catePicker.delegate = self
        levelPicker.delegate = self
        AudioController.sharedInstance.delegate = self
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    // MARK: - Buttons
    
    @IBAction func playAudio(_ sender: UIButton) {
    }
    
    @IBAction func recordSound(_ sender: Any) {
        // TODO: use API to recognize
        isRecording = !isRecording
        if(isRecording) {
            recordAudio(self)
        } else {
            stopAudio(self)
        }
    }
    
    
    // MARK: - PickerView functions
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if (pickerView == catePicker) {
            return category.count
        } else {
            return level.count
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if (pickerView == catePicker) {
            return category[row]
        } else if (pickerView == levelPicker){
            return level[row]
        }
        
        return ""
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if(pickerView == catePicker) {
            self.cateTextField.text = self.category[row]
            catePicker.isHidden = true
        } else {
            self.levelTextField.text = self.level[row]
            levelPicker.isHidden = true
        }
    }
    
    // MARK: - TextField Functions
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        if (textField == cateTextField) {
            catePicker.isHidden = false
        } else {
            levelPicker.isHidden = false
        }
        
        return false
    }
    
    // MARK: - Audio Functions
    
    func recordAudio(_ sender: NSObject) {
        let audioSession = AVAudioSession.sharedInstance()
        do {
            try audioSession.setCategory(.playAndRecord, mode: .default, options: [])
        } catch {
            print(error)
        }
        audioData = NSMutableData()
        _ = AudioController.sharedInstance.prepare(specifiedSampleRate: SAMPLE_RATE)
        SpeechRecognitionService.sharedInstance.sampleRate = SAMPLE_RATE
        _ = AudioController.sharedInstance.start()
    }
    
    func stopAudio(_ sender: NSObject) {
        _ = AudioController.sharedInstance.stop()
        SpeechRecognitionService.sharedInstance.stopStreaming()
    }
    
    func processSampleData(_ data: Data) -> Void {
        audioData.append(data)
        
        // We recommend sending samples in 100ms chunks
        let chunkSize : Int /* bytes/chunk */ = Int(0.1 /* seconds/chunk */
            * Double(SAMPLE_RATE) /* samples/second */
            * 2 /* bytes/sample */);
        
        if (audioData.length > chunkSize) {
            SpeechRecognitionService.sharedInstance.streamAudioData(audioData,
                                                                    completion:
                { [weak self] (response, error) in
                    guard let strongSelf = self else {
                        return
                    }
                    
                    if let error = error {
                        strongSelf.recognizeText.text = error.localizedDescription
                    } else if let response = response {
                        var finished = false
                        print(response)
                        for result in response.resultsArray! {
                            if let result = result as? StreamingRecognitionResult {
                                if result.isFinal {
                                    finished = true
                                }
                            }
                        }
                        strongSelf.recognizeText.text = response.description
                        if finished {
                            strongSelf.stopAudio(strongSelf)
                        }
                    }
            })
            self.audioData = NSMutableData()
        }
    }
}
