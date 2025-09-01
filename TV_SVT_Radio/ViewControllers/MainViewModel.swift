//
//  MainViewModel.swift
//  TV_SVT_Radio
//
//  Created by Alvar Arias on 2025-09-01.
//

import Foundation
import Combine

class MainViewModel: ObservableObject {
    // Ejemplo de propiedad publicada
    @Published var channels: [Channel] = []
    
    // Ejemplo de función para cargar canales
    func fetchChannels() {
        // Lógica de carga aquí
    }
}
