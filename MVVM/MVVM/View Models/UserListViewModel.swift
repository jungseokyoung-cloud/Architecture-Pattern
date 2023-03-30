//
//  UserListViewModel.swift
//  MVVM
//
//  Created by Seok Young Jung on 2023/03/28.
//

import Foundation
import RxSwift
import RxCocoa

final class UserListViewModel: ViewModelType {
    
    typealias Dependency = UserFetchableType
    
    struct Output {
        var users: Driver<[UserModel]>
        
        var errorMessage: Observable<Error>
    }
    
    let dependency: Dependency
    var disposeBag: DisposeBag = DisposeBag()
    
    let output: Output
    
    init(dependency: Dependency = UserFectch()) {
        self.dependency = dependency
        //streams
        let fetchUsers = PublishSubject<[UserModel]>()
        let errorMessage = PublishSubject<Error>()
        
        dependency.fetchUser()

            .do(onError: { errorMessage.onNext($0) })
            .subscribe(onNext: { fetchUsers.onNext($0) })
            .disposed(by: disposeBag)
                
                
        //Input & Output
        let users = fetchUsers.asDriver(onErrorJustReturn: [UserModel]())
        self.output = Output(users: users, errorMessage: errorMessage.asObservable())
                
     }
}
