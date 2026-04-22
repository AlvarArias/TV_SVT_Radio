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
    @Published var listRadioStaions: [RadioStation] = []
    @Published var errorMessage: String? = nil

    func fetchChannels() async {
        let result = await APIClient.shared.fetchLocalStations()
        switch result {
        case .success(let stations):
            listRadioStaions = stations
            errorMessage = nil
        case .failure(let error):
            listRadioStaions = []
            errorMessage = error.errorDescription
        }
    }
}
    
