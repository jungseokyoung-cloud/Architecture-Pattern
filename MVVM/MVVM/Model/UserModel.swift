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
//    let adrress: Address
//    let company: Company
}

struct Address: Decodable {
    let street: String
    let suite: String
    let city: String
    let zipcode: String
}

struct Company: Decodable {
    let name: String
    let catchPhrase: String
    let bs: String
}
