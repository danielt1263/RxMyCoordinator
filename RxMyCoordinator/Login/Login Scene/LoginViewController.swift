//
//  LoginViewController.swift
//  RxMyCoordinator
//
//  Created by Daniel Tartaglia on 2/17/19.
//

import UIKit
import RxSwift
import RxCocoa

class LoginViewController: UIViewController {

	@IBOutlet weak var emailTextField: UITextField!
	@IBOutlet weak var passwordTextField: UITextField!
	@IBOutlet weak var loginButton: UIButton!
	@IBOutlet weak var signupButton: UIButton!

	var viewModelFactory: (LoginInputs) -> Void = { _ in fatalError("Missing view model factory.") }

	override func viewDidLoad() {
		super.viewDidLoad()

		let inputs = LoginInputs(
			email: emailTextField.rx.text.orEmpty.asObservable(),
			password: passwordTextField.rx.text.orEmpty.asObservable(),
			login: loginButton.rx.tap.asObservable(),
			signup: signupButton.rx.tap.asObservable()
		)

		viewModelFactory(inputs)

	}
}

struct LoginInputs {
	let email: Observable<String>
	let password: Observable<String>
	let login: Observable<Void>
	let signup: Observable<Void>
}
