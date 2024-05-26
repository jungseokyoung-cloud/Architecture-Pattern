//
//  PostContainer.swift
//  CoordinatorPattern
//
//  Created by jung on 5/26/24.
//

protocol PostDependency: Dependency {
	var postUseCase: PostUseCase { get }
}

protocol PostContainable: Containable {
	func coordinator(listener: PostListener, postId: Int) -> Coordinating
}

final class PostContainer: Container<PostDependency>, PostContainable {
	var useCase: PostUseCase { dependency.postUseCase }
	
	func coordinator(listener: PostListener, postId: Int) -> Coordinating {
		let viewModel = PostViewModel(useCase: useCase, postId: postId)
		
		let coordinator = PostCoordinator(viewModel: viewModel)
		coordinator.listener = listener
		return coordinator
	}
}
