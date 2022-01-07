//
//  SignInViewModel.swift
//  YearEndAssignment
//
//  Created by hoseung Lee on 2022/01/05.
//

import Foundation
import RxSwift
import RxRelay

class SignInViewModel {
  
  func loginRequest(id: String, pass: String, completion: @escaping (Error?) -> Void) {
    let input = [
      "identifier": id,
      "password": pass
    ]
    
    APIManager.shared.signIn(input) { data, error in
      DispatchQueue.main.async {
        if let error = error {
          completion(error)
          return
        }
        
        guard let data = data else {
          completion(APIError.noData)
          return
        }
        
        do {
          let account = try JSONDecoder().decode(Account.self, from: data)
          CurrentAccount.shared.account.onNext(account)
          completion(nil)
        } catch let error {
          completion(error)
        }
        return
      }
      
    }
    
  }
}
