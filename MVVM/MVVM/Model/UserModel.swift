//
//  UserModel.swift
//  MVVM
//
//  Created by Seok Young Jung on 2023/03/28.
//

import Foundation

struct UserModel: Decodable {
    let id: Int
    let name: String
    let username: String
    let email: String
    let address: Address
    
    let phone: String
    let website: String
}

extension UserModel {
    init() {
        id = 1
        name = ""
        username = ""
        email = ""
        address = Address()
        phone = ""
        website = ""
    }
}

struct Address: Decodable {
    let street: String
    let suite: String
    let city: String
    let zipcode: String
}

extension Address {
    init() {
        street = ""
        suite = ""
        city = ""
        zipcode = ""
    }
}

extension UserModel {
    func isDummy() -> Bool {
        return username.isEmpty
    }
}
