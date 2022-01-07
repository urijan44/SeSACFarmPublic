//
//  ToastView.swift
//  YearEndAssignment
//
//  Created by hoseung Lee on 2022/01/06.
//

import UIKit
import SwiftUI
import SnapKit
import Then

class ToastView: UIView {
  
  var text = "" {
    didSet {
      label.text = text
    }
  }
  
  let label = UILabel().then {
    $0.textAlignment = .center
    $0.font = .systemFont(ofSize: 14, weight: .bold)
    $0.textColor = .white
    $0.numberOfLines = 0
  }
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    backgroundColor = UIColor.black.withAlphaComponent(0.5)
    
    addSubview(label)
    label.snp.makeConstraints { make in
      make.center.equalToSuperview()
      make.leading.trailing.equalToSuperview().inset(8)
    }
    
  }
  
  required init?(coder: NSCoder) {
    fatalError()
  }
  
  override func layoutSubviews() {
    super.layoutSubviews()
    
    layer.cornerRadius = 8
  }
  
}
struct ToastViewRP: UIViewRepresentable {
  func makeUIView(context: UIViewRepresentableContext<ToastViewRP>) -> ToastView {
    ToastView()
  }
  
  func updateUIView(_ uiView: ToastView, context: Context) {
    uiView.label.text = "포스트를 등록했습니다."
  }
}

struct ToastViewRP_Preview: PreviewProvider {
  static var previews: some View {
    ToastViewRP()
      .frame(width: 120, height: 60, alignment: .center)
      .previewLayout(.sizeThatFits)
  }
}
