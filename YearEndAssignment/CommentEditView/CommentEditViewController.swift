//
//  CommentEditViewController.swift
//  YearEndAssignment
//
//  Created by hoseung Lee on 2022/01/06.
//

import UIKit
import RxSwift
import RxRelay
import RxCocoa



class CommentEditViewController: NiblessViewController {
  
  let mainView = CommentEditView()
  let viewModel: CommentEditViewModel
  let bag = DisposeBag()
  
  init(viewModel: CommentEditViewModel) {
    self.viewModel = viewModel
    mainView.textView.text = viewModel.text
    super.init()
  }
    
  override func loadView() {
    view = mainView
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    mainView.textView.becomeFirstResponder()
    bind()
  }
  
  private func bind() {
    let input = CommentEditViewModel.Input(
      text: mainView.textView.rx.text.orEmpty,
      cancelTap: mainView.cancel.rx.tap,
      completeTap: mainView.complete.rx.tap)
    
    let output = viewModel.transform(input: input)
    
    output.editCancelTransition
      .drive(onNext: {
        self.navigationController?.popViewController(animated: true)
      })
      .disposed(by: bag)
    
    output.editComplete
      .drive(onNext: {
        self.editComplete(input: input)
      })
      .disposed(by: bag)
   
    output.editValidate
      .drive(mainView.complete.rx.isEnabled)
      .disposed(by: bag)
  }
  
  private func editComplete(input: CommentEditViewModel.Input) {
    mainView.complete.isEnabled = false
    viewModel.requestCommentEdit(input: input)
      .subscribe(onSuccess: { [weak self] in
        guard let self = self else { return }
        self.toast(text: "댓글을 수정했습니다.", size: CGSize(width: 120, height: 33), position: .bottom)
          .subscribe(onCompleted: {
            self.navigationController?.popViewController(animated: true)
          })
          .disposed(by: self.bag)
      }, onFailure: { [weak self] in
        guard let self = self else { return }
        self.alert(title: $0.localizedDescription)
          .subscribe(onDisposed: {
            self.mainView.complete.isEnabled = true
          })
          .disposed(by: self.bag)
      }).disposed(by: bag)
  }
}
