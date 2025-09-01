//
//  PlayerViewModel.swift
//  TV_SVT_Radio
//
//  Created by Alvar Arias on 2025-09-01.
//

import Foundation
import Combine

class PlayerViewModel: ObservableObject {
    // Ejemplo de título actual a mostrar en la vista
    @Published var currentTitle: String? = "Nombre de la emisora o canción"
    
    // Ejemplo de progreso de reproducción (0.0 a 1.0)
    @Published var progress: Double? = 0.3
    
    // Puedes agregar aquí otros estados relevantes, como si está reproduciendo, pausado, etc.
    @Published var isPlaying: Bool = false

    // Simulación de acciones del reproductor
    func play() {
        isPlaying = true
        // Lógica para reproducir audio
    }
    
    func pause() {
        isPlaying = false
        // Lógica para pausar audio
    }
    
    func stop() {
        isPlaying = false
        progress = 0.0
        // Lógica para detener audio
    }
}
