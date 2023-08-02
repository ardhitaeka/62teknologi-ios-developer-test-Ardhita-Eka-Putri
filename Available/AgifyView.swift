//
//  AgifyView.swift
//  Available
//
//  Created by Ardhita Eka Putri on 02/08/23.
//  Copyright © 2023 Ardhita Eka Putri. All rights reserved.
//

import SwiftUI
import UserNotifications

struct AgifyView: View {
    @State private var name = ""
    @State private var estimatedAge: Int?
    @State private var showResult = false

    var body: some View {
        VStack {

            Text("Age Estimator")
                .font(.title)
                .fontWeight(.bold)
                .padding(.bottom)

            TextField("Enter name here", text: $name)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding()

            Button(action: {
                self.estimateAgeFromName()
                self.showResult = true
            }) {
                Text("Predict")
                    .foregroundColor(.white)
                    .bold()
            }
            .frame(width: 200, height: 50)
            .background(Color.black)
            .cornerRadius(10)
            .padding()

            // Use a computed property to conditionally show the result
            resultView

            Spacer()
        }
        .padding()
        .navigationBarTitle("Agify.io", displayMode: .inline)
    }

    private func estimateAgeFromName() {
        guard let url = URL(string: "https://api.agify.io/?name=\(name)") else {
            return
        }

        URLSession.shared.dataTask(with: url) { data, response, error in
            if let data = data {
                if let decodedResponse = try? JSONDecoder().decode(AgifyResponse.self, from: data) {
                    DispatchQueue.main.async {
                        self.estimatedAge = decodedResponse.age
                        self.showAgeNotification()
                    }
                    return
                }
            }

            print("Failed to estimate age")
        }.resume()
    }

    // Computed property to conditionally show the result
    private var resultView: some View {
        Group<AnyView> {
            if showResult {
                if let age = estimatedAge {
                    return AnyView(
                        Text("Estimated age for \(name): \(age)")
                            .font(.headline)
                            .padding()
                    )
                } else {
                    return AnyView(
                        Text("Failed to estimate age for \(name)")
                            .font(.headline)
                            .padding()
                    )
                }
            } else {
                return AnyView(EmptyView())
            }
        }
    }

    private func showAgeNotification() {
        if let age = estimatedAge {
            let content = UNMutableNotificationContent()
            content.title = "Estimated Age"
            content.body = "The estimated age for \(name) is \(age)"
            content.sound = UNNotificationSound.default

            let request = UNNotificationRequest(identifier: "AgeEstimation", content: content, trigger: nil)
            UNUserNotificationCenter.current().add(request)
        }
    }
}

struct AgifyView_Previews: PreviewProvider {
    static var previews: some View {
        AgifyView()
    }
}

struct AgifyResponse: Codable {
    let name: String
    let age: Int
    let count: Int
}
