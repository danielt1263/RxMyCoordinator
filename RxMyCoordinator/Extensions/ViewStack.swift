//
//  ViewStack.swift
//  RxMyCoordinator
//
//  Created by Daniel Tartaglia on 2/22/19.
//

import UIKit

func topViewController() -> UIViewController {
	guard let rootViewController = UIApplication.shared.delegate?.window??.rootViewController else { fatalError("No view controller present in app?") }
	var result = rootViewController
	while let vc = result.presentedViewController {
		result = vc
	}
	return result
}

func topNavigationController() -> UINavigationController? {
	return topViewController() as? UINavigationController
}
