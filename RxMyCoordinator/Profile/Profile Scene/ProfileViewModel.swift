//
//  ProfileViewModel.swift
//  RxMyCoordinator
//
//  Created by Daniel Tartaglia on 2/20/19.
//

import Foundation
import RxSwift

func profileViewModel(user: Observable<User>) -> (_ inputs: ProfileInputs) -> (outputs: ProfileOutputs, action: Observable<ProfileAction>) {
	return { inputs in
		let initials = user
			.map { $0.initials }

		let name = user
			.map { $0.name }

		let username = user
			.map { $0.username }

		let action = inputs.settings
			.map { ProfileAction() }

		return (ProfileOutputs(initials: initials, name: name, username: username), action)
	}
}
