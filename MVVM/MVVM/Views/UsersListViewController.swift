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
        bind()
    }
    
    required init?(coder: NSCoder) {
        self.userListViewModel = UserListViewModel()
        super.init(coder: coder)
        bind()
    }
}

extension UserListViewController {
    private func bind() {
        bindInputs()
        bindOutputs()
    }
    
    private func bindInputs() {
        self.rx.viewDidLoad
            .bind(onNext: { [weak self] in
                self?.userListViewModel.input.viewDidLoad()
                self?.setUpTableView()
            })
            .disposed(by: disposBag)
    }
    
    private func bindOutputs() {
        
        userListViewModel.output.errorMessage
            .map{ "\($0)" }
            .drive(onNext: (createAlert))
            .disposed(by: disposBag)
    }
}

extension UserListViewController {
    
    private func setUpTableView() {
        userListViewModel.output.users.drive(tableView.rx.items(cellIdentifier: Constants.Identifier.userListCell)) { [weak self] index, item, cell in
            
            cell.contentConfiguration = self?.contentForCell(cell, item: item)
        }
        .disposed(by: disposBag)
                
        tableView.rx.modelSelected(UserModel.self)
            .subscribe(onNext: { [weak self] model in
                self?.navigateViewControllerForModel(model)
            })
            .disposed(by: disposBag)
    }
    
    private func navigateViewControllerForModel(_ model: UserModel) {
        let storyBoard = UIStoryboard(name: "Main", bundle: Bundle.main)
        
        guard let vc = storyBoard.instantiateViewController(withIdentifier: Constants.Identifier.detailUserVC) as? DetailUserViewController else { return }
        
        vc.detaileUserViewModel = DetailUserViewModel(seletecUser: model)
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
