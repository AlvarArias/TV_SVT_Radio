//
//  PlayRadio.swift
//  TV_SVT_Radio
//
//  Created by Alvar Arias on 2024-05-04.
//

import Foundation
import SwiftUI
import AVKit

class PlayRadio {
    
    var player = AVPlayer()
    
    func playSongRadio(radioURL: String, isPlaying: Bool) -> Bool {
        

        do {
            
            let audioSession = AVAudioSession.sharedInstance()
            try audioSession.setCategory(.playback)
            try audioSession.setActive(true)
            
            player = AVPlayer(url: URL(string: radioURL)!)
        
            
            if isPlaying {
                player.play()
                return true
                
            } else {
                
                player.pause()
                return false
            }
            
            
        } catch let error {
            print("Failed to play audio: \(error.localizedDescription)")
            return false
        }
        
    }
    
}


