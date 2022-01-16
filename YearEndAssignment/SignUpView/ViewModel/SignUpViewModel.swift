//
//  SignUpViewModel.swift
//  YearEndAssignment
//
//  Created by hoseung Lee on 2022/01/02.
//

import Foundation
import RxSwift
import RxRelay

class SignUpViewModel {
  var email = BehaviorRelay<String>(value: "")
  var nickname = BehaviorRelay<String>(value: "")
  var password = BehaviorRelay<String>(value: "")
  var validpassword = BehaviorRelay<String>(value: "")
  let bag = DisposeBag()
  
  var isValidInput = BehaviorRelay<Bool>(value: false)
  var testInput: Observable<Bool> {
    return Observable.create { observer in
      let isNotEmpty =
      !self.email.value.isEmpty &&
      !self.nickname.value.isEmpty &&
      !self.password.value.isEmpty &&
      !self.validpassword.value.isEmpty
      
      let passwordValidate =
      self.password.value == self.validpassword.value
      
      let emailValidate = self.isValidEmail(email: self.email.value)
      
      observer.onNext(isNotEmpty && passwordValidate && emailValidate)
      return Disposables.create()
    }
  }
  
  init() {
    [email, nickname, password, validpassword].forEach { behavior in
      behavior.subscribe(onNext: { _ in
        self.isValidInputCheck()
      }).disposed(by: bag)
    }
  }
  
  func isValidInputCheck() {
    
    let isNotEmpty =
    !email.value.isEmpty &&
    !nickname.value.isEmpty &&
    !password.value.isEmpty &&
    !validpassword.value.isEmpty
    
    let passwordValidate =
    password.value == validpassword.value
    
    let emailValidate = isValidEmail(email: email.value)
    
    isValidInput.accept(isNotEmpty && passwordValidate && emailValidate)
  }
  
  private func isValidEmail(email: String) -> Bool {
    let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
    let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
    return emailTest.evaluate(with: email)
  }
  
  
  func requestSignUp(completion: @escaping (Bool, Error?) -> Void) {
    
    let jsonDictionary = [
      "email": email.value,
      "username": nickname.value,
      "password": password.value,
    ]
    
    APIManager.shared.signUp(input: jsonDictionary)
      .share()
      .decode(type: Account.self, decoder: JSONDecoder())
      .subscribe(onNext: {
        CurrentAccount.shared.account.onNext($0)
      }, onError: { error in
        completion(false, error)
      }, onCompleted: {
        completion(true, nil)
      })
      .disposed(by: bag)
  }
}
