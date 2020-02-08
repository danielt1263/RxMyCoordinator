//
//  SignupViewModel.swift
//  RxMyCoordinator
//
//  Created by Daniel Tartaglia on 2/20/19.
//

import Foundation
import RxSwift

typealias SignupAction = Result<User>

func signupViewModel(dataTask: @escaping (URLRequest) -> Observable<Result<Data>>) -> (_ inputs: SignupInputs) -> (Void, Observable<SignupAction>) {
	return { inputs in
		let signupParams = Observable.combineLatest(inputs.firstName, inputs.lastName, inputs.email, inputs.password) { (firstName: $0, lastName: $1, email: $2, password: $3) }

		let response = inputs.signup
			.withLatestFrom(signupParams)
			.flatMap { params -> Observable<Result<Data>> in
				// just a mock
				let loginResult = arc4random() % 5 == 0 ? false : true
				guard loginResult == true else { return Observable.just(.error(AuthenticationError.invalidCredentials)) }
				return dataTask(URLRequest.getUser(id: 1))
			}
			.share(replay: 1)

		let user = response
			.compactMap { $0.success }
			.map { try JSONDecoder().decode(User.self, from: $0) }
			.map { SignupAction.success($0) }

		let error = response
			.compactMap { $0.error }
			.map { SignupAction.error($0) }

		return ((), Observable.merge(user, error))
	}
}

