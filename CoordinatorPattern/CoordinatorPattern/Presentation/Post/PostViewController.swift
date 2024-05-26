//
//  PostViewController.swift
//  CoordinatorPattern
//
//  Created by jung on 5/26/24.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa

final class PostViewController: UIViewController {
	private let viewModel: PostViewModel
	private let disposeBag = DisposeBag()
	
	private let viewDidLoadRelay = PublishRelay<Void>()
	private let didTapBackButton = PublishRelay<Void>()
	
	// MARK: - UI Components
	private let titleLabel: UILabel = {
		let label = UILabel()
		label.font = .boldSystemFont(ofSize: 15)
		label.numberOfLines = 0

		return label
	}()
	
	private let contentLabel: UILabel = {
		let label = UILabel()
		label.font = .systemFont(ofSize: 12)
		label.numberOfLines = 0

		return label
	}()
	
	// MARK: - Initailizers
	init(viewModel: PostViewModel) {
		self.viewModel = viewModel
		super.init(nibName: nil, bundle: nil)
	}
	
	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	// MARK: - Lift Cycles
	override func viewDidLoad() {
		super.viewDidLoad()
		
		setupUI()
		bind()
		viewDidLoadRelay.accept(())
	}
	
	override func viewWillDisappear(_ animated: Bool) {
		super.viewWillDisappear(animated)
		
		if self.isMovingFromParent {
			didTapBackButton.accept(())
		}
	}
}

// MARK: - UI Methods
private extension PostViewController {
	func setupUI() {
		view.backgroundColor = .white
		setViewHeirarchy()
		setConstraints()
	}
	
	func setViewHeirarchy() { 
		self.view.addSubview(titleLabel)
		self.view.addSubview(contentLabel)
	}
	
	func setConstraints() { 
		titleLabel.snp.makeConstraints {
			$0.leading.trailing.equalToSuperview().inset(30)
			$0.top.equalToSuperview().offset(150)
		}
		
		contentLabel.snp.makeConstraints {
			$0.leading.trailing.equalToSuperview().inset(30)
			$0.top.equalTo(titleLabel.snp.bottom).offset(40)
		}
	}
}

// MARK: - Bind Methods
private extension PostViewController {
	func bind() {
		let input = PostViewModel.Input(
			viewDidLoad: viewDidLoadRelay,
			didTapBackButton: .init(events: didTapBackButton)
		)
		
		let output = viewModel.transform(input: input)
		
		output.title
			.drive(titleLabel.rx.text)
			.disposed(by: disposeBag)
		
		output.content
			.drive(contentLabel.rx.text)
			.disposed(by: disposeBag)
	}
}
