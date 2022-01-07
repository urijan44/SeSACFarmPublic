//
//  SignUpMainView.swift
//  YearEndAssignment
//
//  Created by hoseung Lee on 2022/01/01.
//

import UIKit
import SwiftUI

class SignUpMainView: UIView {
  
  let containerView: UIStackView = {
    let sv = UIStackView()
    sv.axis = .vertical
    sv.spacing = 12
    sv.alignment = .center
    sv.distribution = .equalSpacing
    return sv
  }()
  
  let emailTextField: SignUpTextField = {
    let tf = SignUpTextField()
    tf.keyboardType = .emailAddress
    tf.placeholder = "이메일 주소"
    return tf
  }()
  
  let nickNameTextField: SignUpTextField = {
    let tf = SignUpTextField()
    tf.placeholder = "닉네임"
    return tf
  }()
  
  let passwordTextField: SignUpTextField = {
    let tf = SignUpTextField()
    tf.subTextField.isSecureTextEntry = true
    tf.placeholder = "비밀번호"
    return tf
  }()
  
  let passwordValidTextFIeld: SignUpTextField = {
    let tf = SignUpTextField()
    tf.placeholder = "비밀번호 확인"
    tf.subTextField.isSecureTextEntry = true
    return tf
  }()
  
  let startButton: SeSACButton = {
    let button = SeSACButton()
    button.title = "시작하기"
    return button
  }()
  
  let navigationBar: UINavigationBar = {
    let navBar = UINavigationBar()
    navBar.shadowImage = UIImage()
    navBar.setBackgroundImage(UIImage(), for: .default)
    return navBar
  }()
  
  
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    createView()
    layoutConfigure()
  }
  
  required init?(coder: NSCoder) {
    fatalError()
  }
  
  private func createView() {
    addSubview(containerView)
    addSubview(navigationBar)
    [emailTextField, nickNameTextField, passwordTextField, passwordValidTextFIeld, startButton].forEach { containerView.addArrangedSubview($0) }
  }
  
  private func layoutConfigure() {
    
    navigationBar.snp.makeConstraints { make in
      make.leading.trailing.equalToSuperview()
      make.top.equalTo(safeAreaLayoutGuide.snp.top)
      make.height.equalTo(44)
    }
    
    containerView.snp.makeConstraints { make in
      make.centerX.equalToSuperview()
      make.top.equalTo(navigationBar.snp.bottom).offset(8)
    }
    [emailTextField, nickNameTextField, passwordTextField, passwordValidTextFIeld, startButton].forEach {
      $0.snp.makeConstraints { make in
        make.width.equalTo(snp.width).multipliedBy(0.9)
        make.centerX.equalToSuperview()
        make.height.equalTo(40)
      }
    }
  }
}

struct SignUpRP: UIViewRepresentable {
  func makeUIView(context: UIViewRepresentableContext<SignUpRP>) -> SignUpMainView {
    SignUpMainView()
  }
  
  func updateUIView(_ uiView: UIViewType, context: Context) {
    
  }
}

struct SignUPView_Previews: PreviewProvider {
  static var previews: some View {
    SignUpRP()
  }
}
