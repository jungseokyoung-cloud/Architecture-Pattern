//
//  Entity.swift
//  CoordinatorPattern
//
//  Created by jung on 5/26/24.
//

import Foundation

struct Post: Decodable {
	let userId: Int
	let id: Int
	let title: String
	let body: String
}
