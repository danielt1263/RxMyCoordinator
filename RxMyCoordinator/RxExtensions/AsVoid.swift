//
//  RxToVoid.swift
//  RxMyCoordinator
//
//  Created by Daniel Tartaglia on 2/15/19.
//

import Foundation
import RxSwift

extension ObservableConvertibleType {

	func asVoid() -> Observable<Void> {
		return asObservable().map { _ in }
	}
}
