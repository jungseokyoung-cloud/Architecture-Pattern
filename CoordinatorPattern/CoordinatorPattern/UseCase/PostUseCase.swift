//
//  PostUseCase.swift
//  CoordinatorPattern
//
//  Created by jung on 5/26/24.
//

import RxSwift

struct PostUseCase {
	private let repository = PostRepository()
	
	func fetchPost(id: Int) -> Single<Post> {
		return repository.fetchPost(id: id)
	}
}
