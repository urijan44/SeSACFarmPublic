//
//  CurrentAccount.swift
//  YearEndAssignment
//
//  Created by hoseung Lee on 2022/01/05.
//

import Foundation
import RxSwift
import RxRelay

class CurrentAccount {
  static let shared = CurrentAccount()
  
  let account = PublishSubject<Account>()
//  var tokenRefreshCount = Observable<Int>()
  let bag = DisposeBag()
  
  var token: String = "" {
    didSet {
      UserDefaults.standard.set(token, forKey: "token")
    }
  }
  var id: Int = -1
  
  private init() {
    
    account.subscribe(onNext: {
      if !$0.jwt.isEmpty {
        self.token = $0.jwt
      }
      if $0.user.id != -1 {
        self.id = $0.user.id
      }
    })
      .disposed(by: bag)
  }
}
