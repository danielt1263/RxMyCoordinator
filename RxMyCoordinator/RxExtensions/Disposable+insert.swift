//
//  Disposable+insert.swift
//  RxMyCoordinator
//
//  Created by Daniel Tartaglia on 2/22/19.
//

import Foundation
import RxSwift

extension Disposable {
	func insert(into disposable: CompositeDisposable) -> CompositeDisposable.DisposeKey? {
		return disposable.insert(self)
	}
}
