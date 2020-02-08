//
//  PostTableViewController.swift
//  RxMyCoordinator
//
//  Created by Daniel Tartaglia on 2/15/19.
//

import UIKit
import RxSwift
import RxCocoa

class PostTableViewController: UITableViewController {

	var viewModelFactory: (PostTableInputs) -> PostTableOutputs = { _ in fatalError("Missing view model factory.")}
	private let bag = DisposeBag()

	override func viewDidLoad() {
		super.viewDidLoad()
		tableView.dataSource = nil
		tableView.delegate = nil
		let viewWillAppear = rx.sentMessage(#selector(UIViewController.viewWillAppear(_:)))
			.asVoid()

		let refresh = tableView.refreshControl!.rx
			.controlEvent(.valueChanged)
			.asObservable()

		let inputs = PostTableInputs(viewWillAppear: viewWillAppear, refresh: refresh, select: tableView.rx.itemSelected.asObservable())
		let viewModel = viewModelFactory(inputs)

		let refreshControl = tableView.refreshControl!
		viewModel.refreshEnded
			.bind {
				refreshControl.endRefreshing()
			}
			.disposed(by: bag)

		viewModel.postDisplays
			.bind(to: tableView.rx.items(cellIdentifier: "Cell", cellType: UITableViewCell.self)) { _, item, cell in
				cell.textLabel!.text = item.title
				cell.detailTextLabel!.text = item.body
			}
			.disposed(by: bag)
	}
}

struct PostTableInputs {
	let viewWillAppear: Observable<Void>
	let refresh: Observable<Void>
	let select: Observable<IndexPath>
}

struct PostTableOutputs {
	let postDisplays: Observable<[PostDisplay]>
	let refreshEnded: Observable<Void>
}

struct PostDisplay {
	let title: String
	let body: String
}

