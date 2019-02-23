//
//  AppDelegate.swift
//  RxMyCoordinator
//
//  Created by Daniel Tartaglia on 2/15/19.
//

import UIKit
import RxSwift
import RxCocoa

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, UISplitViewControllerDelegate {

	var window: UIWindow?
	var splitViewControllerDelegate: SplitViewControllerDelegate?
	let bag = DisposeBag()

	func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
		splitViewControllerDelegate = SplitViewControllerDelegate()
		let splitViewController = window!.rootViewController as! UISplitViewController
		splitViewController.delegate = splitViewControllerDelegate!
		mainCoordinator(root: window!)

		#if DEBUG
		_ = Observable<Int>.interval(1, scheduler: MainScheduler.instance)
			.map { _ in RxSwift.Resources.total }
			.distinctUntilChanged()
			.subscribe(onNext: { print("Resource count \($0)") })
		#endif

		return true
	}
}
