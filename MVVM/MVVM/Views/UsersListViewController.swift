//
//  UsersListTableViewController.swift
//  MVVM
//
//  Created by Seok Young Jung on 2023/03/28.
//

import Foundation
import UIKit
import RxCocoa
import RxSwift

class UserListViewController: UIViewController {
    private var userListViewModel = UserListViewModel()
    private let cellIdentifier = "UserListCell"
    private let disposBag = DisposeBag()
    @IBOutlet weak var tableView: UITableView!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        bind()
        navigate()
    }
    
    private func bind() {
        
        userListViewModel.output.users.drive(tableView.rx.items(cellIdentifier: cellIdentifier)) { [weak self] index, item, cell in
            
            cell.contentConfiguration = self?.contentForCell(cell, item: item)
        }
        .disposed(by: disposBag)
        
        userListViewModel.output.errorMessage
            .subscribe(onNext: { [weak self] message in
                self?.createAlert(message: "\(message)")
            })
            .disposed(by: disposBag)
    }
}

extension UserListViewController {
    private func navigate() {
        tableView.rx.itemSelected
            .subscribe(onNext: {print("\($0)selected")})
        
        tableView.rx.modelSelected(UserModel.self)
            .subscribe(onNext: {print("\($0.id)")})
    }
}

extension UserListViewController {
    private func contentForCell(_ cell: UITableViewCell, item: UserModel) -> UIListContentConfiguration {
        var content = cell.defaultContentConfiguration()
        
        content.text = item.username
        content.secondaryText = item.email
        
        return content
    }
    
    private func createAlert(message: String) {
        let alert = UIAlertController(title: "에러", message: message, preferredStyle: .alert)
        
        let okAction = UIAlertAction(title: "확인", style: .default) { _ in print("오키")}
        
        alert.addAction(okAction)
        
        present(alert, animated: true)
    }
}
