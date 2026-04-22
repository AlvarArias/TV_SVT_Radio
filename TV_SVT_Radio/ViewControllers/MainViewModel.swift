//
//  MainViewModel.swift
//  TV_SVT_Radio
//
//  Created by Alvar Arias on 2025-09-01.
//

import Foundation
import Combine

@MainActor
final class MainViewModel: ObservableObject {
    // Ejemplo de propiedad publicada
    @Published var listRadioStaions: [RadioStation] = []
    // Ejemplo de función para cargar canales
    
    func fetchChannels() async {
        guard let url = Bundle.main.url(forResource: "radios23", withExtension: "json") else {
            print("No se encontró el archivo radios23.json")
            self.listRadioStaions = []
            return
        }
        do {
            let data = try Data(contentsOf: url)
            let decoder = JSONDecoder()
            let stations = try decoder.decode([RadioStation].self, from: data)
            self.listRadioStaions = stations
        } catch {
            print("Error cargando radios23.json: \(error)")
            self.listRadioStaions = []
        }
    }
    
}
    
