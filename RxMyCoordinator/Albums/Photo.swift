//
//  Photo.swift
//  RxMyCoordinator
//
//  Created by Daniel Tartaglia on 2/17/19.
//

import Foundation

struct Photo: Decodable {
	let id: Int
	let albumId: Int
	let title: String
	let thumbnailUrl: URL
	let url: URL
}
