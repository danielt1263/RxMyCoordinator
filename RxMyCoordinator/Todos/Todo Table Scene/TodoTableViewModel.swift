//
//  TodoTableViewModel.swift
//  RxMyCoordinator
//
//  Created by Daniel Tartaglia on 2/17/19.
//

import Foundation
import RxSwift

typealias TodoAction = Result<Todo>

func todoTableViewModel(dataTask: @escaping (URLRequest) -> Observable<Result<Data>>) -> (_ inputs: TodoTableInputs) -> (outputs: TodoTableOutputs, action: Observable<TodoAction>) {
	return { inputs in
		let load = Observable.merge(inputs.viewWillAppear, inputs.refresh)
		let response = load
			.map { URLRequest.getTodos }
			.flatMapLatest { dataTask($0) }
			.share(replay: 1)

		let todos = response
			.compactMap { $0.success }
			.map { try JSONDecoder().decode([Todo].self, from: $0) }

		let refreshEnded = response
			.delay(.milliseconds(500), scheduler: MainScheduler.instance)
			.asVoid()

		let selected = inputs.select
			.withLatestFrom(todos) { $1[$0.row] }
			.map { TodoAction.success($0) }

		let error = response
			.compactMap { $0.error }
			.map { TodoAction.error($0) }

		let action = Observable.merge(selected, error)

		return (TodoTableOutputs(todos: todos, refreshEnded: refreshEnded), action)
	}
}
