//
//  NicknameFieldView.swift
//  YearEndAssignment
//
//  Created by hoseung Lee on 2022/01/02.
//


import UIKit
import SwiftUI
import SnapKit

class NicknameFieldView: UIView {
  
  var text: String = "" {
    didSet {
      nameLabel.text = text
    }
  }
  
  let backgroundView: UIView = {
    let view = UIView()
    view.backgroundColor = .systemGray5
    view.layer.cornerRadius = 4
    return view
  }()
  
  let nameLabel: UILabel = {
    let label = UILabel()
    label.font = .systemFont(ofSize: 12, weight: .semibold)
    label.textColor = .secondaryLabel
    return label
  }()
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    
    addSubview(backgroundView)
    addSubview(nameLabel)
    
    nameLabel.snp.makeConstraints { make in
      make.leading.equalToSuperview().inset(4)
      make.centerY.equalToSuperview()
    }
    
    backgroundView.snp.makeConstraints { make in
      make.width.equalTo(nameLabel.snp.width).offset(7)
      make.centerX.equalTo(nameLabel.snp.centerX)
      make.centerY.equalToSuperview()
      make.height.equalTo(nameLabel.snp.height).offset(2)
      
    }
  }
  
  required init?(coder: NSCoder) {
    fatalError()
  }
}

struct NicknameFieldViewRP: UIViewRepresentable {
  func makeUIView(context: UIViewRepresentableContext<NicknameFieldViewRP>) -> NicknameFieldView {
    NicknameFieldView()
  }
  
  func updateUIView(_ uiView: NicknameFieldView, context: Context) {
    uiView.text = "메밀이"
  }
}

struct NicknameFieldViewRP_Previews: PreviewProvider {
  static var previews: some View {
    NicknameFieldViewRP()
      .frame(width: 300, height: 22, alignment: .center)
      .previewLayout(.sizeThatFits)
  }
}
