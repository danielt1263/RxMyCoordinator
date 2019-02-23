//
//  loginViewModel.swift
//  RxMyCoordinator
//
//  Created by Daniel Tartaglia on 2/17/19.
//

import Foundation
import RxSwift

enum AuthenticationError: Error {
	case invalidCredentials
}

enum LoginAction {
	case wantsSignup
	case loginSuccess(User)
	case error(Error)
}

func loginViewModel(dataTask: @escaping (URLRequest) -> Observable<Result<Data>>) -> (_ inputs: LoginInputs) -> (Void, Observable<LoginAction>) {
	return { inputs in
		let credentials = Observable.combineLatest(inputs.email, inputs.password) { (email: $0, password: $1) }
		let response = inputs.login
			.withLatestFrom(credentials)
			.flatMap { (credentials) -> Observable<Result<Data>> in
				// just a mock
				let loginResult = arc4random() % 5 == 0 ? false : true
				guard loginResult == true else { return Observable.just(.error(AuthenticationError.invalidCredentials)) }
				return dataTask(URLRequest.getUser(id: 1))
			}
			.share(replay: 1)

		let user = response
			.map { $0.map { try JSONDecoder().decode(User.self, from: $0) } }
			.map { $0.map { LoginAction.loginSuccess($0) } }
			.map { $0.success }
			.unwrap()

		let error = response
			.map { $0.error }
			.unwrap()
			.map { LoginAction.error($0) }

		let wantsSignup = inputs.signup
			.map { LoginAction.wantsSignup }

		return ((), Observable.merge(wantsSignup, user, error))
	}
}

