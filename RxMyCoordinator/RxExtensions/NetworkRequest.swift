//
//  NetworkRequest.swift
//  RxEarthquake
//
//  Created by Daniel Tartaglia on 9/8/18.
//  Copyright © 2018 Daniel Tartaglia. MIT License.
//

import Foundation
import RxSwift
import RxCocoa

let isNetworkActive: Driver<Bool> = {
	return networkActivity.asDriver()
}()

func dataTask(with request: URLRequest) -> Observable<Result<Data>> {
	return URLSession.shared.rx.data(request: request)
		.materialize()
		.filter { $0.isCompleted == false }
		.map { $0.asResult }
		.trackActivity(networkActivity)
}

extension Event {
	var asResult: Result<Element> {
		switch self {
		case .next(let element):
			return .success(element)
		case .error(let error):
			return .error(error)
		case .completed:
			fatalError("Be sure to filter out completed events")
		}
	}
}

private
let networkActivity = ActivityIndicator()
