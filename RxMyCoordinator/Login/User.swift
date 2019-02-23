//
//  User.swift
//  RxMyCoordinator
//
//  Created by Daniel Tartaglia on 2/20/19.
//

import Foundation

struct User: Codable {
	let address: Address
	let company: Company
	let email: String
	let id: Int
	let name: String
	let phone: String
	let username: String
	let website: String
}

struct Address: Codable {
	let city: String
	let geo: Geo
	let street: String
	let suite: String
	let zipcode: String
}

struct Geo: Codable {
	let lat: String
	let lng: String
}

struct Company: Codable {
	let bs: String
	let catchPhrase: String
	let name: String
}

extension User {
	var initials: String {
		return name.split(separator: " ")
			.compactMap { $0.first.map { String($0) } }
			.joined()
	}
}
