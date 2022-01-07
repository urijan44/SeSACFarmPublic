//
//  APIManager.swift
//  YearEndAssignment
//
//  Created by hoseung Lee on 2022/01/03.
//

import Foundation
import RxSwift

enum APIError: Error, LocalizedError {
  case invalidResponse(String)
  case noData
  case failure
  case invalidData
  
  public var errorDescription: String? {
    switch self {
      case .invalidResponse(let string):
        return string
      case .noData:
        return "noData"
      case .failure:
        return "failure"
      case .invalidData:
        return "invalid data"
    }
  }
}

enum RequestType {
  case write
  case none
}

enum HTTPMethod: String {
  case put = "PUT"
  case post
}

enum SortStyle {
  case ascending
  case descending
}

class APIManager {
  static let shared = APIManager()
  
  private init() {
    guard let baseUrl = Bundle.main.infoDictionary?["BaseURL"] as? String else { self.baseURL = "" ; return }
    self.baseURL.write(baseUrl)
  }
  
  private var baseURL: String = "http://"
  private let session = URLSession(configuration: .default)
  
  func signUp(input: Dictionary<String, String>) -> Observable<Data> {
    return Observable.create { observer in
      guard let url = URL(string: self.baseURL)?.appendingPathComponent("auth/local/register"),
            let jsonData = try? JSONEncoder().encode(input) else {
              observer.onError(APIError.failure)
              return Disposables.create()
            }
      var request = URLRequest(url: url)
      request.httpMethod = "POST"
      request.setValue(Header.json.rawValue, forHTTPHeaderField: Field.contentType.rawValue)
      let task = self.session.uploadTask(with: request, from: jsonData) { data, response, error in
        guard error == nil else {
          observer.onError(APIError.failure)
          return
        }
        
        guard let response = response as? HTTPURLResponse, (200..<300).contains(response.statusCode) else {
          observer.onError(APIError.invalidResponse("invalidResponse"))
          return
        }
        
        guard let data = data else {
          observer.onError(APIError.noData)
          return
        }
        observer.onNext(data)
        observer.onCompleted()
      }
      task.resume()
      return Disposables.create() {
        task.cancel()
      }
    }
  }
  
  func signUp(_ account: Account, _ input: Dictionary<String, String>, completion: @escaping (Account?, APIError?) -> Void) {
    
    guard
      let url = URL(string: baseURL)?.appendingPathComponent("auth/local/register"),
      let jsonData = try? JSONEncoder().encode(input)
    else { return }
    
    var request = URLRequest(url: url)
    request.httpMethod = "post"
    request.setValue(Header.json.rawValue, forHTTPHeaderField: Field.contentType.rawValue)
    
    uploadRequest(account, request: request, jsonData: jsonData) { account, error in
      DispatchQueue.main.async {
        if let _ = error {
          completion(nil, error)
          return
        }
        
        if let account = account {
          completion(account, nil)
          return
        }
      }
    }
  }
  
  func signIn(_ input: Dictionary<String, String>, completion: @escaping (Data?, Error?) -> Void) {
    guard
      let url = URL(string: baseURL)?.appendingPathComponent("auth/local"),
      let jsonData = try? JSONEncoder().encode(input)
    else { return }
    
    uploadRequest(url: url, data: jsonData) { data, error in
      if let error = error {
        completion(nil, error)
        return
      }
      if let data = data {
        completion(data, nil)
        return
      }
    }
  }
  
  func writeNewPost(_ input: Dictionary<String, String>, completion: @escaping (Data?, Error?) -> Void) {
    guard
      let url = URL(string: baseURL)?.appendingPathComponent("posts"),
      let data = try? JSONEncoder().encode(input)
        else { return }
    
    uploadRequest(url: url, data: data, requestType: .write) { data, error in
      if let error = error {
        completion(nil, error)
        return
      }
      if let data = data {
        completion(data, nil)
        return
      }
    }
  }
  
