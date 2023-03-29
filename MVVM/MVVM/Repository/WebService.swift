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
    case domainError
    case fetchError
}

let urlString = "https://jsonplaceholder.typicode.com/users"

final class WebService {
    
    
    static func weatherDataToRx() -> Observable<Data> {
        
        return Observable.create { emitter in
            
            fetchWeatherData { result in

                switch result {
                    
                case .success(let data):
                    emitter.onNext(data)
                    emitter.onCompleted()
                    
                case .failure(let err):
                    emitter.onError(err)
                }
            }
            return Disposables.create()
        }
    }
    
    
    static func fetchWeatherData(completion: @escaping((Result<Data, Error>) -> Void)) {
        guard let url = URL(string: urlString) else {
            completion(.failure(NetWorkError.urlError))
            return
        }
        URLSession.shared.dataTask(with: url) { data, response, error in
            if let err = error {
                completion(.failure(err))
                return
            }
            
            guard let data = data else {
                completion(.failure(NetWorkError.fetchError))
                return
            }

            completion(.success(data))
            return
        }.resume()
    }
}
