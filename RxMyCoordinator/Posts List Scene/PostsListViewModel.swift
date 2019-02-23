//
//  PostsListViewModel.swift
//  RxMyCoordinator
//
//  Created by Daniel Tartaglia on 2/16/19.
//

import Foundation
import RxSwift

struct PostsListSignals {
	let selectedPost: Observable<Post>
	let networkError: Observable<Error>
}

func postsListViewModel(_ inputs: PostsListInputs, dataTask: @escaping (URLRequest) -> Observable<Event<Data>>) -> (PostsListOutputs, signals: PostsListSignals) {
	let load = Observable.merge(inputs.viewWillAppear, inputs.refresh)
	let response = load
		.map { URLRequest.getPosts }
		.flatMapLatest { dataTask($0) }
		.share(replay: 1)

	let posts = response
		.map { $0.element }
		.unwrap()
		.map { try JSONDecoder().decode([Post].self, from: $0) }
		.observeOn(MainScheduler.instance)

	let refreshEnded = response
		.delay(0.5, scheduler: MainScheduler.instance)
		.toVoid()

	let selected = inputs.select
		.withLatestFrom(posts) { $1[$0.row] }

	let error = response
		.map { $0.error }
		.unwrap()

	return (PostsListOutputs.init(posts: posts, refreshEnded: refreshEnded), signals: PostsListSignals(selectedPost: selected, networkError: error))
}
