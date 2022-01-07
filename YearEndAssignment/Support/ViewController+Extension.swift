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
      return Disposables.create {
//        self?.dismiss(animated: true)
      }
    }
  }
  
  func toast(text: String, width: CGFloat = 0) -> Completable {
    return Completable.create { [weak self] completable in
      guard let self = self else { return Disposables.create() }
      DispatchQueue.main.async {
        let toastView = ToastView(frame: .init(x: self.view.bounds.midX - CGFloat(50), y: self.view.bounds.minY - CGFloat(30), width: 120, height: 44))
        toastView.text = text
        self.view.addSubview(toastView)
        
        UIView.animate(withDuration: 0.8, delay: 0, usingSpringWithDamping: 0.8, initialSpringVelocity: 0.5, options: .curveLinear) {
          toastView.center.y = self.view.bounds.minY + CGFloat(100)
        } completion: { _ in
          UIView.animate(withDuration: 0.2) {
            toastView.alpha = 0
          } completion: { _ in
            toastView.isHidden = true
            completable(.completed)
          }
        }
      }
      return Disposables.create {
        self.navigationController?.popViewController(animated: true)
      }
    }
  }
  
  func freeSizeToast(text: String, size: CGSize) -> Completable {
    return Completable.create { [weak self] completable in
      guard let self = self else { return Disposables.create() }
      DispatchQueue.main.async {
        //뷰 초기 위치 CenterX에서 y = 0
        let toastView = ToastView(frame: .init(x: self.view.bounds.midX - size.width / 2, y: self.view.bounds.minY - size.height / 2, width: size.width, height: size.height))
        toastView.text = text
        self.view.addSubview(toastView)
        
        UIView.animate(withDuration: 0.8, delay: 0, usingSpringWithDamping: 0.8, initialSpringVelocity: 0.5, options: .curveLinear) {
          toastView.center.y = self.view.bounds.midY - size.height / 2
        } completion: { _ in
          UIView.animate(withDuration: 0.2, delay: 0.8) {
            toastView.alpha = 0
          } completion: { _ in
            toastView.isHidden = true
            completable(.completed)
          }
        }
      }
      return Disposables.create()
    }
  }
  
  func commentToast(text: String) -> Completable {
    return Completable.create { [weak self] completable in
      guard let self = self else { return Disposables.create() }
      DispatchQueue.main.async {
        let toastView = ToastView(frame: .init(x: self.view.bounds.midX - 120, y: self.view.bounds.maxY + 22, width: 240, height: 33))
        toastView.text = text
        self.view.addSubview(toastView)
        
        UIView.animate(withDuration: 0.8, delay: 0, usingSpringWithDamping: 0.8, initialSpringVelocity: 0.5, options: .curveLinear) {
          toastView.center.y = self.view.bounds.maxY - CGFloat(44)
        } completion: { _ in
          UIView.animate(withDuration: 0.2) {
            toastView.alpha = 0
          } completion: { _ in
            toastView.isHidden = true
            completable(.completed)
          }
        }
      }
      return Disposables.create()
    }
  }
}
