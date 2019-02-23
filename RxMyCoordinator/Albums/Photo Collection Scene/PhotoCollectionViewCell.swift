//
//  PhotoCollectionViewCell.swift
//  RxMyCoordinator
//
//  Created by Daniel Tartaglia on 2/16/19.
//

import UIKit
import RxSwift
import RxCocoa

class PhotoCollectionViewCell: UICollectionViewCell {
	@IBOutlet weak var imageView: UIImageView!
	@IBOutlet weak var titleLabel: UILabel!
	@IBOutlet weak var activityIndicator: UIActivityIndicatorView!

	var bag = DisposeBag()

	override func prepareForReuse() {
		bag = DisposeBag()
		super.prepareForReuse()
	}

	func configure(with photo: Photo) {
		titleLabel.text = photo.title
		let viewModel = photoDetailViewModel(photoURL: photo.thumbnailUrl)

		viewModel.image
			.bind(to: imageView.rx.image)
			.disposed(by: bag)

		viewModel.activity
			.bind(to: activityIndicator.rx.isAnimating)
			.disposed(by: bag)
	}
}
