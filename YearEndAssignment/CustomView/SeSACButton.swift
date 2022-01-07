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
  }
  
  required init?(coder: NSCoder) {
    fatalError()
  }
}
