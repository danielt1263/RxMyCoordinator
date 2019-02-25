//
//  ProfileFlow.swift
//  RxMyCoordinator
//
//  Created by Daniel Tartaglia on 2/20/19.
//

import UIKit
import RxSwift
import RxCocoa

func profileCoordinator(root: UINavigationController, user: Observable<User>) {
	let profile = root.topViewController as! ProfileViewController
	let action = profile.installOutputViewModel(outputFactory: profileViewModel(user: user))

	_ = action
		.subscribe(onNext: {
			settingsCoordinator(user: user)
		})
}

extension ProfileViewController: HasViewModel { }
