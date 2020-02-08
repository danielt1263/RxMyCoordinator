//
//  PhotoDetailViewModel.swift
//  RxMyCoordinator
//
//  Created by Daniel Tartaglia on 2/17/19.
//

import UIKit

func photoDetailViewModel(photoURL: URL) -> PhotoDetailOutputs {
	let result = dataTask(with: URLRequest(url: photoURL))
		.share(replay: 1)

	let image = result
		.map { $0.map { UIImage(data: $0) ?? #imageLiteral(resourceName: "EmptyViewBackground") } }
		.compactMap { $0.catchErrorJustReturn(#imageLiteral(resourceName: "EmptyViewBackground")) }

	let activity = result
		.map { _ in false }
		.startWith(true)
		.distinctUntilChanged()

	return PhotoDetailOutputs(image: image, activity: activity)
}
