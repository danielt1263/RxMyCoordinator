//
//  PhotoCollectionViewModel.swift
//  RxMyCoordinator
//
//  Created by Daniel Tartaglia on 2/16/19.
//

import Foundation
import RxSwift

func photoCollectionViewModel(id: Int, dataTask: @escaping (URLRequest) -> Observable<Result<Data>>) -> (_ inputs: PhotoCollectionInputs) -> (outputs: PhotoCollectionOutputs, action: Observable<Photo>) {
	return { inputs in
		let response = Observable.just(id)
			.map { URLRequest.getPhotos(forAlbumId: $0) }
			.flatMapLatest { dataTask($0) }
			.share(replay: 1)

		let photos = response
			.map { $0.success }
			.unwrap()
			.map { try JSONDecoder().decode([Photo].self, from: $0) }

		let action = inputs.selected
			.withLatestFrom(photos) { $1[$0.item] }

		return (PhotoCollectionOutputs(photos: photos), action)
	}
}
