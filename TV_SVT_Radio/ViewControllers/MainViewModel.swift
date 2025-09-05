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
    @Published var listRadioStaions: [RadioStation] = []
    
    // Ejemplo de función para cargar canales
    func fetchChannels() {
        // Lógica de carga aquí
        
        func loadStation(fileName: String = "radios23") -> listRadioStaions {
            
            guard let url = Bundle.main.url(forResource: fileName, withExtension: "json") else {
                return []
            }

            do {
                let data = try Data(contentsOf: url)
                let decoder = JSONDecoder()
                radioStations = try decoder.decode([radioStationInfo].self, from: data)
        
                return radioStations
                    
            } catch {
                print("Error loading radio stations: \(error)")
                return []
            }
        }
        
    }
}
