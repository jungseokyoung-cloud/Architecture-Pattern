//
//  AppContainer.swift
//  CoordinatorPattern
//
//  Created by jung on 5/25/24.
//

final class AppDependency: Dependency { }

final class AppContainer:
	Container<AppDependency>,
	HomeDependency,
	PostDependency {
	var postUseCase: PostUseCase {
		PostUseCase()
	}
	
	var homeUseCase: HomeUseCase {
		HomeUseCase()
	}

	func coordinator() -> Coordinating {
		let homeContainable = HomeContainer(dependency: self)
		let postContainable = PostContainer(dependency: self)
		
		let coordinator = AppCoordinator(
			homeContainable: homeContainable,
			postContainable: postContainable
		)
		return coordinator
	}
}

