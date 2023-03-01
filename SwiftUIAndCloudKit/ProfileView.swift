//
//  MenuView.swift
//  SwiftUIAndCloudKit
//
//  Created by Vinícius Flores Ribeiro on 14/02/23.
//

import SwiftUI

struct ProfileView: View {

//    let userId: String
//    var cloudKit = CloudKitQuerys()
//    var user: User
//    var cloudKit: CloudKitQuerys
    //@AppStorage("firstName") var firstName: String?


//    init(userId: String) {
//        cloudKit.fetchAllItems()
//        self.userId = userId
//        self.user = cloudKit.fetchUser(userId: userId)
//    }

    var cloudKit: CloudKitQuerys


    var body: some View {
        VStack {
            Text("Profile")
            Text("User first name: \(UserDefaults.standard.string(forKey: "firstName") ?? "FIRST NAME")")
            Text("User last name:  \(UserDefaults.standard.string(forKey: "lastName") ?? "LAST NAME")")
            Text("User email:  \(UserDefaults.standard.string(forKey: "email") ?? "EMAIL")")
            Text("User Id:  \(UserDefaults.standard.string(forKey: "userId") ?? "USER ID")")

        }
    }

}

struct MenuView_Previews: PreviewProvider {
    static var previews: some View {
        ProfileView(cloudKit: CloudKitQuerys())
    }
}
