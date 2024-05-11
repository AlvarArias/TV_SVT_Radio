//
//  buttonFeedback.swift
//  TV_SVT_Radio
//
//  Created by Alvar Arias on 2024-05-11.
//

import SwiftUI

struct buttonFeedback: View {
    
    var buttonName : String
    
    var body: some View {
        Button(action: {
            print("Button was pressed \(buttonName)")
        }) {
            Text(buttonName)
        }
    }
}

/*
#Preview {
    buttonFeedback()
}
*/


