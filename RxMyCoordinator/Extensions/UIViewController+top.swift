//
//  UIViewController+top.swift
//  RxEarthquake
//
//  Created by Daniel Tartaglia on 9/8/18.
//  Copyright © 2018 Daniel Tartaglia. MIT License.
//

import UIKit

extension UIViewController {
	static func top() -> UIViewController {
		guard let rootViewController = UIApplication.shared.delegate?.window??.rootViewController else { fatalError("No view controller present in app?") }
		var result = rootViewController
		while let vc = result.presentedViewController {
			result = vc
		}

		if let tabBar = result as? UITabBarController {
			result = tabBar.selectedViewController ?? tabBar
		}

		if let navigation = result as? UINavigationController {
			result = navigation.topViewController ?? navigation
		}
		return result
	}
}
