//
//  SignInWithAppleButtonView.swift
//  SwiftUIAndCloudKit
//
//  Created by Vinícius Flores Ribeiro on 13/02/23.
//

import SwiftUI
import AuthenticationServices
import CloudKit

struct SignInWithAppleButtonView: View {

    @Environment(\.colorScheme) var colorScheme

//    @AppStorage("email") var email: String = ""
//    @AppStorage("firstName") var firstName: String = ""
//    @AppStorage("lastName") var lastName: String = ""
//    @AppStorage("userId") var userId: String = ""

    var cloudKit: CloudKitQuerys

    var body: some View {

        SignInWithAppleButton(.continue) { request in
            request.requestedScopes = [.email, .fullName]
        } onCompletion: { result in
            switch result {
            case .success(let auth):

                switch auth.credential {
                case let credential as ASAuthorizationAppleIDCredential:

                    // If the user do the login again, just the userID will be visible
                    let userId = credential.user

                    // User info
                    let email = credential.email ?? ""
                    let firstName = credential.fullName?.givenName ?? ""
                    let lastName = credential.fullName?.familyName ?? ""

                    // Save information in cache
//                    self.email = email ?? ""
//                    self.firstName = firstName ?? ""
//                    self.lastName = lastName ?? ""
                    //self.userId = userId


                    if !cloudKit.userExist(userId: userId) {
                        // Save in CloudKit
                        cloudKit.saveUser(newUser: User(email: email, firstName: firstName, lastName: lastName, userId: userId))
                    }

                    cloudKit.isSignedIn = true

                default:
                    break
                }

            case .failure(let error):
                print(error)
            }
        }
        .signInWithAppleButtonStyle(
            colorScheme == .dark ? .white : .black
        )
        .frame(height: 50)
        .padding()
        .cornerRadius(8)
        .navigationTitle("Sign In")
    }


}

struct SignInWithAppleButtonView_Previews: PreviewProvider {
    static var previews: some View {
        SignInWithAppleButtonView(cloudKit: CloudKitQuerys())
    }
}
