//
//  SeSACButton.swift
//  YearEndAssignment
//
//  Created by hoseung Lee on 2022/01/01.
//

import UIKit

extension UIColor {
  static var signature: UIColor {
    UIColor(named: "SignatureColor") ?? UIColor()
  }
}

class SeSACButton: UIButton {
  
  let activityIndicator = UIActivityIndicatorView().then {
    $0.isHidden = true
  }
  
  var title: String = "" {
    didSet {
      setTitle(title, for: .normal)
    }
  }
  
  override var isEnabled: Bool {
    didSet {
      backgroundColor = isEnabled ? .signature : .sesacGray
    }
  }
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    
    backgroundColor = UIColor.signature
    setTitleColor(.white, for: .normal)
    layer.cornerRadius = 6
    titleLabel?.font = .systemFont(ofSize: 16, weight: .bold)
    
    activityConfigure()
  }
  
  required init?(coder: NSCoder) {
    fatalError()
  }
  
  private func activityConfigure() {
    addSubview(activityIndicator)
    
    activityIndicator.translatesAutoresizingMaskIntoConstraints = false
    NSLayoutConstraint.activate([
      activityIndicator.widthAnchor.constraint(equalToConstant: 22),
      activityIndicator.heightAnchor.constraint(equalToConstant: 22),
      activityIndicator.centerXAnchor.constraint(equalTo: centerXAnchor),
      activityIndicator.centerYAnchor.constraint(equalTo: centerYAnchor),
    ])
    
  }
  
  func startAnimating() {
    activityIndicator.startAnimating()
    activityIndicator.isHidden = false
    isEnabled = false
  }
  
  func stopAnimating() {
    activityIndicator.stopAnimating()
    activityIndicator.isHidden = true
    isEnabled = true
  }
}
