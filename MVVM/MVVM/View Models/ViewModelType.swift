//
//  ViewModelType.swift
//  MVVM
//
//  Created by Seok Young Jung on 2023/03/30.
//

import Foundation
import RxSwift

protocol ViewModelType {
    associatedtype Dependency
    associatedtype Output
    
    var dependency: Dependency { get }
    var disposeBag: DisposeBag { get set }
    
    var output: Output { get }
    
    init(dependency: Dependency)
}
