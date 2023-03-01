//
//  ContentView.swift
//  SwiftUIAndCloudKit
//
//  Created by Vinícius Flores Ribeiro on 13/02/23.
//

import SwiftUI

struct ContentView: View {

    // TODO: Refactor func to check if user exist
    // TODO: Change screen when do login

    @Environment(\.colorScheme) var colorScheme

//    @AppStorage("email") var email: String = ""
//    @AppStorage("firstName") var firstName: String = ""
//    @AppStorage("lastName") var lastName: String = ""
//    @AppStorage("userId") var userId: String = ""


    var cloudKit = CloudKitQuerys()

    @State var isSignedIn: Bool = false

//    private var isSignedIn: Bool {
//        UserDefaults.standard.string(forKey: "userId") != nil
//    }

    var body: some View {
        NavigationView {
            VStack {
                if !isSignedIn {
                    SignInWithAppleButtonView(cloudKit: cloudKit)
                } else {
                    TabView {
                        ListView()
                            .tabItem{
                                Label("List", systemImage: "list.bullet.circle.fill")
                            }
                        
                        ProfileView(cloudKit: cloudKit)
                            .tabItem{
                                Label("Profile", systemImage: "person.crop.circle.fill")
                            }
                    }
                    .onAppear {
                        cloudKit.fetchUser(userId: UserDefaults.standard.string(forKey: "userId") ?? "")
                    }
                }
            }
            .onAppear {
                let userId = UserDefaults.standard.string(forKey: "userId")
                if userId != nil && userId != "" {
                    isSignedIn = true
                }
                print("onAppear: \(isSignedIn)")
            }
            .onChange(of: cloudKit.isSignedIn) { _ in
                isSignedIn = true
                print("onChange: \(cloudKit.isSignedIn)")
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

