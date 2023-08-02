//
//  JokesView.swift
//  dataXplorer
//
//  Created by Ardhita Eka Putri on 01/08/23.
//  Copyright © 2023 Ardhita Eka Putri. All rights reserved.
//

import SwiftUI

struct JokesView: View {
    @State private var setup = ""
    @State private var punchline = ""
    @State private var showJoke = false

    var body: some View {
        VStack {
            Text("Jokes")
                .font(.title)
                .fontWeight(.bold)
                .padding(.bottom, 10)

            Text("Press the button to generate a random joke.")
                .font(.subheadline)
                .foregroundColor(.gray)
                .padding(.bottom, 20)

            Button(action: {
                self.generateRandomJoke()
                self.showJoke = true
            }) {
                Text("Generate Joke")
                    .foregroundColor(.white)
                    .bold()
            }
            .frame(width: 200, height: 50)
            .background(Color.black)
            .cornerRadius(10)
            .padding()

            if showJoke {
                Text("Setup: \(setup)")
                    .font(.headline)
                Text("Punchline: \(punchline)")
                    .font(.headline)
            }

            Spacer()
        }
        .padding()
        .navigationBarTitle("Jokes", displayMode: .inline)
    }

    private func generateRandomJoke() {
        guard let url = URL(string: "https://official-joke-api.appspot.com/random_joke") else {
            return
        }

        URLSession.shared.dataTask(with: url) { data, response, error in
            if let data = data {
                if let decodedResponse = try? JSONDecoder().decode(JokeResponse.self, from: data) {
                    DispatchQueue.main.async {
                        self.setup = decodedResponse.setup
                        self.punchline = decodedResponse.punchline
                    }
                    return
                }
            }

            print("Failed to generate joke")
        }.resume()
    }
}

struct JokesView_Previews: PreviewProvider {
    static var previews: some View {
        JokesView()
    }
}

struct JokeResponse: Codable {
    let type: String
    let setup: String
    let punchline: String
    let id: Int
}
