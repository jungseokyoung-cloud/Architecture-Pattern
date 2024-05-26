//
//  HomeViewController.swift
//  CoordinatorPattern
//
//  Created by jung on 5/25/24.
//

import UIKit
import SnapKit
import RxCocoa
import RxSwift

final class HomeViewController: UIViewController {
	private let viewModel: HomeViewModel
	private let disposebag = DisposeBag()
	private let viewDidLoadRelay = PublishRelay<Void>()
	
	// MARK: - UI Components
	private let tableView: UITableView = {
		let tableView = UITableView()
		tableView.register(UITableViewCell.self, forCellReuseIdentifier: "Cell")
		
		return tableView
	}()
	
	// MARK: - Initalizers
	init(viewModel: HomeViewModel) {
		self.viewModel = viewModel
		super.init(nibName: nil, bundle: nil)
	}
	
	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	override func viewDidLoad() {
		super.viewDidLoad()
		setupUI()
		bind()
		
		self.viewDidLoadRelay.accept(())
	}
	
	private func setupUI() {
		view.addSubview(tableView)
		tableView.snp.makeConstraints { $0.edges.equalToSuperview() }
	}
	
	private func bind() {
		let input = HomeViewModel.Input(
			viewDidLoad: viewDidLoadRelay,
			didTapItemAt: tableView.rx.modelSelected(Post.self).map { $0.id }.asSignal(onErrorJustReturn: 0)
		)
		
		let output = viewModel.transform(input: input)
		
		output.posts.drive(
			tableView.rx.items(cellIdentifier: "Cell")
		) { [weak self] index, item, cell in
			cell.contentConfiguration = self?.contentForCell(cell, item: item)
		}
		.disposed(by: disposebag)
	}
	
	private func contentForCell(_ cell: UITableViewCell, item: Post) -> UIListContentConfiguration {
		
		var content = cell.defaultContentConfiguration()
		
		content.text = item.title
		content.secondaryText = item.body
		
		return content
	}
}
