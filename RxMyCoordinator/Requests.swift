//
//  Requests.swift
//  RxMyCoordinator
//
//  Created by Daniel Tartaglia on 2/15/19.
//

import Foundation

let baseURLString = "https://jsonplaceholder.typicode.com"

extension URLRequest {
	static func getPosts(id: Int) -> URLRequest {
		var components = URLComponents(string: baseURLString)!
		components.path = "/posts"
		components.queryItems = [URLQueryItem(name: "userId", value: "\(id)")]
		return URLRequest(url: components.url!)
	}

	static let getAlbums: URLRequest = {
		var components = URLComponents(string: baseURLString)!
		components.path = "/albums"
		return URLRequest(url: components.url!)
	}()

	static func getPhotos(forAlbumId id: Int) -> URLRequest {
		var components = URLComponents(string: baseURLString)!
		components.path = "/photos"
		components.queryItems = [URLQueryItem(name: "albumId", value: "\(id)")]
		return URLRequest(url: components.url!)
	}

	static let getTodos: URLRequest = {
		var components = URLComponents(string: baseURLString)!
		components.path = "/todos"
		return URLRequest(url: components.url!)
	}()

	static func getUser(id: Int) -> URLRequest {
		var components = URLComponents(string: baseURLString)!
		components.path = "/users/\(id)"
		return URLRequest(url: components.url!)
	}
}
