//
//  SpeechRecognizer.swift
//  Scrumdinger
//
//  Created by Bhanuteja KOTA VENKATA on 17/06/22.
//

import Foundation
import AVFoundation
import Speech
import SwiftUI

class SpeechRecongnizer: ObservableObject {
    
    enum RecognizerError: Error {
        case nilRecognizer
        case notAuthorized
        case notPermitted
        case unavailable
        var message: String {
            switch self {
            case .nilRecognizer: return "Can't initialize speech recognizer"
            case .notAuthorized: return "Not authorized to recognize speech"
            case .notPermitted: return "Not permitted to record audio"
            case .unavailable: return "Recognizer is unavailable"
            }
        }
    }
    
    var transcript = ""
    private var audioEngine: AVAudioEngine?
    private var request: SFSpeechAudioBufferRecognitionRequest?
    private var task: SFSpeechRecognitionTask?
    private var recognizer: SFSpeechRecognizer?
    
    init() {
        recognizer = SFSpeechRecognizer()
        Task(priority: .background) {
            do {
                guard recognizer != nil else {
                    throw RecognizerError.nilRecognizer
                }
                
                guard await SFSpeechRecognizer.hasAuthorizationToRecord() else {
                    throw RecognizerError.notAuthorized
                }
                
                guard await AVAudioSession.sharedInstance().hasPermissionToRecord() else {
                    throw RecognizerError.notPermitted
                }
            } catch {
                speakError(error)
            }
        }
    }
    
    deinit {
        reset()
    }
    
    
    func transcribe() {
        DispatchQueue(label: "Speech recognizer queue", qos: .background).async { [weak self] in
            guard let self = self, let recognizer = self.recognizer, recognizer.isAvailable else {
                self?.speakError(RecognizerError.unavailable)
                return
            }
            
            do {
                let (audioEngine, request) = try Self.prepareEngine()
                self.audioEngine = audioEngine
                self.request = request
                self.task = recognizer.recognitionTask(with: request, resultHandler: self.handleResult(result:error:))
            } catch {
                self.reset()
                self.speakError(error)
                
            }
        }
    }
    
    
    func handleResult(result: SFSpeechRecognitionResult?, error: Error?) {
        
        let finalResult = result?.isFinal ?? false
        let recievedError = error != nil
        
        if finalResult || recievedError {
            audioEngine?.stop()
            audioEngine?.inputNode.removeTap(onBus: 0)
        }
        
        if let result = result {
            speak(result.bestTranscription.formattedString)
        }
    }
    
    func speak(_ message: String) {
        transcript = message
    }
    
    private static func prepareEngine() throws -> (AVAudioEngine, SFSpeechAudioBufferRecognitionRequest) {
        let audioEngine = AVAudioEngine()
        let request = SFSpeechAudioBufferRecognitionRequest()
        request.shouldReportPartialResults = true
        
        let audioSession = AVAudioSession.sharedInstance()
        try audioSession.setCategory(.record,mode: .measurement, options: .duckOthers)
        try audioSession.setActive(true, options: .notifyOthersOnDeactivation)
        let inputNode = audioEngine.inputNode
        let recordingFormat = inputNode.inputFormat(forBus: 0)
        inputNode.installTap(onBus: 0, bufferSize: 1024, format: recordingFormat) { (buffer: AVAudioPCMBuffer, when: AVAudioTime) in
            request.append(buffer)
        }
        audioEngine.prepare()
        try audioEngine.start()
        return (audioEngine, request)
    }
    
    func stopTranscribing() {
        reset()
    }
    
    func reset() {
        task?.cancel()
        audioEngine?.stop()
        audioEngine = nil
        request = nil
        task = nil
    }
    
    private func speakError(_ error: Error) {
        var errorMessage = ""
        if let error = error as? RecognizerError {
            errorMessage += error.message
        } else {
            errorMessage += error.localizedDescription
        }
        transcript = "<< \(errorMessage) >>"
    }
    
}

extension SFSpeechRecognizer {
    static func hasAuthorizationToRecord() async -> Bool {
        await withCheckedContinuation { continuation in
            requestAuthorization { status in
                continuation.resume(returning: status == .authorized)
            }
        }
    }
}

extension AVAudioSession {
    func hasPermissionToRecord() async -> Bool {
        await withCheckedContinuation { continuation in
            requestRecordPermission { permission in
                continuation.resume(returning: permission)
            }
        }
    }
}
