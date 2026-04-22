//
//  ContentView.swift
//  TV_SVT_Radio
//
//  Created by Alvar Arias on 2024-05-03.
//

import SwiftUI
import CachedAsyncImage
//import Lottie



struct MainView: View {
    // MARK: - Properties
    var radioStationLoader = LoadRadioStationJSONFile()
    var radioPlayer = PlayRadio()

    @State private var radioStations: [RadioStation] = []
    @State private var isPlaying = false
    @State private var urlRadioStationHome: String = myUrlRadioStationHome
    @State private var urlImageRadioSelected: String = myUrlImageRadioSelected
    @State private var nameRadio: String = myNameRadio
    @State private var descriptionRadio: String = myDescriptionRadio
    @State private var isFocused = false
    
    let items = 0...51
    
    private var vm = MainViewModel()
    

    // MARK: - Body
    var body: some View {
        ZStack {
            Color.orange.opacity(0.9)
                .ignoresSafeArea()
            VStack {
                if !radioStations.isEmpty {
                    HStack(alignment: .top, spacing: 20) {
        
                            RadioStationImage(url: URL(string: urlImageRadioSelected), accessibilityLabel: nameRadio)
                                       
                            DetailView(text: nameRadio, textDescription: descriptionRadio, urlRadioStationHome: urlRadioStationHome, buttonIsPlaying: isPlaying)
                                //.padding(.bottom, 70)
                        
                            Image(systemName: isPlaying ? "waveform.circle.fill" : "pause.circle.fill")
                                .resizable()
                                .frame(width: 90, height: 90)
                                .animation(.easeInOut(duration: 1.5), value: isPlaying)
                                .transition(.opacity)

                        
                    }
                    
                    
                    HStack {
                        Text("Välj en station")
                            .font(.headline)
                            .foregroundColor(.white)
                            .padding(.leading, 50)
                        Spacer()
                    }
                    
                    ScrollView(.vertical) {
                        ScrollView(.horizontal, showsIndicators: false) {
                           
                            // Carruseles de estaciones
                            ForEach(0..<5) { index in
                                let start = index * 6
                                let end = min(start + 5, radioStations.count - 1)
                                if start <= end {
                                    RadioStationCarousel(
                                        radioStations: $radioStations,
                                        isPlaying: $isPlaying,
                                        urlImageRadioSelected: $urlImageRadioSelected,
                                        nameRadio: $nameRadio,
                                        descriptionRadio: $descriptionRadio,
                                        radioPlayer: radioPlayer,
                                        range: start...end
                                    )
                                    .padding()
                                }
                            }
                           
                            
                            HStack {
                                ButtonFeedback(buttonName: "Om appen")
                                ButtonFeedback(buttonName: "Feedback")
                            }
                            .padding(.bottom, 20)
                        }
                    }
                    
                }
            }
            .task {
                if radioStations.isEmpty {
                    radioStations = radioStationLoader.loadStation()
                }
                
                if vm.listRadioStaions.isEmpty {
                    await vm.fetchChannels()
                }
            }
        }
    }
}

// MARK: - Carrusel de estaciones reutilizable
struct RadioStationCarousel: View {
    @Binding var radioStations: [RadioStation]
    @Binding var isPlaying: Bool
    @Binding var urlImageRadioSelected: String
    @Binding var nameRadio: String
    @Binding var descriptionRadio: String
    var radioPlayer: PlayRadio
    let range: ClosedRange<Int>

    var body: some View {
        LazyHStack(spacing: 20) {
            ForEach(range, id: \ .self) { item in
                if item < radioStations.count {
                    VStack(alignment: .leading) {
                        Button(action: {
                            print("Tapped \(radioStations[item].name)")
                            isPlaying.toggle()
                            isPlaying = radioPlayer.playSongRadio(radioURL: radioStations[item].url, isPlaying: isPlaying)
                            print("isPlaying: \(isPlaying)")
                            urlImageRadioSelected = radioStations[item].image
                            nameRadio = radioStations[item].name
                            descriptionRadio = radioStations[item].tagline
                        }) {
                            VStack {
                                RadioStationImage(url: URL(string: radioStations[item].image), accessibilityLabel: radioStations[item].name)
                                    .frame(width: 200, height: 200)
                                Text(radioStations[item].name)
                                    .font(.caption)
                                    .foregroundColor(.white)
                                    .padding(.top, 10)
                            }
                        }
                    }
                }
            }
        }
    }
}


// MARK: - Imagen de estación de radio
struct RadioStationImage: View {
    let url: URL?
    let accessibilityLabel: String?

    var body: some View {
        CachedAsyncImage(url: url, content: { image in
            image
                .resizable()
                .frame(width: 200, height: 200)
                .aspectRatio(contentMode: .fill)
                .cornerRadius(10)
                .focusable(true)
                .shadow(radius: 10)
                .accessibility(label: Text(accessibilityLabel ?? "no information"))
        }, placeholder: {
            ProgressView()
        })
        
    }
}
    
// MARK: - Detalle de la estación
struct DetailView: View {
    var text: String?
    var textDescription: String?
    var isPlaying = false
    var urlRadioStationHome: String = ""
    var playRadio = PlayRadio()
    @State var buttonIsPlaying: Bool = false

    var body: some View {
        VStack(alignment: .leading) {
            Text(text ?? "")
                .font(.title)
                .fontWeight(.bold)
                .foregroundColor(.white)
                .padding(.leading, 10)
                .padding(.top, 10)
            
            Text(textDescription ?? "")
                .font(.caption)
                .foregroundColor(.white)
                .padding(.leading, 10)
                .padding(.bottom, 10)
                .frame(width: 600, alignment: .leading)
        }
    }
}



struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        MainView()
    }
}