  func writeNewComment(_ input: Dictionary<String, String>, completion: @escaping (Data?, Error?) -> Void) {
    guard
      let url = URL(string: baseURL)?.appendingPathComponent("comments"),
      let data = try? JSONEncoder().encode(input)
    else{ return }
    
    uploadRequest(url: url, data: data, requestType: .write) { data, error in
      if let error = error {
        completion(nil, error)
        return
      }
      if let data = data {
        completion(data, nil)
        return
      }
    }
  }
  
  func chengePassword(_ input: Dictionary<String, String>) -> Single<Bool> {
    return Single.create { single in
      guard
        let url = URL(string: self.baseURL)?.appendingPathComponent("custom/change-password"),
        let data = try? JSONEncoder().encode(input) else {
          fatalError()
        }
      
      
      self.uploadRequest(url: url, data: data, requestType: .write) { data, error in
        DispatchQueue.main.async {
          if let error = error {
            single(.failure(error))
          }
          
          if let _ = data {
            single(.success(true))
          }
        }
      }
      return Disposables.create()
    }
  }
  
  func editPost(postId id: Int, _ input: Dictionary<String, String>) -> Single<Bool> {
    return Single.create { single in
      guard
        let url = URL(string: self.baseURL)?.appendingPathComponent("posts/\(id)"),
        let data = try? JSONEncoder().encode(input) else {
          fatalError()
        }
      
      self.uploadRequest(url: url, data: data, requestType: .write, method: .put) { data, error in
        DispatchQueue.main.async {
          if let error = error {
            single(.failure(error))
          }
          
          if let _ = data {
            single(.success(true))
          }
        }
      }
      return Disposables.create()
    }
  }
  
  func editComment(commentId id: Int, _ input: Dictionary<String, String>) -> Single<Bool> {
    return Single.create { single in
      guard
        let url = URL(string: self.baseURL)?.appendingPathComponent("comments/\(id)"),
        let data = try? JSONEncoder().encode(input) else {
          fatalError()
        }
      
      self.uploadRequest(url: url, data: data, requestType: .write, method: .put) { data, error in
        DispatchQueue.main.async {
          if let error = error {
            single(.failure(error))
          }
          
          if let _ = data {
            single(.success(true))
          }
        }
      }
      return Disposables.create()
    }
  }
  
  func deleteComment(commentId id: Int) -> Single<Void> {
    return Single.create { single in
      guard
        let url = URL(string: self.baseURL)?.appendingPathComponent("comments/\(id)") else {
          fatalError()
        }
      
      self.deleteRequest(url: url) { success, error in
          if let error = error {
            single(.failure(error))
          } else {
            single(.success(()))
          }
      }
      return Disposables.create()
    }
  }
  
  private func uploadRequest<T: Codable>(_ type: T, request: URLRequest, jsonData: Data, completion: @escaping (T?, APIError?) -> Void) {
    let session = URLSession(configuration: .default)
    let task = session.uploadTask(with: request, from: jsonData) { data, response, error in
      
      guard error == nil else {
        completion(nil, .failure)
        return
      }
      
      guard let response = response as? HTTPURLResponse, (200..<300).contains(response.statusCode) else {
        completion(nil,.invalidResponse("invalidResponse"))
        return
      }
      
      guard let data = data else {
        completion(nil, .noData)
        return
      }
      
      guard let decoded = try? JSONDecoder().decode(T.self, from: data) else {
        completion(nil, .invalidData)
        return
      }
      completion(decoded, nil)
      
    }
    task.resume()
  }
  
  private func uploadRequest(url: URL, data: Data, requestType: RequestType = .none, method: HTTPMethod = .post, completion: @escaping (Data?, Error?) -> Void) {
    var request = URLRequest(url: url)
    request.httpMethod = method.rawValue
    request.setValue(Header.json.rawValue, forHTTPHeaderField: Field.contentType.rawValue)
    
    if requestType == .write {
      request.addValue("\(Header.bearer.rawValue) \(CurrentAccount.shared.token)", forHTTPHeaderField: Field.authorization.rawValue)
    }
    
    let task = session.uploadTask(with: request, from: data) { data, response, error in
      guard error == nil else {
        completion(nil, APIError.failure)
        return
      }
      
      guard let response = response as? HTTPURLResponse, (200..<300).contains(response.statusCode) else {
        
        guard let data = data,
              let json = try? JSONSerialization.jsonObject(with: data, options: .fragmentsAllowed) as? [String: Any],
              let message = json["message"] as? String
        else {
          completion(nil, APIError.invalidResponse("알수없는 오류"))
          return
        }

        completion(nil, APIError.invalidResponse(message))
        return
      }
      
      guard let data = data else {
        completion(nil, error)
        return
      }
      completion(data, nil)
    }
    task.resume()
  }
  
