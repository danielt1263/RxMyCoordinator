//
//  ProfileFlow.swift
//  RxMyCoordinator
//
//  Created by Daniel Tartaglia on 2/20/19.
//

import UIKit
import RxSwift
import RxCocoa

struct ProfileAction { }

func profileCoordinator(root: UINavigationController, user: Observable<User>) {
	let profile = root.topViewController as! ProfileViewController
	let action = profile.installOutputViewModel(outputFactory: profileViewModel(user: user))

	_ = action
		.subscribe(onNext: { _ in
			settingsCoordinator(root: root, user: user)
		})
}

extension ProfileViewController: HasViewModel { }
