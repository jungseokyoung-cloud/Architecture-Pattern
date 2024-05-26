//
//  HomeViewModel.swift
//  CoordinatorPattern
//
//  Created by jung on 5/25/24.
//

import RxCocoa
import RxSwift

protocol HomeCoordinatable: AnyObject {
	func didSelectItem(id: Int)
}

protocol HomeViewModelType: AnyObject, HomeViewModelable {
	associatedtype Input
	associatedtype Output
	
	var disposeBag: DisposeBag { get }
	var coordinator: HomeCoordinatable? { get set }
}

final class HomeViewModel: HomeViewModelType {
	let disposeBag = DisposeBag()
	private let useCase: HomeUseCase
	private let postsRelay = BehaviorRelay<[Post]>(value: [])
	
	weak var coordinator: HomeCoordinatable?
		
	// MARK: - Input
	struct Input { 
		var viewDidLoad: PublishRelay<Void>
		var didTapItemAt: Signal<Int>
	}
	
	// MARK: - Output
	struct Output { 
		var posts: Driver<[Post]>
	}
	
	// MARK: - Initializers
	init(useCase: HomeUseCase) {
		self.useCase = useCase
	}

	
	func transform(input: Input) -> Output {
		input.viewDidLoad
			.bind(with: self) { owner, _ in
				owner.fetchPosts()
			}
			.disposed(by: disposeBag)
			
		input.didTapItemAt
			.emit(with: self) { owner, id in
				owner.coordinator?.didSelectItem(id: id)
			}
			.disposed(by: disposeBag)
		
		return Output(
			posts: postsRelay.asDriver())
	}
}

// MARK: - Private Methods
private extension HomeViewModel {
	func fetchPosts() {
		useCase.fetchPosts()
			.subscribe(with: self) { owner, posts in
				owner.postsRelay.accept(posts)
			}
			.disposed(by: disposeBag)
	}
}
