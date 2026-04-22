//
//  PlayRadio.swift
//  TV_SVT_Radio
//
//  Created by Alvar Arias on 2024-05-04.
//

import Foundation
import SwiftUI
import AVKit

@MainActor
final class PlayRadio {
    
    var player = AVPlayer()
    
    func playSongRadio(radioURL: String, isPlaying: Bool) -> Bool {
        guard let url = URL(string: radioURL) else {
            print("Invalid radio URL: \(radioURL)")
            return false
        }

        do {
            
            let audioSession = AVAudioSession.sharedInstance()
            try audioSession.setCategory(.playback)
            try audioSession.setActive(true)
            
            player = AVPlayer(url: url)
        
            
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