  func getPosts(sort: SortStyle = .descending, page: Int = 10, completion: @escaping (Data?, Error?) -> Void) {
    var components = URLComponents(string: baseURL + "/posts")
    
    let sortQuery = URLQueryItem(name: "_sort", value: sort == .descending ? "created_at:desc" : "created_at:asc")
    let startPage = URLQueryItem(name: "_start", value: "1")
    let limitPage = URLQueryItem(name: "_limit", value: page.description)
    components?.queryItems = [sortQuery, startPage, limitPage]
    
    guard let url = components?.url else { return }
    
    getRequest(url: url) { data, error in
      if let error = error {
        completion(nil, error)
        return
      }
      
      if let data = data {
        completion(data, nil)
        return
      }
    }
  }
  
  func getComments(postNumber: Int, completion: @escaping (Data?, Error?) -> Void) {
    guard let url = URL(string: baseURL)?.appendingPathComponent("comments") else { return }
    var components = URLComponents(url: url, resolvingAgainstBaseURL: true)
    let query = URLQueryItem(name: "post", value: postNumber.description)
    components?.queryItems = [query]
    
    guard let queryUrl = components?.url else { return }
    
    getRequest(url: queryUrl) { data, error in
      if let error = error {
        completion(nil, error)
        return
      }
      
      if let data = data {
        completion(data, nil)
        return
      }
    }
    
  }
  
  private func getRequest(url: URL, completion: @escaping (Data?, Error?) -> Void) {
    
    var reqeust = URLRequest(url: url)
    reqeust.httpMethod = "get"
    reqeust.setValue("\(Header.bearer.rawValue) \(CurrentAccount.shared.token)", forHTTPHeaderField: Field.authorization.rawValue)
    
    session.dataTask(with: reqeust) { data, response, error in
      guard error == nil else {
        completion(nil, error)
        return
      }
      
      guard let response = response as? HTTPURLResponse, (200..<300).contains(response.statusCode) else {
        completion(nil, APIError.invalidResponse("Invalie Response"))
        return
      }
      
      guard let data = data else {
        completion(nil, APIError.noData)
        return
      }
      completion(data, nil)
    }.resume()
  }

  
  //MARK: - Delete
  func deletePost(postId: Int) -> Single<Bool> {
    return Single.create { single in
      guard let url = URL(string: self.baseURL)?.appendingPathComponent("posts/\(postId)") else { fatalError()}
      
      self.deleteRequest(url: url) { success, error in
        DispatchQueue.main.async {
          if let error = error {
            single(.failure(error))
          }
          
          if let success = success  {
            single(.success(success))
          }
        }
      }
      return Disposables.create()
    }
  }
  
  private func deleteRequest(url: URL, completion: @escaping ((Bool?, Error?) ->Void )) {
    var request = URLRequest(url: url)
    request.httpMethod = "delete"
    request.setValue("\(Header.bearer.rawValue) \(CurrentAccount.shared.token)", forHTTPHeaderField: Field.authorization.rawValue)
    
    let task = session.dataTask(with: request) { data, response, error in
      guard error == nil else {
        completion(nil, APIError.failure)
        return
      }
      
      guard let response = response as? HTTPURLResponse, (200..<300).contains(response.statusCode) else {
        
        guard let data = data,
              let json = try? JSONSerialization.jsonObject(with: data, options: .fragmentsAllowed) as? [String: Any],
              let message = json["message"] as? String
        else {
          return
        }
        completion(nil, APIError.invalidResponse(message))
        return
      }
      
      guard let _ = data else {
        completion(nil, error)
        return
      }
      completion(true, nil)
    }
    task.resume()
  }
}
