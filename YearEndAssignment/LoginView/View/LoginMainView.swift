//
//  LoginMainView.swift
//  YearEndAssignment
//
//  Created by hoseung Lee on 2022/01/04.
//

import UIKit
import SwiftUI
import Then
import SnapKit

class LoginMainView: UIView {
  
  let containerView = UIStackView().then {
    $0.axis = .vertical
    $0.spacing = 12
    $0.alignment = .center
    $0.distribution = .equalSpacing
  }
  
  
  let idTextField = SignUpTextField().then {
    $0.subTextField.placeholder = "아이디"
  }
  
  let passwordTextField = SignUpTextField().then {
    $0.subTextField.isSecureTextEntry = true
    $0.subTextField.placeholder = "비밀번호"
  }
  
  let startButton = SeSACButton().then {
    $0.title = "시작하기"
  }
  
  let navigationBar = UINavigationBar().then {
    $0.shadowImage = UIImage()
    $0.setBackgroundImage(UIImage(), for: .default)
  }
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    viewSetup()
    layoutConfigure()
  }
  
  required init?(coder: NSCoder) {
    fatalError()
  }
  
  private func viewSetup() {
    addSubview(containerView)
    addSubview(navigationBar)
    [idTextField, passwordTextField, startButton].forEach {
      containerView.addArrangedSubview($0)
    }
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
    
    [idTextField, passwordTextField, startButton].forEach {
      $0.snp.makeConstraints { make in
        make.width.equalTo(snp.width).multipliedBy(0.9)
        make.centerX.equalToSuperview()
        make.height.equalTo(40)
      }
    }
  }
  
}

struct LoginMainViewRP: UIViewRepresentable {
  func makeUIView(context: UIViewRepresentableContext<LoginMainViewRP>) -> LoginMainView {
    LoginMainView()
  }
  
  func updateUIView(_ uiView: LoginMainView, context: Context) {
    
  }
}

struct LoginMainViewRP_Preview: PreviewProvider {
  static var previews: some View {
    LoginMainViewRP()
  }
}
