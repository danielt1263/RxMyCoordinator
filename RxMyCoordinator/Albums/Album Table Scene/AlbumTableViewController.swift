//
//  AlbumTableViewController.swift
//  RxMyCoordinator
//
//  Created by Daniel Tartaglia on 2/16/19.
//

import UIKit
import RxSwift
import RxCocoa

class AlbumTableViewController: UITableViewController {

	var viewModelFactory: (AlbumTableInputs) -> AlbumTableOutputs = { _ in fatalError("Missing view model factory.")}
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

		let inputs = AlbumTableInputs(viewWillAppear: viewWillAppear, refresh: refresh, select: tableView.rx.itemSelected.asObservable())
		let viewModel = viewModelFactory(inputs)

		let refreshControl = tableView.refreshControl!
		viewModel.refreshEnded
			.bind {
				refreshControl.endRefreshing()
			}
			.disposed(by: bag)

		viewModel.albums
			.bind(to: tableView.rx.items(cellIdentifier: "Cell", cellType: UITableViewCell.self)) { _, item, cell in
				cell.textLabel!.text = item.title
			}
			.disposed(by: bag)
    }
}

struct AlbumTableInputs {
	let viewWillAppear: Observable<Void>
	let refresh: Observable<Void>
	let select: Observable<IndexPath>
}

struct AlbumTableOutputs {
	let albums: Observable<[Album]>
	let refreshEnded: Observable<Void>
}
