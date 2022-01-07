//
//  PreferenceMaiNView.swift
//  YearEndAssignment
//
//  Created by hoseung Lee on 2022/01/06.
//

import UIKit
import SwiftUI
import SnapKit
import Then

class PreferneceMainView: UIView {
  
  let stackView = UIStackView().then {
    $0.axis = .vertical
    $0.distribution = .fillEqually
    $0.spacing = 16
  }
  
  let currentPassTextField = SignUpTextField().then {
    $0.placeholder = "현재 비밀번호를 입력하세요"
    $0.isSecureTextEntry = true
  }
  
  let newPassTextField = SignUpTextField().then {
    $0.placeholder = "새 비밀번호를 입력하세요"
    $0.isSecureTextEntry = true
  }
  
  let newValidPassTextField = SignUpTextField().then {
    $0.placeholder = "새 비밀번호를 한번 더 입력하세요"
    $0.isSecureTextEntry = true
  }
  
  let confirmButton = SeSACButton().then {
    $0.title = "변경하기"
  }
  
  let navigationBar = UINavigationBar().then {
    $0.shadowImage = UIImage()
    $0.setBackgroundImage(UIImage(), for: .default)
  }
  
  let navBarItem = UINavigationItem(title: "비밀번호 변경")
  let backButton = UIBarButtonItem(image: UIImage(systemName: "arrow.left"), style: .done, target: nil, action: nil)
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    viewSetup()
    layoutConfigure()
  }
  
  required init?(coder: NSCoder) {
    fatalError()
  }
  
  private func viewSetup() {
    addSubview(stackView)
    addSubview(navigationBar)
    
    navigationBar.items = [navBarItem]
    navBarItem.leftBarButtonItem = backButton
    navigationBar.tintColor = .black
    
    [currentPassTextField, newPassTextField,
     newValidPassTextField, confirmButton].forEach {
      stackView.addArrangedSubview($0)
    }
    
  }
  
  private func layoutConfigure() {
    navigationBar.snp.makeConstraints { make in
      make.leading.trailing.equalToSuperview()
      make.top.equalTo(safeAreaLayoutGuide.snp.top)
      make.height.equalTo(44)
    }
    
    stackView.snp.makeConstraints { make in
      make.centerX.equalToSuperview()
      make.top.equalTo(navigationBar.snp.bottom).offset(8)
    }
    
    [currentPassTextField, newPassTextField,
     newValidPassTextField, confirmButton].forEach {
      $0.snp.makeConstraints { make in
        make.width.equalTo(snp.width).multipliedBy(0.9)
        make.centerX.equalToSuperview()
        make.height.equalTo(40)
      }
    }
  }
}
