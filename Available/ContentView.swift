//
//  ContentView.swift
//  Available
//
//  Created by Ardhita Eka Putri on 01/08/23.
//  Copyright © 2023 Ardhita Eka Putri. All rights reserved.
//

import SwiftUI

struct ContentView: View {
    @State private var showHome = false

    var body: some View {
        NavigationView {
            VStack(spacing: 50) {
                Image("tampilan-awal")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 300, height: 300)
                Text("All Data Available")
                    .font(.system(size: 30, weight: .bold, design: .rounded))
                    .multilineTextAlignment(.center)
                Text("Find your search here!")
                    .multilineTextAlignment(.center)
                    .foregroundColor(.gray)

                // Use NavigationLink instead of sheet
                NavigationLink(destination: Home(), isActive: $showHome) {
                    ZStack {
                        RoundedRectangle(cornerRadius: 50)
                            .foregroundColor(.black) // Change the button color to black
                        Text("Start")
                            .foregroundColor(.white)
                            .bold()
                    }
                }
                .frame(width: 200, height: 70)
                .onTapGesture {
                    self.showHome = true
                }
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

