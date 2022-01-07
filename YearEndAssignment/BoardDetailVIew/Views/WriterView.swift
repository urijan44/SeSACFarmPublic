//
//  WriterView.swift
//  YearEndAssignment
//
//  Created by hoseung Lee on 2022/01/03.
//

import UIKit
import SwiftUI
import SnapKit
import Then

class WriterView: UIView {
  
  let imageView = UIImageView().then {
    $0.contentMode = .scaleAspectFit
    $0.clipsToBounds = true
    $0.image = UIImage(systemName: "person.fill")
    $0.tintColor = .gray
    $0.backgroundColor = .systemGray6
    
  }
  
  let nicknameLabel = UILabel().then {
    $0.font = .systemFont(ofSize: 12, weight: .semibold)
    $0.textColor = .black
  }
  
  let dateLabel = UILabel().then {
    $0.font = .systemFont(ofSize: 11, weight: .medium)
    $0.textColor = .secondaryLabel
  }
  
  let labelStackView = UIStackView().then {
    $0.axis = .vertical
    $0.distribution = .fillEqually
    $0.alignment = .leading
  }
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    createView()
    layoutConfigure()
  }
  
  required init?(coder: NSCoder) {
    fatalError()
  }
  
  private func createView() {
    addSubview(labelStackView)
    addSubview(imageView)
    
    [nicknameLabel, dateLabel].forEach {
      labelStackView.addArrangedSubview($0)
    }
    
  }
  
  private func layoutConfigure() {
    let imageViewSize: CGFloat = 36
    imageView.snp.makeConstraints { make in
      make.width.height.equalTo(imageViewSize)
      make.leading.equalToSuperview().offset(5)
      make.centerY.equalToSuperview()
    }
    imageView.layer.cornerRadius = imageViewSize / 2
    
    labelStackView.snp.makeConstraints { make in
      make.leading.equalTo(imageView.snp.trailing).offset(8)
      make.trailing.equalToSuperview().inset(8)
      make.top.bottom.equalTo(imageView)
    }
    
  }
  
}

struct WriterViewRP: UIViewRepresentable {
  func makeUIView(context: UIViewRepresentableContext<WriterViewRP>) -> WriterView {
    WriterView()
  }
  
  func updateUIView(_ uiView: WriterView, context: Context) {
    uiView.nicknameLabel.text = "테이크아웃좋아"
    uiView.dateLabel.text = "12/08"
  }
}

struct WriterViewRP_Preview: PreviewProvider {
  static var previews: some View {
    WriterViewRP()
      .frame(width: 350, height: 44, alignment: .center)
      .previewLayout(.sizeThatFits)
  }
}
