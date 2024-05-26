//
//  PostRepository.swift
//  CoordinatorPattern
//
//  Created by jung on 5/26/24.
//

import RxSwift
import Foundation

enum NetworkError: Error {
	case decodingFailed
	case noHttpResponse
	case networkingFailed
}

struct PostRepository {
	func fetchPosts() -> Single<[Post]> {
		return Single<[Post]>.create { emitter in
			Task {
				do {
					let request = postsUrlRequest()
					
					let data: [Post] = try await fetchPosts(request: request)
					emitter(.success(data))
				} catch {
					emitter(.failure(error))
				}
			}
			
			return Disposables.create()
		}
	}
	
	func fetchPost(id: Int) -> Single<Post> {
		return Single<Post>.create { emitter in
			Task {
				do {
					let request = postUrlRequest(id: id)
					
					let data: Post = try await fetchPosts(request: request)
					emitter(.success(data))
				} catch {
					emitter(.failure(error))
				}
			}
			
			return Disposables.create()
		}
	}
	
	
	func fetchPosts<T: Decodable>(request: URLRequest) async throws -> T {
		let (data, response) = try await URLSession.shared.data(for: request)
		
		guard let response = response as? HTTPURLResponse else {
			throw NetworkError.noHttpResponse
		}
		
		guard response.statusCode >= 200 && response.statusCode < 300 else {
			throw NetworkError.networkingFailed
		}
		
		let decodedData = try JSONDecoder().decode(T.self, from: data)
		
		return decodedData
	}
	
	func postsUrlRequest() -> URLRequest {
		let url = "https://jsonplaceholder.typicode.com/posts"
		var urlRequest = URLRequest(url: URL(string: url)!)
		urlRequest.httpMethod = "GET"
		
		return urlRequest
	}
	
	func postUrlRequest(id: Int) -> URLRequest {
		let url = "https://jsonplaceholder.typicode.com/posts/\(id)"
		var urlRequest = URLRequest(url: URL(string: url)!)
		urlRequest.httpMethod = "GET"
		
		return urlRequest
	}
}
