//
//  PhotoDetailViewController.swift
//  RxMyCoordinator
//
//  Created by Daniel Tartaglia on 2/17/19.
//

import UIKit
import RxSwift
import RxCocoa

class PhotoDetailViewController: UIViewController {

	@IBOutlet weak var imageView: UIImageView!
	@IBOutlet weak var activityIndicatorView: UIActivityIndicatorView!
	let bag = DisposeBag()

	var photo: Photo!

	override func viewDidLoad() {
		super.viewDidLoad()
		
		title = photo.title

		let viewModel = photoDetailViewModel(photoURL: photo.url)

		viewModel.image
			.bind(to: imageView.rx.image)
			.disposed(by: bag)

		viewModel.activity
			.bind(to: activityIndicatorView.rx.isAnimating)
			.disposed(by: bag)
	}
}

struct PhotoDetailOutputs {
	let image: Observable<UIImage>
	let activity: Observable<Bool>
}
