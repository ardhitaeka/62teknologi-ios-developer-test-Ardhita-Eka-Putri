//
//  RandomUserView.swift
//  Available
//
//  Created by Muhammad Farkhanudin on 02/08/23.
//  Copyright © 2023 Ardhita Eka Putri. All rights reserved.
//

import SwiftUI

struct RandomUserView: View {
    @State private var users: [User] = []
    @State private var searchText = ""

    var body: some View {
        NavigationView {
            VStack {
                SearchBar(text: $searchText, onSearchButtonClicked: loadData)
                List(filteredUsers, id: \.login.uuid) { user in
                    HStack {
                        VStack(alignment: .leading) {
                            Text("\(user.name.title). \(user.name.first) \(user.name.last)")
                                .font(.headline)
                                .foregroundColor(.black)
                            Text(user.email)
                                .font(.subheadline)
                                .foregroundColor(.gray)
                            Text("\(user.location.city), \(user.location.country)")
                                .font(.subheadline)
                                .foregroundColor(.gray)
                        }
                        Spacer()
                        RemoteImage(url: user.picture.medium)
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 80, height: 80)
                            .cornerRadius(8)
                    }
                }
            }
            .navigationBarTitle("Random User")
            .onAppear(perform: loadData)
        }
    }

    private func loadData() {
        guard let url = URL(string: "https://randomuser.me/api/") else {
            return
        }

        URLSession.shared.dataTask(with: url) { data, response, error in
            if let data = data {
                if let decodedResponse = try? JSONDecoder().decode(RandomUserResponse.self, from: data) {
                    DispatchQueue.main.async {
                        self.users = decodedResponse.results
                    }
                    return
                }
            }

            print("Failed to load random users")
        }.resume()
    }

    private var filteredUsers: [User] {
        if searchText.isEmpty {
            return users
        } else {
            return users.filter { $0.login.username.localizedCaseInsensitiveContains(searchText) }
        }
    }
}

struct RandomUserView_Previews: PreviewProvider {
    static var previews: some View {
        RandomUserView()
    }
}

struct RandomUserResponse: Codable {
    let results: [User]
}

struct User: Codable, Identifiable {
    let id = UUID()
    let gender: String
    let name: Name
    let email: String
    let login: Login
    let location: Location
    let dob: Dob
    let phone: String
    let cell: String
    let picture: Picture
}

struct Name: Codable {
    let title: String
    let first: String
    let last: String
}

struct Login: Codable {
    let uuid: String
    let username: String
}

struct Location: Codable {
    let city: String
    let country: String
}

struct Dob: Codable {
    let date: String
    let age: Int
}

struct Picture: Codable {
    let large: String
    let medium: String
    let thumbnail: String
}

struct SearchBar: View {
    @Binding var text: String
    var onSearchButtonClicked: () -> Void

    var body: some View {
        HStack {
            TextField("Search", text: $text, onCommit: onSearchButtonClicked)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding(.horizontal)
                .disableAutocorrection(true)
            Button(action: onSearchButtonClicked) {
                Text("Search")
            }
            .foregroundColor(.white)
            .padding(.horizontal)
            .padding(.vertical, 8)
            .background(Color.black)
            .cornerRadius(8)
        }
    }
}

struct RemoteImage: View {
    let url: String
    @State private var image: Image = Image(systemName: "photo")

    var body: some View {
        image
            .onAppear(perform: loadImage)
    }

    private func loadImage() {
        guard let url = URL(string: url) else { return }
        URLSession.shared.dataTask(with: url) { data, _, _ in
            if let data = data, let uiImage = UIImage(data: data) {
                DispatchQueue.main.async {
                    self.image = Image(uiImage: uiImage)
                }
            }
        }.resume()
    }
}
