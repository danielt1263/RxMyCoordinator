//
//  SettingsFlow.swift
//  RxMyCoordinator
//
//  Created by Daniel Tartaglia on 2/23/19.
//

import Foundation
import RxSwift

struct SettingsFlow {
	let dismiss: Observable<Void>
	let eraseUser: Observable<Void>
}

extension ObservableType where Element == SettingsAction {
	func flow(dismiss: @escaping () -> Observable<Void>) -> SettingsFlow {
		return SettingsFlow(
			dismiss: self
				.filter { $0 == .done }
				.asVoid()
			,
			eraseUser: self
				.filter { $0 == .logout }
				.asVoid()
				.flatMap { dismiss() }
		)
	}
}
