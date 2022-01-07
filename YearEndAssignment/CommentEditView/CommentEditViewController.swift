//
//  CommentEditViewController.swift
//  YearEndAssignment
//
//  Created by hoseung Lee on 2022/01/06.
//

import UIKit
import RxSwift
import RxRelay
class CommentEditViewModel {
  var text = BehaviorRelay<String>(value: "")
  var commentId = BehaviorRelay<Int>(value: -1)
  var postId = BehaviorRelay<Int>(value: -1)
  var bag = DisposeBag()
  
  func requestCommentEdit() -> Single<Void> {
    return Single.create { single in
      let input = [
        "comment": self.text.value,
        "post": "\(self.postId.value)"
      ]
      
      APIManager.shared.editComment(commentId: self.commentId.value, input)
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


class CommentEditViewController: UIViewController {
  
  let mainView = CommentEditView()
  let viewModel = CommentEditViewModel()
  let bag = DisposeBag()
  override func loadView() {
    view = mainView
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    view.backgroundColor = .white
    actionConnect()

    
    bindConfigure()
  }
  
  private func actionConnect() {
    mainView.cancel.rx.tap
      .asDriver()
      .drive(onNext: {
        self.navigationController?.popViewController(animated: true)
      })
      .disposed(by: bag)
    
    mainView.complete.rx.tap
      .asDriver()
      .drive(onNext: {
        self.editComplete()
      })
      .disposed(by: bag)
  }
  
  private func bindConfigure() {
    viewModel.text.bind(to: mainView.textView.rx.text)
      .disposed(by: bag)
    
    mainView.textView.rx.text
      .orEmpty
      .bind(onNext: {
        self.viewModel.text.accept($0)
      })
      .disposed(by: bag)
  }
  
  private func editComplete() {
    viewModel.requestCommentEdit()
      .subscribe(onSuccess: {
        self.freeSizeToast(text: "댓글을 수정했습니다.", size: CGSize(width: 120, height: 33))
          .subscribe(onCompleted: {
            self.navigationController?.popViewController(animated: true)
          })
          .disposed(by: self.bag)
      }, onFailure: {
        self.alert(title: $0.localizedDescription)
          .subscribe()
          .disposed(by: self.bag)
      }).disposed(by: bag)
  }
}
