//
//  DetailUserViewModel.swift
//  MVVM
//
//  Created by Seok Young Jung on 2023/03/30.
//

import Foundation
import RxSwift
import RxCocoa

protocol DetailUserViewModelInput {
    func viewWillAppear() -> Void
}

protocol DetailUserViewModelOutput {
    var username: Driver<String> { get set }
    var email: Driver<String> { get set }
    var address: Driver<String> { get set }
    var phoneNumber: Driver<String> { get set }
    var website: Driver<String> { get set }
    
    var errorMessage: Driver<Error> { get set }
}

protocol DetailUserViewModelType {
    
    var seletecUser: UserModel { get }
    var disposeBag: DisposeBag { get set }
    
    var input: DetailUserViewModelInput { get }
    var output: DetailUserViewModelOutput { get }
    
    init(seletecUser: UserModel)
}


final class DetailUserViewModel: DetailUserViewModelInput, DetailUserViewModelOutput, DetailUserViewModelType {
    
    var username: Driver<String>
    var email: Driver<String>
    var address: Driver<String>
    var phoneNumber: Driver<String>
    var website: Driver<String>
    var errorMessage: Driver<Error>
    
    let seletecUser: UserModel
    
    var disposeBag: DisposeBag = DisposeBag()
    
    var input: DetailUserViewModelInput { return self }
    var output: DetailUserViewModelOutput { return self }
    
    private let stream = BehaviorSubject<UserModel>(value: UserModel())
    private let errorMessage$ = PublishSubject<Error>()
    
    init(seletecUser: UserModel = UserModel()) {
        self.seletecUser = seletecUser
        
        username = stream.map { $0.username }.asDriver(onErrorJustReturn: "")
        email = stream.map { $0.email }.asDriver(onErrorJustReturn: "")
        address = stream.map { $0.address.city }.asDriver(onErrorJustReturn: "")
        phoneNumber = stream.map { $0.phone }.asDriver(onErrorJustReturn: "")
        website = stream.map { $0.website }.asDriver(onErrorJustReturn: "")
        
        errorMessage = errorMessage$.asDriver(onErrorJustReturn: NetWorkError.unknownError)
    }
    
    func viewWillAppear() {
        
        if(seletecUser.isDummy()) {
            errorMessage$.onNext(NetWorkError.unknownUserError)
        }
        else {
            stream.onNext(seletecUser)
        }
    }
}
