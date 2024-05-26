//
//  Containable.swift
//  CoordinatorPattern
//
//  Created by jung on 5/25/24.
//

/// 부모에게 요구하는 의존성들입니다.
public protocol Dependency { }

public protocol Containable: AnyObject {}

/// `Coordinator`, `ViewController`, `ViewModel`에서 필요한 의존성을 들고 있으며, `Coordinator`생성을 담당하는 객체입니다.
open class Container<DependencyType> {
	public let dependency: DependencyType
	
	public init(dependency: DependencyType) {
		self.dependency = dependency
	}
}
