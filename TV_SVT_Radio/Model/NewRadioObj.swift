//
//  NewRadioObj.swift
//  playerSwiftUI
//
//  Created by Alvar Arias on 2024-04-30.
//

import Foundation
//
//  RadioObj.swift
//  playerSwiftUI
//
//  Created by Alvar Arias on 2021-12-07.
//

import Foundation
import UIKit

// This file was generated from JSON Schema using quicktype, do not modify it directly.
// To parse the JSON, add this file to your project and do:
//
//   let myChannellRAdio = try? newJSONDecoder().decode(MyChannellRAdio.self, from: jsonData)
// file radios.json
// informacion sacada de :
// https://api.sr.se/api/v2/channels
// https://api.sr.se/v2/channels?page=2 (proxima página)

/*
 
A struct that represents a radio station, containing various properties such as name, image, and URL.

Usage: Initialize an instance of DemoRadio with the desired properties.

Note: This struct conforms to the Hashable and Codable protocols.
*/

struct radioStationInfo: Hashable, Codable  {

    let image: String
    let imagetemplate: String
    let color: String
    let tagline: String
    let siteurl: String
    let url: String
    let scheduleurl: String
    let xmltvid: String
    //var isFavorite: Bool
    let name: String
    let id: String
    
    
}

