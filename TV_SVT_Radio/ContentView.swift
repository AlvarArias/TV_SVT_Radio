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
    
    @State var urlRadioStationHome : String = "http://sverigesradio.se/topsy/direkt/srapi/132.mp3"
    
    @State var  urlImageRadioSelected : String = "https://static-cdn.sr.se/images/132/2186745_512_512.jpg"
    
    @State var nameRadio : String = "P1"
    
    @State var descriptionRadio : String = "Talat innehåll om samhälle, kultur och vetenskap. Kanalen erbjuder nyheter och aktualiteter, granskning och fördjupning men också livsåskådnings-och livsstilsprogram samt underhållning och upplevelser till exempel i form av teater."
    
    @State var isFocused = false
    
   
    
   
    let items = 0...51
    
    var body: some View {
        
        ZStack {
            Color.orange
                .ignoresSafeArea()
            VStack {
                             
                    if radioStations.count > 0 {
                       
                        HStack {
                            
                            
                            RadioStationImage(url: URL(string: urlImageRadioSelected), accssibilityLabel: nameRadio)
                            .frame(width: 200, height: 200)
                            .padding(.top, 50)
                            
                            
                            DetailView(text: nameRadio, textDescription: descriptionRadio, urlRadioStationHome: urlRadioStationHome, buttonIsPlaying: isPlaying)
                            
                            
                        }
                        
                        
                        ScrollView(.horizontal, showsIndicators: false) {
                            
                            LazyHStack(spacing: 20) {

                                ForEach(items, id: \.self) { item in
                                    VStack {

                                        Button(action: {
                                            
                                            print("Tapped \(radioStations[item].name)")
                                            
                                            isPlaying.toggle()
                                            
                                            isPlaying = playRadio.playSongRadio(radioURL: radioStations[item].url, isPlaying: isPlaying)
                                            
                                            print("isPlaying: \(isPlaying)")
                                            
                                            urlImageRadioSelected = radioStations[item].image
                                            
                                            nameRadio = radioStations[item].name
                                            
                                            descriptionRadio = radioStations[item].tagline
                                            
                                        }){
                                            VStack {
                                                RadioStationImage(url: URL(string: radioStations[item].image) , accssibilityLabel: radioStations[item].name)
                                                    .frame(width: 200, height: 200)
                                
                                                  
                                                
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
                .accessibility(label: Text(accssibilityLabel ?? "no information"))
            
            
        }, placeholder: {
            ProgressView()
        })
       
    }
}
    
struct DetailView: View {
    
    var text: String?
    
    var textDescription: String?
    
    var isPlaying = false
    
    var urlRadioStationHome : String = ""
    
   var playRadio = PlayRadio()
    
    @State var buttonIsPlaying : Bool = false

    var body: some View {
        
        
        VStack(alignment: .leading) {
                
                
            Text(text ?? "")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .foregroundColor(.white)
                    .padding(.leading, 10)
                    .padding(.top, 10)
                
                Text(textDescription ?? "")
                    .font(.headline)
                    .foregroundColor(.white)
                    .padding(.leading, 10)
                    .padding(.bottom, 10)
                    .frame(width: 600, alignment: .leading)
                    
                
                
                Button(action: {
                    
                    buttonIsPlaying.toggle()
                    buttonIsPlaying = playRadio.playSongRadio(radioURL: urlRadioStationHome, isPlaying: buttonIsPlaying)
                    print("buttonIsPlaying: \(buttonIsPlaying)")
                    
                }) {
                    
                    Image(systemName: buttonIsPlaying ? "pause.fill" : "play.fill")
                        .resizable()
                        .frame(width: 30, height: 30)
                        .foregroundColor(.white)
                        .padding(.leading, 10)
                        .focusable(true)
                }
                
                
            }

    }
}



struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

