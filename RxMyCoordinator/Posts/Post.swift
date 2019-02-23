//
//  Post.swift
//  RxMyCoordinator
//
//  Created by Daniel Tartaglia on 2/15/19.
//

import Foundation

struct Post: Decodable {
	let id: Int
	let title: String
	let body: String
	let userId: Int
}
