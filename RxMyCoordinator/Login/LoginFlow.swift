//
//  LoginFlow.swift
//  RxMyCoordinator
//
//  Created by Daniel Tartaglia on 2/23/19.
//

import Foundation
import RxSwift

extension ObservableType where Element == LoginAction {
	func flow(pushSignup: @escaping () -> Observable<SignupAction>) -> Observable<Result<Data>> {
		let signupAction = self
			.filter { $0.isWantsSignup }
			.asVoid()
			.flatMap(pushSignup)

		let loginResult = self
			.filter { $0.isWantsSignup == false }
			.map { $0.asResult }

		return Observable.merge(loginResult, signupAction)
			.map { userResult in
				userResult
					.map { try JSONEncoder().encode($0) }
			}
			.observe(on: MainScheduler.instance)
	}
}

extension LoginAction {
	var asResult: Result<User> {
		switch self {
		case .wantsSignup:
			fatalError("Be sure to filter out `wantsSignup` before maping to a Result")
		case .loginSuccess(let user):
			return .success(user)
		case .error(let error):
			return .error(error)
		}
	}

	var isWantsSignup: Bool {
		if case .wantsSignup = self { return true }
		else { return false }
	}

	var user: User? {
		if case let .loginSuccess(user) = self { return user }
		else { return nil }
	}

	var error: Error? {
		if case let .error(error) = self { return error }
		else { return nil }
	}
}
