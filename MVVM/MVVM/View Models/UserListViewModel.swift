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
    func viewWillAppear() -> Void
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
    
    private let users$ = BehaviorSubject<[UserModel]>(value: [UserModel]())
    private let errorMessage$ = PublishSubject<Error>()
    
    init(dependency: UserFetchableType = UserFectch()) {
        self.dependency = dependency
        //stream
        
        users = users$.asDriver(onErrorJustReturn: [UserModel]())
        errorMessage = errorMessage$.asDriver(onErrorJustReturn:  NetWorkError.unknownError)
     }
    
    func viewWillAppear() {
        dependency.fetchUser()
            .do(onError: errorMessage$.onNext)
            .subscribe(onNext : users$.onNext)
            .disposed(by: disposeBag)
    }
}
