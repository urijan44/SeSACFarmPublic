//
//  StartMainView.swift
//  YearEndAssignment
//
//  Created by hoseung Lee on 2022/01/01.
//

import UIKit
import SnapKit

class StartMainView: UIView {
  
  let logoImageView: UIImageView = {
    let iv = UIImageView()
    iv.contentMode = .scaleAspectFit
    iv.image = UIImage(named: "Logo")
    return iv
  }()
  
  let greetingLabelTop: UILabel = {
    let label = UILabel()
    label.text = "당신 근처의 새싹 농장"
    label.font = .systemFont(ofSize: 19, weight: .semibold)
    label.textAlignment = .center
    return label
  }()
  
  let greetingLabelBottom: UILabel = {
    let label = UILabel()
    label.text = "iOS 지식부터 바람의 나라까지\n 지금 SeSAC에서 함께해보세요!"
    label.font = .systemFont(ofSize: 14, weight: .regular)
    label.textAlignment = .center
    label.numberOfLines = 2
    return label
  }()
  
  let startButton: SeSACButton = {
    let bt = SeSACButton()
    bt.title = "시작하기"
    return bt
  }()
  
  let alreadyAccouns: UILabel = {
    let label = UILabel()
    let text = "이미 계정이 있나요? 로그인"
    let wholeRange = (text as NSString).range(of: text)
    let loginRange = (text as NSString).range(of: "로그인")
    let descRange = (text as NSString).range(of: "이미 계정이 있나요?")
    let attr = NSMutableAttributedString(string: "이미 계정이 있나요? 로그인")
    attr.addAttribute(.foregroundColor, value: UIColor.secondaryLabel, range: descRange)
    attr.addAttribute(.foregroundColor, value: UIColor.signature, range: loginRange)
    attr.addAttribute(.font, value: UIFont.systemFont(ofSize: 14, weight: .medium), range: wholeRange)
    label.attributedText = attr
    return label
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
    [logoImageView, greetingLabelTop, greetingLabelBottom, startButton, alreadyAccouns]
      .forEach { addSubview($0) }
  }
  
  private func layoutConfigure() {
    logoImageView.snp.makeConstraints { make in
      make.width.height.equalTo(128)
      make.centerX.equalToSuperview()
      make.centerY.equalToSuperview().multipliedBy(0.7)
    }
    
    greetingLabelTop.snp.makeConstraints { make in
      make.top.equalTo(logoImageView.snp.bottom).offset(8)
      make.centerX.equalToSuperview()
    }
    
    greetingLabelBottom.snp.makeConstraints { make in
      make.top.equalTo(greetingLabelTop.snp.bottom).offset(8)
      make.centerX.equalToSuperview()
    }
    
    startButton.snp.makeConstraints { make in
      make.width.equalToSuperview().multipliedBy(0.9)
      make.height.equalTo(44)
      make.centerX.equalToSuperview()
      make.bottom.equalTo(alreadyAccouns.snp.top).offset(-16)
    }
    
    alreadyAccouns.snp.makeConstraints { make in
      make.centerX.equalToSuperview()
      make.bottom.equalTo(safeAreaLayoutGuide.snp.bottom).offset(8)
    }
  }
}
