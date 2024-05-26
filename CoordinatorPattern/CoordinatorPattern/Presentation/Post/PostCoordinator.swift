//
//  PostCoordinator.swift
//  CoordinatorPattern
//
//  Created by jung on 5/26/24.
//

import UIKit

protocol PostViewModelable { }

protocol PostListener: AnyObject {
	func postDidTapBackButton()
}

final class PostCoordinator: Coordinator, PostCoordinatable {
weak var listener: PostListener?
	
	private let viewController: PostViewController
	private let viewModel: PostViewModel
	
	init(viewModel: PostViewModel) {
		self.viewModel = viewModel
		self.viewController = PostViewController(viewModel: viewModel)
		super.init()
		viewModel.coordinator = self
	}
	
	override func start(at navigationController: UINavigationController?) {
		super.start(at: navigationController)
		navigationController?.pushViewController(viewController, animated: true)
	}
	
	func didTapBackButton() {
		listener?.postDidTapBackButton()
	}
}
