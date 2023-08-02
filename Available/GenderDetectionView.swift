//
//  GenderDetectionView.swift
//  Available
//
//  Created by Ardhita Eka Putri on 02/08/23.
//  Copyright © 2023 Ardhita Eka Putri. All rights reserved.
//

import SwiftUI

struct GenderDetectionView: View {
    @State private var name = ""
    @State private var gender = ""
    @State private var probability = 0.0
    @State private var showResult = false

    var body: some View {
        VStack {
            Text("Gender Detection")
                .font(.title)
                .fontWeight(.bold)
                .padding(.bottom, 10)

            Text("Enter a name to detect the gender.")
                .font(.subheadline)
                .foregroundColor(.gray)
                .padding(.bottom, 20)

            TextField("Enter name", text: $name)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding()

            Button(action: {
                self.detectGender()
                self.showResult = true
            }) {
                Text("Detect Gender")
                    .foregroundColor(.white)
                    .bold()
            }
            .frame(width: 200, height: 50)
            .background(Color.black)
            .cornerRadius(10)
            .padding()

            if showResult {
                Text("Name: \(name)")
                    .font(.headline)
                Text("Gender: \(gender)")
                    .font(.headline)
                Text("Probability: \(probability)")
                    .font(.headline)
            }

            Spacer()
        }
        .padding()
        .navigationBarTitle("Genderize.io", displayMode: .inline)
    }

    private func detectGender() {
        guard let url = URL(string: "https://api.genderize.io/?name=\(name)") else {
            return
        }

        URLSession.shared.dataTask(with: url) { data, response, error in
            if let data = data {
                if let decodedResponse = try? JSONDecoder().decode(GenderResponse.self, from: data) {
                    DispatchQueue.main.async {
                        self.gender = decodedResponse.gender
                        self.probability = decodedResponse.probability
                    }
                    return
                }
            }

            print("Failed to detect gender")
        }.resume()
    }
}

struct GenderDetectionView_Previews: PreviewProvider {
    static var previews: some View {
        GenderDetectionView()
    }
}

struct GenderResponse: Codable {
    let name: String
    let gender: String
    let probability: Double
    let count: Int
}
