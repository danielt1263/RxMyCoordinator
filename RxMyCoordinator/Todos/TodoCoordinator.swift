//
//  TodoFlow.swift
//  RxMyCoordinator
//
//  Created by Daniel Tartaglia on 2/17/19.
//

import UIKit
import RxSwift
import RxCocoa

func todoCoordinator(root: UINavigationController) {
	let todoTable = root.topViewController as! TodoTableViewController
	let todoAction = todoTable.installOutputViewModel(outputFactory: todoTableViewModel(dataTask: dataTask(with:)))

	_ = todoAction
		.subscribe(onNext: { result in
			switch result {
			case .success(let todo):
				print("Selected: \(todo)")
			case .error(let error):
				displayAlert(title: "Error", message: error.localizedDescription)
			}
		})
}

extension TodoTableViewController: HasViewModel { }


