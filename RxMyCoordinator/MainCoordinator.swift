//
//  MainCoordinator.swift
//  RxMyCoordinator
//
//  Created by Daniel Tartaglia on 2/15/19.
//

import UIKit
import RxSwift
import RxCocoa

func mainCoordinator(root: UIWindow) {
	let splitViewController = root.rootViewController as! UISplitViewController
	let tabBarController = splitViewController.children[0] as! UITabBarController
	let postNavigation = (tabBarController.children[0] as! UINavigationController)
	let albumNavigation = (tabBarController.children[1] as! UINavigationController)
	let todoNavigation = (tabBarController.children[2] as! UINavigationController)
	let profileNavigation = (tabBarController.children[3] as! UINavigationController)

	let user = UserDefaults.standard.rx.observe(Data.self, "user")
		.map { data in
			Result {
				try data.map { try JSONDecoder().decode(User.self, from: $0) }
			}
		}
		.map { $0.catchErrorJustReturn(nil) }
		.share(replay: 1)

	postsCoordinator(root: postNavigation, user: user.unwrap())
	albumsCoordinator(root: albumNavigation)
	todoCoordinator(root: todoNavigation)
	profileCoordinator(root: profileNavigation, user: user.unwrap())

	let appAppeared = splitViewController.rx.methodInvoked(#selector(UIViewController.viewDidAppear(_:)))
		.asVoid()
	let isLoggedOut = user
		.map { $0 == nil }

	_ = Observable.combineLatest(appAppeared, isLoggedOut) { $1 }
		.distinctUntilChanged()
		.filter { $0 }
		.subscribe(onNext: { _ in
			tabBarController.selectedIndex = 0
			loginCoordinator()
		})
}
