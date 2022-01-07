//
//  SignUpTextField.swift
//  YearEndAssignment
//
//  Created by hoseung Lee on 2022/01/02.
//

import UIKit

class SignUpTextField: UIView {
  
  let textFieldContainView: UIView = {
    let view = UIView()
    view.layer.borderColor = UIColor.secondaryLabel.cgColor
    view.layer.borderWidth = 0.5
    view.layer.cornerRadius = 6
    return view
  }()
  
  var placeholder: String = "" {
    didSet {
      subTextField.placeholder = placeholder
    }
  }
  
  var isSecureTextEntry: Bool = false {
    didSet {
      subTextField.isSecureTextEntry = isSecureTextEntry
    }
  }
  
  var keyboardType: UIKeyboardType = .default {
    didSet {
      subTextField.keyboardType = keyboardType
    }
  }
  
  var isEmpty: Bool {
    subTextField.text?.isEmpty ?? true
  }
  
  var text: String {
    subTextField.text ?? ""
  }
  
  let subTextField: UITextField = {
    let tf = UITextField()
    
    tf.font = .systemFont(ofSize: 14, weight: .regular)
    return tf
  }()
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    addSubview(textFieldContainView)
    textFieldContainView.addSubview(subTextField)
    
    textFieldContainView.snp.makeConstraints { make in
      make.width.equalToSuperview()
      make.centerX.equalToSuperview()
      make.height.equalTo(44)
    }
    
    subTextField.snp.makeConstraints { make in
      make.leading.trailing.equalToSuperview().inset(8)
      make.centerY.equalToSuperview()
    }
    
  }
  
  required init?(coder: NSCoder) {
    fatalError()
  }
  
  
}
