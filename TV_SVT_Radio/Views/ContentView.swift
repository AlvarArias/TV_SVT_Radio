//
//  ContentView.swift
//  TV_SVT_Radio
//
//  Created by Alvar Arias on 2024-05-03.
//

import SwiftUI
import CachedAsyncImage
import Lottie


struct ContentView: View {
    
    // Load Stations
    var mYradioStation = LoadRadioStationJSONFile()
    
    // Play Radio
    var playRadio = PlayRadio()
    
    @State var radioStations: [radioStationInfo] = []
    
    @State var isPlaying = false
    
    @State var urlRadioStationHome : String = "http://sverigesradio.se/topsy/direkt/srapi/132.mp3"
    
    //@State var  urlImageRadioSelected : String = "https://static-cdn.sr.se/images/2384/c160e908-00ff-47f7-bdf7-0834100950e8.jpg"
    @State var  urlImageRadioSelected : String = "https://user-images.githubusercontent.com/7523384/121326895-3ffc6800-c913-11eb-842f-62ff6dd24591.png"
    
    @State var nameRadio : String = "TV SVT Radio player"
    
    @State var descriptionRadio : String = "This is a radio player for Sweden radio service, you can choose your radio Station"
    
    @State var isFocused = false

    let items = 0...51
    
    
    var body: some View {
        
        
        ZStack {
            Color.orange.opacity(0.9)
                .ignoresSafeArea()
            VStack {
                             
                if radioStations.count > 0 {
                    
                    HStack {
                        
                        VStack {
                            
                            RadioStationImage(url: URL(string: urlImageRadioSelected), accssibilityLabel: nameRadio)
                            
                            
                            if isPlaying {
                                LottieView(animation: .named("play"))
                                    .playing(loopMode: .loop)
                                    .frame(width: 100, height: 100)
                            } else {
                                LottieView(animation: .named("play"))
                                    .frame(width: 100, height: 100)
                            }
                        }
                        
                        VStack {
                            DetailView(text: nameRadio, textDescription: descriptionRadio, urlRadioStationHome: urlRadioStationHome, buttonIsPlaying: isPlaying)
                                .padding(.bottom, 70)
                           
                            
                        }
                      

                    }
                    
                    
                    ScrollView(.vertical) {
                        
                        
                        ScrollView(.horizontal, showsIndicators: false) {
                            
                            HStack {
                                Text("Välj en station")
                                    .font(.headline)
                                    .foregroundColor(.white)
                                    .padding(.leading, 50)
                                Spacer()
                            }
                            
                            LazyHStack(spacing: 20) {
                                
                                ForEach(items.clamped(to: 0...5), id: \.self) { item in
                                                
                                    VStack(alignment: .leading) {
                                        
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
                                                    .font(.caption)
                                                 .foregroundColor(.white)
                                                 .padding(.top, 10)
                                                
                                                
                                            }
                                  
                                        }
                                        
                                    }
                                }
                                
                                
                                
                            }
                            .padding()
                            

                            LazyHStack(spacing: 20) {
                                
                                ForEach(items.clamped(to: 6...11), id: \.self) { item in
                                  
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
                                                 .font(.caption)
                                                 .foregroundColor(.white)
                                                 .padding(.top, 10)
                                     
                                            }
                                      
                                        }
                                        
                                    }
                                }
                                           
                            }
                            .padding()
                      
                            LazyHStack(spacing: 20) {
                                
                                ForEach(items.clamped(to: 12...17), id: \.self) { item in
                                  
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
                                                 .font(.caption)
                                                 .foregroundColor(.white)
                                                 .padding(.top, 10)
                                     
                                            }
                                      
                                        }
                                        
                                    }
                                }
                                           
                            }
                            .padding()
                            
                            LazyHStack(spacing: 20) {
                                
                                ForEach(items.clamped(to: 18...23), id: \.self) { item in
                                  
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
                                                 .font(.caption)
                                                 .foregroundColor(.white)
                                                 .padding(.top, 10)
                                     
                                            }
                                      
                                        }
                                        
                                    }
                                }
                                           
                            }
                            .padding()
                            
                            LazyHStack(spacing: 20) {
                                
                                ForEach(items.clamped(to: 24...29), id: \.self) { item in
                                  
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
                                                 .font(.caption)
                                                 .foregroundColor(.white)
                                                 .padding(.top, 10)
                                     
                                            }
                                      
                                        }
                                        
                                    }
                                }
                                           
                            }
                            .padding()
                            
                            HStack {
                                buttonFeedback(buttonName: "Om appen")
                                buttonFeedback(buttonName: "Feedback")
                            }
                        }
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
                    
            
            }

    }
}



struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

