//
//  HomeUseCase.swift
//  CoordinatorPattern
//
//  Created by jung on 5/26/24.
//

import RxSwift

struct HomeUseCase {
	private let repository = PostRepository()
	
	func fetchPosts() -> Single<[Post]> {
		return repository.fetchPosts()
	}
}
