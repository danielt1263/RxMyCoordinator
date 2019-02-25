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
				showDetailPostDetail(with: post)
			case .error(let error):
				presentAlert(title: "Error", message: error.localizedDescription)
			}
		})
}

func showDetailPostDetail(with post: Post) {
	let controller = PostDetailViewController()
	controller.post = post
	UIViewController.top().showDetailViewController(controller, sender: nil)
}

extension PostTableViewController: HasViewModel { }
