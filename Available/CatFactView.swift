//
//  CatFactView.swift
//  Available
//
//  Created by Muhammad Farkhanudin on 02/08/23.
//  Copyright © 2023 Ardhita Eka Putri. All rights reserved.
//

import SwiftUI

struct CatFactView: View {
    @State private var catFact: String = ""

    var body: some View {
        VStack {
            Text("Cat Facts")
                .font(.title)
                .fontWeight(.bold)
                .padding(.bottom, 100)

            Text(catFact)
                .font(.body)
                .multilineTextAlignment(.center)
                .padding()

            Button(action: loadData) {
                Text("Get Cat Facts")
                    .foregroundColor(.white)
                    .padding()
                    .frame(width: 200) // Set the width of the button
                    .background(Color.black) // Set the background color to black
                    .cornerRadius(8)
            }
        }
        .padding()
        .onAppear(perform: loadData)
    }

    private func loadData() {
        guard let url = URL(string: "https://catfact.ninja/fact") else {
            return
        }

        URLSession.shared.dataTask(with: url) { data, response, error in
            if let data = data {
                if let decodedResponse = try? JSONDecoder().decode(CatFactResponse.self, from: data) {
                    DispatchQueue.main.async {
                        self.catFact = decodedResponse.fact
                    }
                    return
                }
            }

            print("Failed to load cat fact")
        }.resume()
    }
}

struct CatFactView_Previews: PreviewProvider {
    static var previews: some View {
        CatFactView()
    }
}

struct CatFactResponse: Codable {
    let fact: String
    let length: Int
}
