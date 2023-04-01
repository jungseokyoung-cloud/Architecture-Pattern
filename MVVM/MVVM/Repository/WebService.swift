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
    
    static func weatherDataToRx() -> Observable<Data> {
        
        return Observable.create { emitter in
            
            guard let url = URL(string: Constants.urlString) else {
                emitter.onError(NetWorkError.urlError)
                return Disposables.create()
            }
            
            let task = URLSession.shared.dataTask(with: url) { data, _, error in
                if let error = error {
                    emitter.onError(error)
                    return
                }
                
                guard let data = data else {
                    emitter.onError(NetWorkError.fetchError)
                    return
                }
                emitter.onNext(data)
                emitter.onCompleted()
            }
            task.resume()
            
            return Disposables.create { task.cancel() }
        }
    }
}
