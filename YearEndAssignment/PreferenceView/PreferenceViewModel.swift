//
//  PreferenceViewModel.swift
//  YearEndAssignment
//
//  Created by hoseung Lee on 2022/01/06.
//

import Foundation
import RxSwift
import RxCocoa

class PreferenceViewModel {
  
  let currentText = BehaviorRelay<String>(value: "")
  let newPassText = BehaviorRelay<String>(value: "")
  let newValidPassText = BehaviorRelay<String>(value: "")
  let bag = DisposeBag()
  var viewDismiss = BehaviorRelay<Bool>(value: false)
  struct Input {
    let currentText: ControlProperty<String>
    let newPassText: ControlProperty<String>
    let newValidPassText: ControlProperty<String>
    let tap: ControlEvent<Void>
  }
  
  struct Output {
    let isValid: Driver<Bool>
    let requestChangePassword: ControlEvent<Void>
  }

  func transform(_ input: Input) -> Output {
    
    let result = Observable
      .combineLatest(
        input.currentText.map{!$0.isEmpty},
        input.newPassText.map{!$0.isEmpty},
        input.newValidPassText.map{!$0.isEmpty}) {
          current, new, valid -> Bool in
          if current, new, valid {
            return true
          } else {
            return false
          }
        }
        .asDriver(onErrorJustReturn: false)
                                          
    return Output(isValid: result, requestChangePassword: input.tap)
  }
  
  func requestChangePassword() -> Single<Bool> {
    let input = [
      "currentPassword": currentText.value,
      "newPassword": newPassText.value,
      "confirmNewPassword": newValidPassText.value
    ]
    
    return Single.create { single in
      APIManager.shared.chengePassword(input)
        .subscribe(onSuccess: { _ in
          single(.success(true))
        }, onFailure: { error in
          single(.failure(error))
        }, onDisposed: {
          
        })
        .disposed(by: self.bag)
      return Disposables.create()
    }
  }
}
