//
//  ContentView.swift
//  TV_SVT_Radio
//
//  Created by Alvar Arias on 2024-05-03.
//

import SwiftUI
import CachedAsyncImage


struct ContentView: View {
    
    // Load Stations
    var mYradioStation = LoadRadioStationJSONFile()
    
    @State var radioStations: [radioStationInfo] = []

    let items = 0...51
    
    var body: some View {
        
        ZStack {
            Color.orange
                .ignoresSafeArea()
            if radioStations.count > 0 {
                ScrollView(.horizontal, showsIndicators: false) {
                    LazyHStack(spacing: 20) {
                        
                            ForEach(items, id: \.self) { item in
                                VStack {
                                CachedAsyncImage(url: URL(string: radioStations[item].image), content: { image in
                                    image.resizable()
                                        .aspectRatio(contentMode: .fill)
                                        .frame(width: 200, height: 200)
                                        .cornerRadius(10)
                                }, placeholder: {
                                    ProgressView()
                                })
                                   
                                    Text(radioStations[item].name)
                                    .frame(width: 200, height: 100)
                                    .background(Color.blue.opacity(0.5))
                                    .cornerRadius(10)
                                    .focusable(true)
                                
                            }
                        }
                    }
                    .padding(.horizontal)
                }
                }
            }
            .onAppear {
            
            if radioStations.isEmpty {
                radioStations = mYradioStation.loadStation()
            }
            
        }
            
        
    }
}


    

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

