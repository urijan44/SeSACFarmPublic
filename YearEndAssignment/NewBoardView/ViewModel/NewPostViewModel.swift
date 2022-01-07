//
//  NewPostViewModel.swift
//  YearEndAssignment
//
//  Created by hoseung Lee on 2022/01/06.
//

import Foundation
import RxSwift
import RxRelay

class NewPostViewModel {
  private let bag = DisposeBag()
  var text = BehaviorRelay<String>(value: "")
  var postId: Int?
  var receivedText: String?
  var saveButtonEnabled = BehaviorRelay<Bool>(value: false)
  
  init() {
    text.subscribe(onNext: {
      self.saveButtonEnabled.accept(!$0.isEmpty)
    })
      .disposed(by: bag)
    
    if receivedText != nil {
      text.accept(receivedText ?? "?")
    }
  }
  
  var viewDismiss = BehaviorRelay<Bool>(value: false)
  
  func saveRequest() -> Single<Bool> {
    return Single.create { single in
      let input = ["text": self.text.value]
      APIManager.shared.writeNewPost(input) { data, error in
        if let error = error {
          single(.failure(error))
          return
        }
        
        if let _ = data {
          single(.success(true))
          return
        }
      }
      return Disposables.create()
    }
  }
  
  func editPost() -> Single<Bool> {
    return Single.create { single in
      guard let id = self.postId else { return Disposables.create() }
      
      let input = [
        "text": self.text.value
      ]
      
      APIManager.shared.editPost(postId: id, input)
        .subscribe(onSuccess: { _ in
          single(.success(true))
        }, onFailure: { error in
          single(.failure(error))
        })
        .disposed(by: self.bag)
      return Disposables.create()
    }
  }
}
