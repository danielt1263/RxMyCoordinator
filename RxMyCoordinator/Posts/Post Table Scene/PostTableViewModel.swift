//
//  PostTableViewModel.swift
//  RxMyCoordinator
//
//  Created by Daniel Tartaglia on 2/16/19.
//

import Foundation
import RxSwift

typealias PostAction = Result<Post>

func postTableViewModel(user: Observable<User?>, dataTask: @escaping (URLRequest) -> Observable<Result<Data>>) -> (_ inputs: PostTableInputs) -> (outputs: PostTableOutputs, action: Observable<PostAction>) {
	return { inputs in
		let load = Observable.merge(inputs.viewWillAppear, inputs.refresh)
		let response = load
			.withLatestFrom(user)
			.compactMap { $0.map { URLRequest.getPosts(id: $0.id) } }
			.flatMapLatest { dataTask($0) }
			.share(replay: 1)

		let posts = response
			.compactMap { $0.success }
			.map { try JSONDecoder().decode([Post].self, from: $0) }
			.share(replay: 1)

		let postDisplays = posts
			.map { $0.map(PostDisplay.init) }

		let refreshEnded = response
			.delay(.milliseconds(500), scheduler: MainScheduler.instance)
			.asVoid()

		let selected = inputs.select
			.withLatestFrom(posts) { $1[$0.row] }
			.map { PostAction.success($0) }

		let error = response
			.compactMap { $0.error }
			.map { PostAction.error($0) }

		let action = Observable.merge(selected, error)

		return (PostTableOutputs(postDisplays: postDisplays, refreshEnded: refreshEnded), action)
	}
}

extension PostDisplay {
	init(_ post: Post) {
		title = post.title
		body = post.body
	}
}
