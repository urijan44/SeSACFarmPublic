//
//  DetailViewModel.swift
//  YearEndAssignment
//
//  Created by hoseung Lee on 2022/01/05.
//

import Foundation
import RxSwift
import RxRelay

class DetailViewModel {
  var post: BoardElement?
  var comments = BehaviorSubject<[DetailComment]>(value: [])
  let newComment = BehaviorRelay<String>(value: "")
  var selectedCommentId = -1
  var selectedCommentOwnerId = -1
  var selectedCommentText = ""
  var boardOwnership: Bool {
    if let id = post?.user.id, id == CurrentAccount.shared.id {
      return true
    } else {
      return false
    }
  }
  
  var commentOwnership: Bool {
    if selectedCommentOwnerId == CurrentAccount.shared.id {
      return true
    } else {
      return false
    }
  }
  
  var viewDismiss = BehaviorRelay<Bool>(value: false)
  
  var bag = DisposeBag()
  
  func fetchDetailComments(postNumber: Int, completion: @escaping (Error?) -> Void) {
    APIManager.shared.getComments(postNumber: postNumber) { data, error in
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
          let decoded = try JSONDecoder().decode([DetailComment].self, from: data)
          self.comments.onNext(decoded)
        } catch let error {
          completion(error)
        }
        return
      }
    }
  }
  
  func deletePost() -> Single<Bool> {
    return Single.create { single in
    
      APIManager.shared.deletePost(postId: self.post!.id)
        .subscribe(onSuccess: { _ in
          single(.success(true))
        }, onFailure: { error in
          single(.failure(error))
        })
        .disposed(by: self.bag)
      return Disposables.create()
    }
  }
  
  func newCommentPost() -> Single<Bool> {
    
    return Single.create { single in
      guard let post = self.post else {
        return Disposables.create()
      }
      
      let input = [
        "comment": self.newComment.value,
        "post": post.id.description
      ]
      
      APIManager.shared.writeNewComment(input) { data, error in
        if let error = error {
          single(.failure(error))
          return
        }
        if let _ = data {
          self.fetchDetailComments(postNumber: post.id) { _ in
            
          }
          single(.success(true))
          return
        }
      }
      self.newComment.accept("")
      return Disposables.create()
    }
  }
  
  func deleteComment() -> Single<Void> {
    return Single.create { single in
      APIManager.shared.deleteComment(commentId: self.selectedCommentId)
        .observe(on: MainScheduler.instance)
        .subscribe(onSuccess: {
          single(.success(()))
        }, onFailure: {
          single(.failure($0))
        })
        .disposed(by: self.bag)
      return Disposables.create()
    }
  }
}
