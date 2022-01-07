//
//  TopNavigationView.swift
//  YearEndAssignment
//
//  Created by hoseung Lee on 2022/01/03.
//

import UIKit
import SwiftUI
import Then
import SnapKit

class TopNavigationView: UIView {
  
  let leftBarButton = UIButton().then {
    $0.setImage(UIImage(systemName: "arrow.left"), for: .normal)
    $0.tintColor = .black
  }
  
  let detailButton = UIButton().then {
    let image = UIImage(systemName: "ellipsis")
    $0.tintColor = .systemGray
    $0.setImage(image, for: .normal)
    $0.transform = .init(rotationAngle: .pi / 2)
  }
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    backgroundColor = .white
    viewSetup()
    layoutConfigure()
  }
  
  required init?(coder: NSCoder) {
    fatalError()
  }
  
  override func draw(_ rect: CGRect) {
    super.draw(rect)
    
    guard let context = UIGraphicsGetCurrentContext() else { return }
    
    context.setStrokeColor(UIColor.sesacGray.cgColor)
    context.setLineWidth(1)
    context.move(to: CGPoint(x: bounds.minX, y: bounds.maxY - 1))
    context.addLine(to: CGPoint(x: bounds.maxX, y: bounds.maxY - 1))
    context.strokePath()
  }
  
  private func viewSetup() {
    [leftBarButton, detailButton].forEach {
      addSubview($0)
    }
  }
  
  private func layoutConfigure() {
    leftBarButton.snp.makeConstraints { make in
      make.size.equalTo(33)
      make.leading.bottom.equalToSuperview().inset(4)
    }
    
    detailButton.snp.makeConstraints { make in
      make.size.equalTo(33)
      make.trailing.bottom.equalToSuperview().inset(4)
    }
  }
}

struct TopNavigationViewRP: UIViewRepresentable {
  func makeUIView(context: UIViewRepresentableContext<TopNavigationViewRP>) -> TopNavigationView {
    TopNavigationView()
  }
  
  func updateUIView(_ uiView: TopNavigationView, context: Context) {

  }
}

struct TopNavigationViewRP_Preview: PreviewProvider {
  static var previews: some View {
    TopNavigationViewRP()
      .frame(width: 350, height: 100, alignment: .center)
      .previewLayout(.sizeThatFits)
  }
}
