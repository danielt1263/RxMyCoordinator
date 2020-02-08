//
//  SettingsViewModel.swift
//  RxMyCoordinator
//
//  Created by Daniel Tartaglia on 2/20/19.
//

import Foundation
import RxSwift

func settingsViewModel(user: Observable<User?>) -> (_ inputs: SettingsInputs) -> (outputs: SettingsOutputs, action: Observable<SettingsAction>) {
	return { inputs in
		let done = inputs.done
			.map { SettingsAction.done }

		let logout = inputs.logout
			.map { SettingsAction.logout }

		let logoutText = user
			.map { $0.map { "Logout \($0.username)" } ?? "Logout ..." }

		let action = Observable.merge(done, logout)

		return (SettingsOutputs.init(logoutText: logoutText), action)
	}
}

