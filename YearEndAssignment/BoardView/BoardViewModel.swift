//
//  BoardViewModel.swift
//  YearEndAssignment
//
//  Created by hoseung Lee on 2022/01/05.
//

import Foundation
import RxSwift
import RxRelay

class BoardViewModel {
  
  var posts = BehaviorRelay<[BoardElement]>(value: [])
  var comments = BehaviorRelay<[DetailComment]>(value: [])
  var page = BehaviorRelay<Int>(value: 10)
  let bag = DisposeBag()
  
  func fetchBoardElement(sort: SortStyle = .descending, completion: @escaping (Error?) -> Void) {
    APIManager.shared.getPosts(sort: sort, page: self.page.value) { data, error in
      DispatchQueue.main.async {
        if let error = error {
          completion(error)
          return
        }
        
        guard let data = data else {
          completion(APIError.invalidData)
          return
        }
        
        do {
          let decoded = try JSONDecoder().decode([BoardElement].self, from: data)
        
          self.posts.accept(decoded.sorted(by: { lhs, rhs in
            if sort == .descending {
              return lhs.id < rhs.id
            } else {
              return lhs.id > rhs.id
            }
            
          }))
        } catch let error {
          completion(error)
        }
        return

      }
    }
  }
  
  init() {
  }
  
  
}

