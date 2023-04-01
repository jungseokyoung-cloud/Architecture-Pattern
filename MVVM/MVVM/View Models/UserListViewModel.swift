//
//  UserListViewModel.swift
//  MVVM
//
//  Created by Seok Young Jung on 2023/03/28.
//

import Foundation
import RxSwift
import RxCocoa

protocol UserListViewModelInput {
    func viewDidLoad() -> Void
}

protocol UserListViewModelOutput {
    var users: Driver<[UserModel]> { get set }
    
    var errorMessage: Driver<Error> { get set }
}

protocol UserListViewModelType {
    
    var dependency: UserFetchableType { get }
    var disposeBag: DisposeBag { get set }
    
    var input: UserListViewModelInput { get }
    var output: UserListViewModelOutput { get }
    
    init(dependency: UserFetchableType)
}

final class UserListViewModel: UserListViewModelInput, UserListViewModelOutput ,UserListViewModelType {
   
    var users: Driver<[UserModel]>
    
    var errorMessage: Driver<Error>
    
    let dependency: UserFetchableType
    var disposeBag: DisposeBag = DisposeBag()
    
    var input: UserListViewModelInput { return self }
    var output: UserListViewModelOutput { return self }
    
    private let users$ = PublishSubject<[UserModel]>()
    private let errorMessage$ = PublishSubject<Error>()
    
    init(dependency: UserFetchableType = UserFectch()) {
        self.dependency = dependency
        
        //streams
        users = users$.asDriver(onErrorJustReturn: [UserModel]())
        errorMessage = errorMessage$.asDriver(onErrorJustReturn:  NetWorkError.unknownError)
     }
    
    func viewDidLoad() {
        dependency.fetchUser()
            .subscribe(
                onNext: { [weak self] in self?.users$.onNext($0) },
                onError: { [weak self] in self?.errorMessage$.onNext($0) }
            )
            .disposed(by: disposeBag)
    }
}
