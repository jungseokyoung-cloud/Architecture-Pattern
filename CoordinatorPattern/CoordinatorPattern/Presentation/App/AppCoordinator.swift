//
//  AppCoordinator.swift
//  CoordinatorPattern
//
//  Created by jung on 5/25/24.
//

import UIKit

protocol AppViewModelable { }

final class AppCoordinator: Coordinator {
	private let homeContainable: HomeContainable
	private var homeCoordinator: Coordinating?
	
	private let postContainable: PostContainable
	private var postCoordinator: Coordinating?
	
	init(
		homeContainable: HomeContainable,
		postContainable: PostContainable
	) {
		self.homeContainable = homeContainable
		self.postContainable = postContainable
		super.init()
	}
	
	override func start(at navigationController: UINavigationController?) {
		super.start(at: navigationController)
		
		attachHomeCoordinator()
	}
	
	func attachHomeCoordinator() {
		guard homeCoordinator == nil else { return }
		
		let coordinator = homeContainable.coordinator(listener: self)
		
		self.addChild(coordinator)
		coordinator.start(at: navigationController)
		
		self.homeCoordinator = coordinator
	}
	
	func detachHomeCoordinator() {
		guard let coordinator = homeCoordinator else { return }
		
		self.removeChild(coordinator)
		navigationController?.popViewController(animated: false)
		
		self.homeCoordinator = nil
	}
	
	func attachPostCoordinator(postId: Int) {
		guard postCoordinator == nil else { return }
		
		let coordinator = postContainable.coordinator(listener: self, postId: postId)
		
		self.addChild(coordinator)
		coordinator.start(at: navigationController)
		
		self.postCoordinator = coordinator
	}
	
	func detachPostCoordinator() {
		guard let coordinator = postCoordinator else { return }
		
		self.removeChild(coordinator)
		
		self.postCoordinator = nil
	}
}

extension AppCoordinator: HomeListener {
	func homeDidSelectItem(id: Int) {
		attachPostCoordinator(postId: id)
	}
}

extension AppCoordinator: PostListener {
	func postDidTapBackButton() {

		detachPostCoordinator()
	}
}
