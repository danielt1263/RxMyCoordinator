//
//  SignupViewController.swift
//  RxMyCoordinator
//
//  Created by Daniel Tartaglia on 2/20/19.
//

import UIKit
import RxSwift
import RxCocoa

class SignupViewController: UIViewController {

	@IBOutlet weak var firstNameTextField: UITextField!
	@IBOutlet weak var lastNameTextField: UITextField!
	@IBOutlet weak var emailTextField: UITextField!
	@IBOutlet weak var passwordTextField: UITextField!
	@IBOutlet weak var signupButton: UIButton!

	var viewModelFactory: (SignupInputs) -> Void = { _ in fatalError("Missing view model factory.") }

	override func viewDidLoad() {
        super.viewDidLoad()

		let inputs = SignupInputs(
			firstName: firstNameTextField.rx.text.orEmpty.asObservable(),
			lastName: lastNameTextField.rx.text.orEmpty.asObservable(),
			email: emailTextField.rx.text.orEmpty.asObservable(),
			password: passwordTextField.rx.text.orEmpty.asObservable(),
			signup: signupButton.rx.tap.asObservable()
		)

		viewModelFactory(inputs)
	}
}

struct SignupInputs {
	let firstName: Observable<String>
	let lastName: Observable<String>
	let email: Observable<String>
	let password: Observable<String>
	let signup: Observable<Void>
}
