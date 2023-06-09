//
//  WebService.swift
//  MVVM
//
//  Created by Seok Young Jung on 2023/03/28.
//

import Foundation
import RxSwift

enum NetWorkError: Error {
    case urlError
    case decodeError
    case fetchError
    case unknownError
    case unknownUserError
}

final class WebService {
    static func weatherDataToRx() -> Single<Data> {
        return Single.create { emitter in
            
            guard let url = URL(string: Constants.urlString) else {
                emitter(.failure(NetWorkError.urlError))
                return Disposables.create()
            }
            
            let task = URLSession.shared.dataTask(with: url) { data, _, err in
                if let err = err {
                    emitter(.failure(err))
                    return
                }
                
                guard let data = data else {
                    emitter(.failure(NetWorkError.fetchError))
                    return
                }
                
                emitter(.success(data))
            }
            task.resume()
            
            return Disposables.create { task.cancel() }
        }
    }
}
