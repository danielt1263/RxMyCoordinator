//
//  SettingsTableViewController.swift
//  RxMyCoordinator
//
//  Created by Daniel Tartaglia on 2/20/19.
//

import UIKit
import RxSwift
import RxCocoa

class SettingsTableViewController: UITableViewController {

	@IBOutlet weak var doneButtonItem: UIBarButtonItem!
	@IBOutlet weak var accountCell: UITableViewCell!
	private let bag = DisposeBag()

	var viewModelFactory: (SettingsInputs) -> SettingsOutputs = { _ in fatalError("Missing view model factory.") }

    override func viewDidLoad() {
        super.viewDidLoad()

		let inputs = SettingsInputs(
			done: doneButtonItem.rx.tap.asObservable(),
			logout: tableView.rx.itemSelected
				.filter { $0 == IndexPath(row: 0, section: 0) }
				.asVoid()
				.asObservable()
		)
		let viewModel = viewModelFactory(inputs)

		viewModel.logoutText
			.bind(to: accountCell.textLabel!.rx.text)
			.disposed(by: bag)
	}
}

struct SettingsInputs {
	let done: Observable<Void>
	let logout: Observable<Void>
}

struct SettingsOutputs {
	let logoutText: Observable<String>
}
