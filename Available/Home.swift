//
//  Home.swift
//  Available
//
//  Created by Muhammad Farkhanudin on 02/08/23.
//  Copyright © 2023 Ardhita Eka Putri. All rights reserved.
//

import SwiftUI

struct Home: View {
    var body: some View {
        ScrollView {
            VStack(spacing: 30) {
                HomeAppRow(appName: "Cat Facts", imageName: "Cat", description: "Get random cat facts Message every day", destination: AnyView(CatFactView()))
                HomeAppRow(appName: "Random User", imageName: "Users", description: "To view information about random fake users", destination: AnyView(RandomUserView()))
                HomeAppRow(appName: "Agify.io", imageName: "Age", description: "Can find out the gender according to the name", destination: AnyView(AgifyView()))
                HomeAppRow(appName: "Dogs", imageName: "Dog", description: "To generate a random image of a dog", destination: AnyView(RandomDogImagesView()))
                HomeAppRow(appName: "Genderize.io", imageName: "Gender", description: "Predict someone's gender from name", destination: AnyView(GenderDetectionView()))
                HomeAppRow(appName: "Jokes", imageName: "Jokes", description: "Load random jokes that can entertain you", destination: AnyView(JokesView()))
            }
            .padding(.horizontal)
        }
        .navigationBarTitle("Home", displayMode: .inline)
    }
}

struct HomeAppRow: View {
    var appName: String
    var imageName: String
    var description: String
    var destination: AnyView // Use AnyView type for destination

    var body: some View {
        NavigationLink(destination: destination) {
            HStack {
                Image(imageName)
                    .resizable()
                    .renderingMode(.original) // Preserve original image color
                    .scaledToFit()
                    .frame(width: 65, height: 60)
                    .cornerRadius(8)
                    .background(Color.white) // Set a background color
                    .clipShape(RoundedRectangle(cornerRadius: 8))
                    .shadow(color: Color.black.opacity(0.2), radius: 4, x: 0, y: 2) // Add shadow

                VStack(alignment: .leading) {
                    Text(appName)
                        .font(.headline)
                        .foregroundColor(.black)

                    Text(description)
                        .font(.subheadline)
                        .foregroundColor(.gray)
                }
            }
            .padding(.vertical, 8) // Add vertical padding
        }
    }
}

struct Home_Previews: PreviewProvider {
    static var previews: some View {
        Home()
    }
}

