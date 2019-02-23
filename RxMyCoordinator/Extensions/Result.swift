//
//  Result.swift
//  RxMyCoordinator
//
//  Created by Daniel Tartaglia on 2/22/19.
//

import Foundation

enum Result<T> {
	case success(T)
	case error(Error)
}

extension Result {
	public init(_ from: () throws -> T) {
		do {
			self = .success(try from())
		}
		catch {
			self = .error(error)
		}
	}

	func catchErrorJustReturn(_ replacement: T) -> T {
		switch self {
		case .success(let t):
			return t
		case .error:
			return replacement
		}
	}

	func map<U>(_ transform: (T) throws -> U) -> Result<U> {
		switch self {
		case .success(let t):
			do {
				return .success(try transform(t))
			}
			catch {
				return .error(error)
			}
		case .error(let error):
			return .error(error)
		}
	}

	func flatMap<U>(_ transform: (T) throws -> Result<U>) -> Result<U> {
		switch self {
		case .success(let t):
			do {
				return try transform(t)
			}
			catch {
				return .error(error)
			}
		case .error(let error):
			return .error(error)
		}
	}
	
	var success: T? {
		if case let .success(t) = self { return t }
		else { return nil }
	}

	var error: Error? {
		if case let .error(error) = self { return error }
		else { return nil }
	}
}
