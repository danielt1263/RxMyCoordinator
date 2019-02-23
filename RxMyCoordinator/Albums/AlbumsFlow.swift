//
//  AlbumsFlow.swift
//  RxMyCoordinator
//
//  Created by Daniel Tartaglia on 2/23/19.
//

import Foundation
import RxSwift

func albumsFlow(showCollection: @escaping (Album) -> Observable<Photo>, action: Observable<AlbumTableAction>) -> Observable<Result<Photo>> {
	return action
		.map { $0.map { showCollection($0) } }
		.flatMap { flip($0) }
}

func flip(_ input: Result<Observable<Photo>>) -> Observable<Result<Photo>> {
	switch input {
	case .success(let value):
		return value.map { .success($0) }
	case .error(let error):
		return Observable.just(.error(error))
	}
}
