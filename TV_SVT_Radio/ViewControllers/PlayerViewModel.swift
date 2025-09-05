//
//  PlayerViewModel.swift
//  TV_SVT_Radio
//
//  Created by Alvar Arias on 2025-09-01.
//

import Foundation
import Combine
import AVFoundation


class PlayerViewModel: ObservableObject {
    @Published var currentTitle: String? = "Nombre de la emisora o canción"
    @Published var progress: Double? = 0.3
    @Published var isPlaying: Bool = false

    private var player: AVPlayer?

    // Reproduce una estación de radio desde la URL
    func play(radioURL: String) {
        do {
            let audioSession = AVAudioSession.sharedInstance()
            try audioSession.setCategory(.playback)
            try audioSession.setActive(true)

            guard let url = URL(string: radioURL) else {
                print("URL inválida")
                return
            }

            player = AVPlayer(url: url)
            player?.play()
            isPlaying = true
        } catch {
            print("Failed to play audio: \(error.localizedDescription)")
            isPlaying = false
        }
    }

    // Pausa la reproducción
    func pause() {
        player?.pause()
        isPlaying = false
    }

    // Detiene la reproducción y reinicia el progreso
    func stop() {
        player?.pause()
        player = nil
        isPlaying = false
        progress = 0.0
    }
}


