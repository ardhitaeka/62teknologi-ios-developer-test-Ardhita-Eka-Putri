//
//  DogImageView.swift
//  Available
//
//  Created by Muhammad Farkhanudin on 02/08/23.
//  Copyright © 2023 Ardhita Eka Putri. All rights reserved.
//

import SwiftUI

struct DogImage: Codable {
    let message: String
    let status: String
}

struct RandomDogImagesView: View {
    @State private var dogImageURL: URL?
    @State private var isLoading = false

    var body: some View {
        VStack {
            if isLoading {
                LoadingView()
            } else {
                ImageView(dogImageURL: dogImageURL)
            }

            Button(action: fetchRandomDogImage) {
                Text("Try Now")
                .foregroundColor(.black)
            }
            .padding()
        }
        .padding()
        .navigationBarTitle("Dogs")
    }

    private func fetchRandomDogImage() {
        isLoading = true
        guard let url = URL(string: "https://dog.ceo/api/breeds/image/random") else {
            isLoading = false
            return
        }

        URLSession.shared.dataTask(with: url) { data, response, error in
            defer {
                self.isLoading = false
            }

            if let data = data {
                if let decodedResponse = try? JSONDecoder().decode(DogImage.self, from: data) {
                    DispatchQueue.main.async {
                        if let imageURL = URL(string: decodedResponse.message) {
                            self.dogImageURL = imageURL
                        }
                    }
                    return
                }
            }

            print("Failed to fetch dog image")
        }.resume()
    }
}

struct RandomDogImagesView_Previews: PreviewProvider {
    static var previews: some View {
        RandomDogImagesView()
    }
}

struct LoadingView: View {
    var body: some View {
        ActivityIndicator(isAnimating: .constant(true))
            .frame(width: 50, height: 50)
    }
}

struct ImageView: View {
    var dogImageURL: URL?

    var body: some View {
        Group<AnyView> {
            if let dogImageURL = dogImageURL, let data = try? Data(contentsOf: dogImageURL), let uiImage = UIImage(data: data) {
                return AnyView(Image(uiImage: uiImage)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 200, height: 200)
                    .cornerRadius(10))
            } else {
                return AnyView(Text("No image available")
                    .foregroundColor(.gray))
            }
        }
    }
}

struct ActivityIndicator: UIViewRepresentable {
    @Binding var isAnimating: Bool

    func makeUIView(context: Context) -> UIActivityIndicatorView {
        UIActivityIndicatorView()
    }

    func updateUIView(_ uiView: UIActivityIndicatorView, context: Context) {
        isAnimating ? uiView.startAnimating() : uiView.stopAnimating()
    }
}

