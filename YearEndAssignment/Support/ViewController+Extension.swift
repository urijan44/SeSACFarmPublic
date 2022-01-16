//
//  ViewController+Extension.swift
//  YearEndAssignment
//
//  Created by hoseung Lee on 2022/01/05.
//

import UIKit
import RxSwift

extension UIViewController {
  func alert(title: String, text: String? = nil) -> Completable {
    return Completable.create { [weak self] completable in
      let alert = UIAlertController(title: title, message: text, preferredStyle: .alert)
      alert.addAction(.init(title: "닫기", style: .default, handler: { _ in
        completable(.completed)
      }))
      self?.present(alert, animated: true)
      return Disposables.create()
    }
  }
  

  func toast(text: String,
             size: CGSize = CGSize(width: 120, height: 44),
             position: ToastStyle = .top,
             popChain: Bool = false
            ) -> Completable {
    return Completable.create { [weak self] completable in
      guard let self = self else { return Disposables.create() }
      DispatchQueue.main.async {

        let toastView = ToastView(
          text: text,
          superview: self.view,
          size: size,
          position: position)
        
        self.view.addSubview(toastView)
        
        toastView.toastAnimate {
          completable(.completed)
        }
      }
      return Disposables.create {
        if popChain { self.navigationController?.popViewController(animated: true) }
      }
    }
  }
}
