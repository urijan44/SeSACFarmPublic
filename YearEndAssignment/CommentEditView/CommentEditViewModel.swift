//
//  CommentEditViewModel.swift
//  YearEndAssignment
//
//  Created by hoseung Lee on 2022/01/14.
//

import Foundation
import RxSwift
import RxCocoa
class CommentEditViewModel {
  var text: String
  var commentId: Int
  var postId: Int
  var bag = DisposeBag()
  
  init(text: String, commentId: Int, postId: Int) {
    self.text = text
    self.commentId = commentId
    self.postId = postId
  }
  
  struct Input {
    let text: ControlProperty<String>
    let cancelTap: ControlEvent<Void>
    let completeTap: ControlEvent<Void>
  }
  
  struct Output {
    let initText: String
    let editCancelTransition: Driver<Void>
    let editComplete: Driver<Void>
    let editValidate: Driver<Bool>
  }
  
  func transform(input: Input) -> Output {
    
    let initText = self.text
    
    let cancel = input.cancelTap.asDriver()
    let complete = input.completeTap.asDriver()
    
    let saveValidate = input.text
      .map { $0 != self.text }
      .share(replay: 1, scope: .whileConnected)
      .asDriver(onErrorJustReturn: false)
    
    return Output(
      initText: initText,
      editCancelTransition: cancel,
      editComplete: complete,
      editValidate: saveValidate
    )
  }
  
  func requestCommentEdit(input: Input) -> Single<Void> {
    return Single.create { [weak self] single in
      guard let self = self else { return Disposables.create() }
      var text = ""
      
      
      input.text.bind(onNext: {
        text = $0
      })
        .disposed(by: self.bag)
        
      let input = [
        "comment": text,
        "post": "\(self.postId)"
      ]
      
      APIManager.shared.editComment(commentId: self.commentId, input)
        .subscribe(onSuccess: { _ in
          single(.success(()))
        }, onFailure: {
          single(.failure($0))
        })
        .disposed(by: self.bag)
      
      return Disposables.create()
    }
  }
}
