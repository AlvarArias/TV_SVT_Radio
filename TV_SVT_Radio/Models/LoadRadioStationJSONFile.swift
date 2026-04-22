//
//  HomeModell.swift
//  playerSwiftUI
//
//  Created by Alvar Arias on 2023-08-25.
//

import SwiftUI


class LoadRadioStationJSONFile {
    
    var radioStations: [RadioStation] = []
    
         func loadStation(fileName: String = "radios23") -> [RadioStation] {
        
        guard let url = Bundle.main.url(forResource: fileName, withExtension: "json") else {
            return []
        }

        do {
            let data = try Data(contentsOf: url)
            let decoder = JSONDecoder()
            radioStations = try decoder.decode([RadioStation].self, from: data)
    
            return radioStations
                
        } catch {
            print("Error loading radio stations: \(error)")
            return []
        }
    }
    
}
    


