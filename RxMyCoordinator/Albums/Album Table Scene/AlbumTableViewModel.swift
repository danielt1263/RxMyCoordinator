//
//  AlbumTableViewModel.swift
//  RxMyCoordinator
//
//  Created by Daniel Tartaglia on 2/16/19.
//

import Foundation
import RxSwift

typealias AlbumTableAction = Result<Album>

func albumTableViewModel(dataTask: @escaping (URLRequest) -> Observable<Result<Data>>) -> (_ inputs: AlbumTableInputs) -> (outputs: AlbumTableOutputs, action: Observable<AlbumTableAction>) {
	return { inputs in
		let load = Observable.merge(inputs.viewWillAppear, inputs.refresh)
		let response = load
			.map { URLRequest.getAlbums }
			.flatMapLatest { dataTask($0) }
			.share(replay: 1)

		let albums = response
			.map { $0.success }
			.unwrap()
			.map { try JSONDecoder().decode([Album].self, from: $0) }

		let refreshEnded = response
			.delay(.milliseconds(500), scheduler: MainScheduler.instance)
			.asVoid()

		let selected = inputs.select
			.withLatestFrom(albums) { $1[$0.row] }
			.map { AlbumTableAction.success($0) }

		let error = response
			.map { $0.error }
			.unwrap()
			.map { AlbumTableAction.error($0) }

		let action = Observable.merge(selected, error)

		return (AlbumTableOutputs(albums: albums, refreshEnded: refreshEnded), action)
	}
}
