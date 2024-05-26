//
//  PostViewModel.swift
//  CoordinatorPattern
//
//  Created by jung on 5/26/24.
//

import RxCocoa
import RxSwift

protocol PostCoordinatable: AnyObject {
	func didTapBackButton()
}

protocol PostViewModelType: PostViewModelable {
	associatedtype Input
	associatedtype Output
	
	var disposeBag: DisposeBag { get }
	var coordinator: PostCoordinatable? { get set }
}

final class PostViewModel: PostViewModelType {
	let disposeBag = DisposeBag()
	private let useCase: PostUseCase
	private let postId: Int
	
	private let postRelay = BehaviorRelay(value: Post(userId: 1, id: 1, title: "", body: ""))
	
	weak var coordinator: PostCoordinatable?
	
	// MARK: - Input
	struct Input {
		var viewDidLoad: PublishRelay<Void>
		var didTapBackButton: ControlEvent<Void>
	}
	
	// MARK: - Output
	struct Output {
		var title: Driver<String>
		var content: Driver<String>
	}
	
	// MARK: - Initializers
	init(useCase: PostUseCase, postId: Int) {
		self.useCase = useCase
		self.postId = postId
	}
	
	
	func transform(input: Input) -> Output {
		input.viewDidLoad
			.subscribe(with: self) { owner, _ in
				owner.fetchPost()
			}
			.disposed(by: disposeBag)
		
		input.didTapBackButton
			.bind(with: self) { owner, _ in
				owner.coordinator?.didTapBackButton()
			}
			.disposed(by: disposeBag)

		return Output(
			title: postRelay.asDriver().map { $0.title },
			content: postRelay.asDriver().map { $0.body }
			)
	}
}

// MARK: - Private Methods
private extension PostViewModel {
	func fetchPost() {
		useCase.fetchPost(id: postId)
			.subscribe(with: self) { owner, post in
				owner.postRelay.accept(post)
			}
			.disposed(by: disposeBag)
	}
}
