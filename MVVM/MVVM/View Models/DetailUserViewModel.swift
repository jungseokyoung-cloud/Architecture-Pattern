//
//  DetailUserViewModel.swift
//  MVVM
//
//  Created by Seok Young Jung on 2023/03/30.
//

import Foundation
import RxSwift
import RxCocoa

final class DetailUserViewModel: ViewModelType {
    typealias Dependency = UserModel
    
    struct Output {
        var username: Driver<String>
        var email: Driver<String>
        var address: Driver<String>
        var phoneNumber: Driver<String>
        var website: Driver<String>
    }
    
    let dependency: Dependency
    var disposeBag: DisposeBag = DisposeBag()
    
    let output: Output
    
    private let username$: PublishSubject<String>
    private let email$: PublishSubject<String>
    private let address$: PublishSubject<String>
    private let phoneNumber$: PublishSubject<String>
    private let website$: PublishSubject<String>
    
    
    init(dependency: UserModel) {
        self.dependency = dependency
        
        //Stream ??? Observable Stream
        username$ = PublishSubject<String>()
        email$ = PublishSubject<String>()
        address$ = PublishSubject<String>()
        phoneNumber$ = PublishSubject<String>()
        website$ = PublishSubject<String>()
        
        var username = username$.asDriver(onErrorJustReturn: "")
        var email = email$.asDriver(onErrorJustReturn: "")
        var address = address$.asDriver(onErrorJustReturn: "")
        var phoneNumber = phoneNumber$.asDriver(onErrorJustReturn: "")
        var website = website$.asDriver(onErrorJustReturn: "")
        
        self.output = Output(username: username, email: email, address: address, phoneNumber: phoneNumber, website: website)
    }
    private func emitData() {
        username$.onNext(dependency.username)
        
        email$.onNext(dependency.email)
        address$.onNext(dependency.email)
        phoneNumber$.onNext(dependency.email)
        website$.onNext(dependency.email)
    }
}
