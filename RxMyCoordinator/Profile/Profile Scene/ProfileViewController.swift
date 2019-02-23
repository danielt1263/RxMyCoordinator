//
//  ProfileViewController.swift
//  RxMyCoordinator
//
//  Created by Daniel Tartaglia on 2/20/19.
//

import UIKit
import RxSwift
import RxCocoa

class ProfileViewController: UIViewController {

	@IBOutlet weak var settingsButtonItem: UIBarButtonItem!
	@IBOutlet weak var avatarView: UIView!
	@IBOutlet weak var avatarLabel: UILabel!
	@IBOutlet weak var nameLabel: UILabel!
	@IBOutlet weak var usernameLabel: UILabel!

	private let bag = DisposeBag()

	var viewModelFactory: (ProfileInputs) -> ProfileOutputs = { _ in fatalError("Missing view model factory.") }

	override func viewDidLoad() {
		super.viewDidLoad()

		avatarView.layer.cornerRadius = 35
		avatarView.clipsToBounds = true

		let viewModel = viewModelFactory(ProfileInputs(settings: settingsButtonItem.rx.tap.asObservable()))

		bag.insert(
			viewModel.initials.bind(to: avatarLabel.rx.text),
			viewModel.name.bind(to: nameLabel.rx.text),
			viewModel.username.bind(to: usernameLabel.rx.text)
		)
	}
}

struct ProfileInputs {
	let settings: Observable<Void>
}

struct ProfileOutputs {
	let initials: Observable<String>
	let name: Observable<String>
	let username: Observable<String>
}
