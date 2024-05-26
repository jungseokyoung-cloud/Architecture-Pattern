//
//  HomeCoordinator.swift
//  CoordinatorPattern
//
//  Created by jung on 5/25/24.
//

import UIKit

protocol HomeViewModelable { }

protocol HomeListener: AnyObject {
	func homeDidSelectItem(id: Int)
}

final class HomeCoordinator: Coordinator, HomeCoordinatable {
	weak var listener: HomeListener?
	
	private let viewController: HomeViewController
	private let viewModel: HomeViewModel
	
	init(viewModel: HomeViewModel) {
		self.viewModel = viewModel
		self.viewController = HomeViewController(viewModel: viewModel)
		super.init()
		viewModel.coordinator = self
	}
	
	override func start(at navigationController: UINavigationController?) {
		super.start(at: navigationController)
		navigationController?.pushViewController(viewController, animated: true)
	}
	
	func didSelectItem(id: Int) {
		listener?.homeDidSelectItem(id: id)
	}
}
