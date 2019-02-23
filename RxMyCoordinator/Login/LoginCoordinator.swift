//
//  LoginFlow.swift
//  RxMyCoordinator
//
//  Created by Daniel Tartaglia on 2/17/19.
//

import UIKit
import RxSwift
import RxCocoa

func loginCoordinator() {
	let login = LoginViewController()
	let loginAction = login.installOutputViewModel(outputFactory: loginViewModel(dataTask: dataTask(with:)))
		.share(replay: 1)

	_ = loginAction.flow(pushSignup: pushSignupViewController)
		.subscribe(onNext: { result in
			switch result {
			case .success(let data):
				UserDefaults.standard.set(data, forKey: "user")
				topViewController().dismiss(animated: true)
			case .error(let error):
				displayAlert(title: "Error", message: error.localizedDescription)
			}
		})

	let navigation = UINavigationController(rootViewController: login)
	topViewController().present(navigation, animated: false)
}

func pushSignupViewController() -> Observable<SignupAction> {
	let controller = SignupViewController()
	topNavigationController()!.pushViewController(controller, animated: true)
	return controller.installOutputViewModel(outputFactory: signupViewModel(dataTask: dataTask(with:)))
}

extension LoginViewController: HasViewModel { }
extension SignupViewController: HasViewModel { }
