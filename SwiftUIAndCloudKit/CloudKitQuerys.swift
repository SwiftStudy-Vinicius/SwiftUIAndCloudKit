//
//  CloudKit.swift
//  SwiftUIAndCloudKit
//
//  Created by Vinícius Flores Ribeiro on 14/02/23.
//

import Foundation
import CloudKit
import SwiftUI

class CloudKitQuerys {

//    @AppStorage("email") var email: String = ""
//    @AppStorage("firstName") var firstName: String = ""
//    @AppStorage("lastName") var lastName: String = ""
//    @AppStorage("userId") var userId: String = ""

    private let database = CKContainer(identifier: "iCloud.SwiftUI").publicCloudDatabase

    var users: [User] = []

    var actualUser: User = User(email: "", firstName: "", lastName: "", userId: "")

    var isSignedIn: Bool = false

    // MARK: - FETCH
    func fetchAllItems() {
        let query = CKQuery(recordType: "UsersData", predicate: NSPredicate(value: true))

        database.perform(query, inZoneWith: nil) { records, error in
            guard let records = records, error == nil else {
                return
            }
            DispatchQueue.main.async {
                self.users.removeAll()
                for record in records {
                    let email = record.value(forKey: "email") as? String ?? ""
                    let firstName = record.value(forKey: "firstName") as? String ?? ""
                    let lastName = record.value(forKey: "lastName") as? String ?? ""
                    let userId = record.value(forKey: "userId") as? String ?? ""
                    self.users.append(User(email: email, firstName: firstName, lastName: lastName, userId: userId))
                }
                print("FETCH: \(self.users)")
            }
        }

    }

    // MARK: - SAVE

    func saveUser(newUser: User) {
        let record = CKRecord(recordType: "UsersData")
        record.setValue(newUser.email, forKey: "email")
        record.setValue(newUser.firstName, forKey: "firstName")
        record.setValue(newUser.lastName, forKey: "lastName")
        record.setValue(newUser.userId, forKey: "userId")
        database.save(record) { record, error in
            if record != nil, error == nil {
                DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                    guard let user = record else { return }
                    self.users.append(User(email: user.value(forKey: "email") as! String, firstName: user.value(forKey: "firstName") as! String, lastName: user.value(forKey: "lastName") as! String, userId: user.value(forKey: "userId") as! String))
//                    self.firstName = user.value(forKey: "firstName") as! String
                    print("CREATE USER: \(user)")
                    UserDefaults.standard.set(user.value(forKey: "userId"), forKey: "userId")
                    UserDefaults.standard.set(user.value(forKey: "firstName"), forKey: "firstName")
                    UserDefaults.standard.set(user.value(forKey: "lastName"), forKey: "lastName")
                    UserDefaults.standard.set(user.value(forKey: "email"), forKey: "email")
                    self.isSignedIn = true
                }
            }
        }
    }

    // MARK: - USER EXIST

    func userExist(userId: String) -> Bool {
        fetchAllItems()
        var userExist: Bool = false
        
        for user in users {
            if user.userId == userId {
                userExist = true
                self.isSignedIn = true
            }
        }
        return userExist
    }

    // MARK: - FETCH USER

    func fetchUser(userId: String){
        print("USER ID: \(userId)")
        fetchAllItems()
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            for user in self.users {
                if user.userId == userId {
                    self.actualUser = user
                }
            }
            print("ACTUAL USER: \(self.actualUser)")
            UserDefaults.standard.set(self.actualUser.userId, forKey: "userId")
            UserDefaults.standard.set(self.actualUser.firstName, forKey: "firstName")
            UserDefaults.standard.set(self.actualUser.lastName, forKey: "lastName")
            UserDefaults.standard.set(self.actualUser.email, forKey: "email")
        }
    }
}

