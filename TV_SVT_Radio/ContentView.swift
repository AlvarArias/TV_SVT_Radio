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
    
    // Play Radio
    var playRadio = PlayRadio()
    
    @State var radioStations: [radioStationInfo] = []
    
    @State var isPlaying = false
   

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
                                    
                                    Button(action: {
                                        
                                        print("Tapped \(radioStations[item].name)")
                                       
                                        isPlaying.toggle()
                                        isPlaying = playRadio.playSongRadio(radioURL: radioStations[item].url, isPlaying: isPlaying)
                                        print("isPlaying: \(isPlaying)")
                                        
                                    }) {
                                        VStack {
                                            RadioStationImage(url: URL(string: radioStations[item].image) , accssibilityLabel: radioStations[item].name)
                                            
                                            Text(radioStations[item].name)
                                                .font(.headline)
                                                .foregroundColor(.white)
                                                .padding(.top, 10)
                                            
                                        }
                                    }
                                
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

struct RadioStationImage: View {
    let url: URL?
    let accssibilityLabel: String?

    var body: some View {
        CachedAsyncImage(url: url, content: { image in
            image.resizable()
                .aspectRatio(contentMode: .fill)
                .frame(width: 200, height: 200)
                .cornerRadius(10)
                .focusable(true)
                .shadow(radius: 10)
                //.accessibility(label: Text(radioStations[item].name))
                .accessibility(label: Text(accssibilityLabel ?? "no information"))
            
        }, placeholder: {
            ProgressView()
        })
    }
}
    

/*
  Text(radioStations[item].name)
  .frame(width: 200, height: 100)
  .background(Color.blue.opacity(0.5))
  .cornerRadius(10)
  .focusable(true)
*/

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

