//
//  SplitViewControllerDelegate.swift
//  RxMyCoordinator
//
//  Created by Daniel Tartaglia on 2/17/19.
//

import UIKit

enum SenderPosition {
	case master
	case detail
}

class SplitViewControllerDelegate: NSObject, UISplitViewControllerDelegate {

	func splitViewController(_ splitViewController: UISplitViewController, collapseSecondary secondaryViewController: UIViewController, onto primaryViewController: UIViewController) -> Bool {
		let tabBar = primaryViewController as! UITabBarController
		let secondary = secondaryViewController as! UINavigationController
		if let active = tabBar.selectedViewController as? UINavigationController, secondary.children.last?.restorationIdentifier != "placeholder" {
			active.viewControllers += secondary.viewControllers
			active.topViewController!.navigationItem.leftBarButtonItem = nil
		}
		return true
	}

	func splitViewController(_ splitViewController: UISplitViewController, separateSecondaryFrom primaryViewController: UIViewController) -> UIViewController? {
		let tabBarController = primaryViewController as! UITabBarController
		let selectedNavigation = tabBarController.selectedViewController as! UINavigationController
		guard selectedNavigation.viewControllers.count > 1 else { return nil }
		let navigation = UINavigationController()
		if let topVC = selectedNavigation.viewControllers.last {
			selectedNavigation.popViewController(animated: false)
			navigation.viewControllers = [topVC]
		}
		else {
			let placeholder = splitViewController.storyboard!.instantiateViewController(withIdentifier: "placeholder")
			navigation.viewControllers = [placeholder]
		}
		navigation.topViewController!.navigationItem.leftBarButtonItem = splitViewController.displayModeButtonItem
		return navigation
	}

	func splitViewController(_ splitViewController: UISplitViewController, showDetail vc: UIViewController, sender: Any?) -> Bool {
		if splitViewController.children.count == 1 || vc is UINavigationController || vc is UICollectionViewController {
			let tabBarController = splitViewController.children[0] as! UITabBarController
			let selectedNavigation = tabBarController.selectedViewController as! UINavigationController
			selectedNavigation.pushViewController(vc, animated: true)
		}
		else {
			let selectedNavigation = (splitViewController.children[1] as! UINavigationController)
			selectedNavigation.topViewController!.navigationItem.leftBarButtonItem = nil
			selectedNavigation.viewControllers = [vc]
			vc.navigationItem.leftBarButtonItem = splitViewController.displayModeButtonItem
		}
		return true
	}
}

