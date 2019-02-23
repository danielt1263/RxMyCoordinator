//
//  Todo.swift
//  RxMyCoordinator
//
//  Created by Daniel Tartaglia on 2/17/19.
//

import Foundation

struct Todo: Decodable {
	let id: Int
	let title: String
	let userId: Int
	let completed: Bool
}
