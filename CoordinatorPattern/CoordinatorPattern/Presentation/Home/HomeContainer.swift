//
//  HomeContainer.swift
//  CoordinatorPattern
//
//  Created by jung on 5/25/24.
//

protocol HomeDependency: Dependency {
	var homeUseCase: HomeUseCase { get }
}

protocol HomeContainable: Containable {
	func coordinator(listener: HomeListener) -> Coordinating
}

final class HomeContainer: Container<HomeDependency>, HomeContainable {
	var useCase: HomeUseCase { dependency.homeUseCase }
	
	func coordinator(listener: HomeListener) -> Coordinating {
		let viewModel = HomeViewModel(useCase: useCase)
		
		let coordinator = HomeCoordinator(viewModel: viewModel)
		coordinator.listener = listener
		return coordinator
	}
}
