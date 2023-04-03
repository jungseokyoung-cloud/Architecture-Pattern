//
//  UsersListTableViewController.swift
//  MVVM
//
//  Created by Seok Young Jung on 2023/03/28.
//

import UIKit
import RxCocoa
import RxSwift

final class UserListViewController: UIViewController {
    @IBOutlet weak var tableView: UITableView!
    
    private var userListViewModel: UserListViewModelType
    private var disposBag = DisposeBag()
    
    init(userListViewModel: UserListViewModelType = UserListViewModel()) {
        self.userListViewModel = userListViewModel
        super.init(nibName: nil, bundle: nil)
        viewWillAppearBind()
    }
    
    required init?(coder: NSCoder) {
        self.userListViewModel = UserListViewModel()
        super.init(coder: coder)
        viewWillAppearBind()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        bind()
    }
}

extension UserListViewController {
    
    private func viewWillAppearBind() {
        
        self.rx.viewWillAppear
            .subscribe(onNext: { [weak self] _ in
                self?.userListViewModel.input.viewWillAppear()
            })
            .disposed(by: disposBag)
    }
    
    private func bind() {

        userListViewModel.output.users.drive(tableView.rx.items(cellIdentifier: Constants.Identifier.userListCell)) { [weak self] index, item, cell in
            cell.contentConfiguration = self?.contentForCell(cell, item: item)
        }
        .disposed(by: disposBag)
                
        tableView.rx.modelSelected(UserModel.self)
            .subscribe(onNext: { [weak self] model in
                self?.navigateViewControllerForModel(model)
            })
            .disposed(by: disposBag)
        
        userListViewModel.output.errorMessage
            .map{ "\($0)" }
            .drive(onNext: (createAlert))
            .disposed(by: disposBag)
        
    }
}

extension UserListViewController {
    
    private func navigateViewControllerForModel(_ model: UserModel) {
        let storyBoard = UIStoryboard(name: "Main", bundle: Bundle.main)
        
        let vc = storyBoard.instantiateViewController(identifier: Constants.Identifier.detailUserVC, creator: { coder in
            let viewModel = DetailUserViewModel(seletecUser: model)
            let vc = DetailUserViewController(viewModel: viewModel, coder: coder)
            return vc
        }) 
                
        vc.modalPresentationStyle = .fullScreen

        navigationController?.pushViewController(vc, animated: true)
    }
}

extension UserListViewController {
    private func contentForCell(_ cell: UITableViewCell, item: UserModel) -> UIListContentConfiguration {
        
        var content = cell.defaultContentConfiguration()
        
        content.text = item.username
        content.secondaryText = item.email
        
        return content
    }
}
