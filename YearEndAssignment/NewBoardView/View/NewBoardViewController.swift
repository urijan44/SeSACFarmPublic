//
//  NewBoardViewController.swift
//  YearEndAssignment
//
//  Created by hoseung Lee on 2022/01/03.
//

import UIKit
import RxSwift
import RxRelay
import RxCocoa

enum WorkType {
  case new
  case edit
}

class NewBoardViewController: UIViewController {
  
  let mainView = NewBoardMainView()
  let viewModel = NewPostViewModel()
  var bag = DisposeBag()
  var worktype: WorkType = .new
  override func loadView() {
    view = mainView
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    view.backgroundColor = .white
    navigationBarConfigure()
    actionConnect()
    bindSetup()
  }
  
  override func viewDidAppear(_ animated: Bool) {
    super.viewDidAppear(animated)
    navigationController?.isNavigationBarHidden = false
  }
  
  override func viewWillDisappear(_ animated: Bool) {
    super.viewWillDisappear(animated)
    navigationController?.isNavigationBarHidden = true
  }

  private func navigationBarConfigure() {
    navigationItem.leftBarButtonItem = mainView.cancel
    navigationItem.rightBarButtonItem = mainView.complete
    navigationController?.navigationBar.tintColor = .black
    if worktype == .new {
      title = "새싹농장 글쓰기"
    } else {
      title = "새싹농장 수정하기"
    }
  }
  
  private func bindSetup() {
    viewModel.saveButtonEnabled
      .bind(to: mainView.complete.rx.isEnabled)
      .disposed(by: bag)
  }
  
  private func actionConnect() {
    mainView.cancel.rx.tap.subscribe(onNext: { _ in
        self.cancelNewBoard()
      }).disposed(by: bag)
    
    mainView.complete.rx.tap.subscribe(onNext: { _ in
      if self.worktype == .new {
        self.saveNewBoard()
      } else {
        self.editBoard()
      }
      }).disposed(by: bag)
    
    mainView.textView.rx.text
      .orEmpty
      .subscribe(onNext: {
        self.viewModel.text.accept($0)
      })
      .disposed(by: bag)
  }
  
  func cancelNewBoard() {
    navigationController?.popViewController(animated: true)
  }
  
  func saveNewBoard() {
    viewModel.saveRequest().subscribe(onSuccess: { _ in
      self.toast(text: "포스트를 작성했습니다✏️")
        .subscribe(onCompleted: {
          self.viewModel.viewDismiss.accept(true)
        })
        .disposed(by: self.bag)
    }, onFailure: { error in
      self.alert(title: error.localizedDescription)
        .subscribe()
        .disposed(by: self.bag)
    }).disposed(by: bag)
  }
  
  func editBoard() {
    viewModel.editPost().subscribe(onSuccess: { _ in
      self.toast(text: "포스트를 수정했습니다✏️")
        .subscribe(onCompleted: {
          self.viewModel.viewDismiss.accept(true)
        })
        .disposed(by: self.bag)
    }, onFailure: { error in
      self.alert(title: error.localizedDescription)
        .subscribe()
        .disposed(by: self.bag)
    }).disposed(by: bag)
  }
}
