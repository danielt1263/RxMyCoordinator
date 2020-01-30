//
//  PostTableViewModel.swift
//  RxMyCoordinator
//
//  Created by Daniel Tartaglia on 2/16/19.
//

import Foundation
import RxSwift

typealias PostAction = Result<Post>

func postTableViewModel(user: Observable<User>, dataTask: @escaping (URLRequest) -> Observable<Result<Data>>) -> (_ inputs: PostTableInputs) -> (outputs: PostTableOutputs, action: Observable<PostAction>) {
	return { inputs in
		let load = Observable.merge(inputs.viewWillAppear, inputs.refresh)
		let response = load
			.withLatestFrom(user)
			.map { URLRequest.getPosts(id: $0.id) }
			.flatMapLatest { dataTask($0) }
			.share(replay: 1)

		let posts = response
			.map { $0.success }
			.unwrap()
			.map { try JSONDecoder().decode([Post].self, from: $0) }

		let refreshEnded = response
			.delay(.milliseconds(500), scheduler: MainScheduler.instance)
			.asVoid()

		let selected = inputs.select
			.withLatestFrom(posts) { $1[$0.row] }
			.map { PostAction.success($0) }

		let error = response
			.map { $0.error }
			.unwrap()
			.map { PostAction.error($0) }

		let action = Observable.merge(selected, error)

		return (PostTableOutputs(posts: posts, refreshEnded: refreshEnded), action)
	}
}
