//
//  SettingsFlow.swift
//  RxMyCoordinator
//
//  Created by Daniel Tartaglia on 2/20/19.
//

import UIKit
import RxSwift
import RxCocoa

enum SettingsAction {
	case done
	case logout
}

func settingsCoordinator(root: UIViewController, user: Observable<User>) {
	let navigation = UIStoryboard(name: "SettingsView", bundle: nil).instantiateInitialViewController() as! UINavigationController
	let settings = navigation.topViewController as! SettingsTableViewController
	let action = settings.installOutputViewModel(outputFactory: settingsViewModel(user: user))
		.share(replay: 1)

	settings.title = "Settings"

	let flow = action.flow(dismiss: { root.rxDismiss(animated: false) })

	_ = flow.dismiss
		.subscribe(onNext: {
			root.dismiss(animated: true)
		})

	_ = flow.eraseUser
		.subscribe(onNext: {
			UserDefaults.standard.set(nil, forKey: "user")
		})

	root.present(navigation, animated: true)
}

extension SettingsTableViewController: HasViewModel { }

extension UIViewController {
	func rxDismiss(animated: Bool) -> Observable<Void> {
		return Observable.create { [weak self] observer in
			self?.dismiss(animated: animated, completion: {
				observer.onNext(())
				observer.onCompleted()
			})
			return Disposables.create()
		}
	}
}
