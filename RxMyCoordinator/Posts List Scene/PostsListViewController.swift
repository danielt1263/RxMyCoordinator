//
//  PostsListViewController.swift
//  RxMyCoordinator
//
//  Created by Daniel Tartaglia on 2/15/19.
//

import UIKit
import RxSwift
import RxCocoa
import RxSwiftExt

class PostsListViewController: UITableViewController {

	var viewModelFactory: (PostsListInputs) -> PostsListOutputs = { _ in fatalError("Missing view model factory.")}
	let bag = DisposeBag()

	override func viewDidLoad() {
		super.viewDidLoad()
		tableView.dataSource = nil
		tableView.delegate = nil
		let viewWillAppear = rx.sentMessage(#selector(UIViewController.viewWillAppear(_:)))
			.toVoid()

		let refresh = tableView.refreshControl!.rx
			.controlEvent(.valueChanged)
			.asObservable()

		let inputs = PostsListInputs(viewWillAppear: viewWillAppear, refresh: refresh, select: tableView.rx.itemSelected.asObservable())
		let viewModel = viewModelFactory(inputs)

		let refreshControl = tableView.refreshControl!
		viewModel.refreshEnded
			.bind {
				refreshControl.endRefreshing()
			}
			.disposed(by: bag)

		viewModel.posts
			.bind(to: tableView.rx.items(cellIdentifier: "Cell", cellType: UITableViewCell.self)) { index, item, cell in
				cell.textLabel!.text = item.title
				cell.detailTextLabel!.text = item.body
			}
			.disposed(by: bag)
	}
}

struct PostsListInputs {
	let viewWillAppear: Observable<Void>
	let refresh: Observable<Void>
	let select: Observable<IndexPath>
}

struct PostsListOutputs {
	let posts: Observable<[Post]>
	let refreshEnded: Observable<Void>
}


