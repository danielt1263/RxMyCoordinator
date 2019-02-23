//
//  PostCoordinator.swift
//  RxMyCoordinator
//
//  Created by Daniel Tartaglia on 2/17/19.
//

import UIKit
import RxSwift
import RxCocoa

func postsCoordinator(root: UINavigationController, user: Observable<User>) {
	let postTable = root.topViewController as! PostTableViewController
	let postAction = postTable.installOutputViewModel(outputFactory: postTableViewModel(user: user, dataTask: dataTask(with:)))

	_ = postAction
		.subscribe(onNext: { result in
			switch result {
			case .success(let post):
				root.displayPostDetail(with: post)
			case .error(let error):
				displayAlert(title: "Error", message: error.localizedDescription)
			}
		})
}

extension UIViewController {
	func displayPostDetail(with post: Post) {
		let controller = PostDetailViewController()
		controller.post = post
		self.showDetailViewController(controller, sender: nil)
	}
}

extension PostTableViewController: HasViewModel { }
