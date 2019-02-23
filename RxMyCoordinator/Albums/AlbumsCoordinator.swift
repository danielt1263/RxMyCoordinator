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

	func showPhotoCollection(with album: Album) -> Observable<Photo> {
		let controller = UIStoryboard(name: "PhotoCollection", bundle: nil)
			.instantiateInitialViewController() as! PhotoCollectionViewController
		root.showDetailViewController(controller, sender: nil)
		return controller.installOutputViewModel(outputFactory: photoCollectionViewModel(id: album.id, dataTask: dataTask(with:)))
	}

	_ = albumsFlow(showCollection: showPhotoCollection(with:), action: tableAction)
		.subscribe(onNext: { result in
			switch result {
			case .success(let photo):
				root.showPhotoDetail(with: photo)
			case .error(let error):
				displayAlert(title: "Error", message: error.localizedDescription)
			}
		})
}

extension AlbumTableViewController: HasViewModel { }

extension UIViewController {
	func showPhotoDetail(with photo: Photo) {
		let controller = PhotoDetailViewController()
		controller.photo = photo
		self.showDetailViewController(controller, sender: nil)
	}
}

func displayAlert(title: String?, message: String?) {
	let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
	alert.addAction(UIAlertAction(title: "OK", style: .default))
	topViewController().present(alert, animated: true)
}

extension PhotoCollectionViewController: HasViewModel { }
