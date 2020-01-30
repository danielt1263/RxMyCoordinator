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
	let navigation = UINavigationController(rootViewController: login)
	navigation.modalPresentationStyle = .fullScreen
	let action = login.installOutputViewModel(outputFactory: loginViewModel(dataTask: dataTask(with:)))
		.share(replay: 1)
	let root = UIViewController.top()
	root.present(navigation, animated: false)

	_ = action.flow(pushSignup: showSignupViewController)
		.subscribe(onNext: { result in
			switch result {
			case .success(let data):
				UserDefaults.standard.set(data, forKey: "user")
				root.dismiss(animated: true)
			case .error(let error):
				presentAlert(title: "Error", message: error.localizedDescription)
			}
		})
}

func showSignupViewController() -> Observable<SignupAction> {
	let controller = SignupViewController()
	UIViewController.top().show(controller, sender: nil)
	return controller.installOutputViewModel(outputFactory: signupViewModel(dataTask: dataTask(with:)))
}

extension LoginViewController: HasViewModel { }
extension SignupViewController: HasViewModel { }
