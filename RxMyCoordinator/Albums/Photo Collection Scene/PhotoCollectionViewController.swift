//
//  AlbumCollectionViewController.swift
//  RxMyCoordinator
//
//  Created by Daniel Tartaglia on 2/16/19.
//

import UIKit
import RxSwift
import RxCocoa

class PhotoCollectionViewController: UICollectionViewController {

	var viewModelFactory: (PhotoCollectionInputs) -> PhotoCollectionOutputs = { _ in fatalError("Missing view model factory.") }
	private let bag = DisposeBag()

	override func viewDidLoad() {
        super.viewDidLoad()
		collectionView.dataSource = nil
		collectionView.delegate = nil

		let selected = collectionView.rx.itemSelected.asObservable()
		let viewModel = viewModelFactory(PhotoCollectionInputs(selected: selected))

		viewModel.photos
			.bind(to: collectionView.rx.items(cellIdentifier: "Cell", cellType: PhotoCollectionViewCell.self)) { _, item, cell in
				cell.configure(with: item)
			}
			.disposed(by: bag)
    }
}

struct PhotoCollectionInputs {
	let selected: Observable<IndexPath>
}

struct PhotoCollectionOutputs {
	let photos: Observable<[Photo]>
}
