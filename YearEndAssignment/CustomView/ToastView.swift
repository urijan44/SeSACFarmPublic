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

enum ToastStyle {
  case top
  case middle
  case bottom
}

class ToastView: UIView {
  
  var text = "" {
    didSet {
      label.text = text
    }
  }
  
  var cgRect: CGRect
  var position: ToastStyle = .top
  var size: CGSize = CGSize()
  
  let label = UILabel().then {
    $0.textAlignment = .center
    $0.font = .systemFont(ofSize: 14, weight: .bold)
    $0.textColor = .white
    $0.numberOfLines = 0
  }
  
  override init(frame: CGRect) {
    cgRect = frame
    super.init(frame: frame)
    backgroundColor = UIColor.black.withAlphaComponent(0.5)
    addSubview(label)
    label.snp.makeConstraints { make in
      make.center.equalToSuperview()
      make.leading.trailing.equalToSuperview().inset(8)
    }
  }
  
  convenience init(text: String, superview: UIView, size: CGSize, position: ToastStyle) {
    
    let width: CGFloat = size.width
    let height: CGFloat = size.height
    let x = superview.bounds.midX - width / 2
    
    var y = -(height / 2)
    
    switch position {
      case .top:
        y += superview.bounds.minY
      case .middle:
        y += superview.bounds.midY
      case .bottom:
        y += superview.bounds.maxY + height
    }
    
    let frame = CGRect(x: x, y: y, width: width, height: height)
    self.init(frame: frame)
    self.cgRect = superview.bounds
    self.position = position
    self.size = size
    self.text = text
    self.label.text = text
  }
  
  required init?(coder: NSCoder) {
    fatalError()
  }
  
  override func layoutSubviews() {
    super.layoutSubviews()
    
    layer.cornerRadius = 8
  }
  
  func toastAnimate(_ completion: @escaping (() -> Void)) {
    UIView.animate(withDuration: 0.8, delay: 0, usingSpringWithDamping: 0.8, initialSpringVelocity: 0.5, options: .curveLinear) {
      
      var startPoint: CGFloat = 0
      
      switch self.position {
        case .top:
          startPoint = self.cgRect.minY + 100
        case .middle:
          startPoint = self.cgRect.midY - self.size.height / 2
        case .bottom:
          startPoint = self.cgRect.maxY - 44
      }
      
      self.center.y = startPoint
    } completion: { _ in
      UIView.animate(withDuration: 0.2) {
        self.alpha = 0
      } completion: { _ in
        self.isHidden = true
        completion()
      }
    }
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
