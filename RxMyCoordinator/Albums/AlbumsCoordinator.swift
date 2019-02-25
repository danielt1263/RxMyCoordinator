//
//  AlbumCoordinator.swift
//  RxMyCoordinator
//
//  Created by Daniel Tartaglia on 2/17/19.
//

import UIKit
import RxSwift
import RxCocoa

func albumsCoordinator(root: UINavigationController) {
	let albumTable = root.topViewController as! AlbumTableViewController
	let tableAction = albumTable.installOutputViewModel(outputFactory: albumTableViewModel(dataTask: dataTask(with:)))
		.share(replay: 1)

	_ = albumsFlow(showCollection: showDetailPhotoCollection(with:), action: tableAction)
		.subscribe(onNext: { result in
			switch result {
			case .success(let photo):
				showDetailPhotoDetail(with: photo)
			case .error(let error):
				presentAlert(title: "Error", message: error.localizedDescription)
			}
		})
}

extension AlbumTableViewController: HasViewModel { }

func showDetailPhotoCollection(with album: Album) -> Observable<Photo> {
	let controller = UIStoryboard(name: "PhotoCollection", bundle: nil)
		.instantiateInitialViewController() as! PhotoCollectionViewController
	UIViewController.top().showDetailViewController(controller, sender: nil)
	return controller.installOutputViewModel(outputFactory: photoCollectionViewModel(id: album.id, dataTask: dataTask(with:)))
}

func showDetailPhotoDetail(with photo: Photo) {
	let controller = PhotoDetailViewController()
	controller.photo = photo
	UIViewController.top().showDetailViewController(controller, sender: nil)
}

extension PhotoCollectionViewController: HasViewModel { }
