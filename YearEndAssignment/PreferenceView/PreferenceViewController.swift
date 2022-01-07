//
//  PreferenceViewController.swift
//  YearEndAssignment
//
//  Created by hoseung Lee on 2022/01/06.
//

import UIKit
import RxSwift
import RxCocoa

class PreferenceViewController: UIViewController {
  
  let mainView = PreferneceMainView()
  let viewModel = PreferenceViewModel()
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
    mainView.backButton.rx.tap
      .subscribe(onNext: {
        self.navigationController?.popViewController(animated: true)
      })
      .disposed(by: bag)
  }
  
  private func bindConfigure() {
    let input = PreferenceViewModel.Input(
      currentText: mainView.currentPassTextField.subTextField.rx.text.orEmpty,
      newPassText: mainView.newPassTextField.subTextField.rx.text.orEmpty,
      newValidPassText: mainView.newValidPassTextField.subTextField.rx.text.orEmpty, tap: mainView.confirmButton.rx.tap)
    
    let output = viewModel.transform(input)
    
    output.isValid
      .drive(mainView.confirmButton.rx.isEnabled)
      .disposed(by: bag)
    
    output.requestChangePassword
      .subscribe(onNext: {
        self.viewModel.requestChangePassword()
          .subscribe(onSuccess: { _ in
            self.freeSizeToast(text: "비밀번호를 성공적으로 변경했습니다🔒", size: CGSize(width: 120, height: 55))
              .subscribe(onCompleted: {
                self.viewModel.viewDismiss.accept(true)
              }).disposed(by: self.bag)
          }, onFailure: { error in
            let error = error
            self.alert(title: error.localizedDescription)
              .subscribe()
              .disposed(by: self.bag)
          })
          .disposed(by: self.bag)
      })
      .disposed(by: bag)
    
    mainView.currentPassTextField.subTextField.rx.text
      .orEmpty
      .subscribe(onNext: {
        self.viewModel.currentText.accept($0)
      })
      .disposed(by: bag)
    
    mainView.newPassTextField.subTextField.rx.text
      .orEmpty
      .subscribe(onNext: {
        self.viewModel.newPassText.accept($0)
      })
      .disposed(by: bag)
    
    mainView.newValidPassTextField.subTextField.rx.text
      .orEmpty
      .subscribe(onNext: {
        self.viewModel.newValidPassText.accept($0)
      })
      .disposed(by: bag)
  }
}
