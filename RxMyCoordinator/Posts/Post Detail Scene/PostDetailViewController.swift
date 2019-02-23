//
//  PostDetailViewController.swift
//  RxMyCoordinator
//
//  Created by Daniel Tartaglia on 2/16/19.
//

import UIKit

class PostDetailViewController: UIViewController {

	@IBOutlet weak var titleLabel: UILabel!
	@IBOutlet weak var bodyLabel: UILabel!

	var post: Post!

    override func viewDidLoad() {
        super.viewDidLoad()

		titleLabel.text = post.title
		bodyLabel.text = post.body
	}
}
