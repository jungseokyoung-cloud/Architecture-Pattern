//
//  UserFetch.swift
//  MVVM
//
//  Created by Seok Young Jung on 2023/03/28.
//

import Foundation
import RxSwift

protocol UserFetchableType {
    func fetchUser() -> Observable<[UserModel]>
}

class UserFectch: UserFetchableType {
    
    func fetchUser() -> Observable<[UserModel]> {
        return WebService.weatherDataToRx()
            .map { data in
                guard let result = try? JSONDecoder().decode([UserModel].self, from: data) else {
                    fatalError("\(NetWorkError.fetchError)")  }
                print(result)
                return result
            }
    }
}
