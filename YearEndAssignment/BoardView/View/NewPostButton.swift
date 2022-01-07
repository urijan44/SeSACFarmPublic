//
//  NewPostButton.swift
//  YearEndAssignment
//
//  Created by hoseung Lee on 2022/01/03.
//

import UIKit
import SwiftUI

class NewPostButton: UIButton {
  
  override init(frame: CGRect) {
    super.init(frame: frame)

  }
  
  override func draw(_ rect: CGRect) {
    super.draw(rect)
    
    let path = UIBezierPath(ovalIn: rect)
    UIColor.signature.setFill()
    path.fill()
    
    guard let context = UIGraphicsGetCurrentContext() else { return }
    let scale = bounds.maxX * 0.7
    
    let minX = bounds.minX + bounds.maxX - scale
    let midY = bounds.midY
    let maxX = scale
    let midX = bounds.midX
    let minY = bounds.minY + bounds.maxY - scale
    let maxY = scale
    context.setLineCap(.round)
    context.setStrokeColor(UIColor.white.cgColor)
    context.setLineWidth(3)
    context.move(to: CGPoint(x: minX, y: midY))
    context.addLine(to: CGPoint(x: maxX, y: midY))
    
    context.move(to: CGPoint(x: midX, y: minY))
    context.addLine(to: CGPoint(x: midX, y: maxY))

    context.strokePath()
  }
  
  required init?(coder: NSCoder) {
    fatalError()
  }
}



struct NewPostButtonRP: UIViewRepresentable {
  func makeUIView(context: UIViewRepresentableContext<NewPostButtonRP>) -> NewPostButton {
    NewPostButton()
  }
  
  func updateUIView(_ uiView: NewPostButton, context: Context) {

  }
}

struct NewPostButtonRP_Preview: PreviewProvider {
  static var previews: some View {
    NewPostButtonRP()
      .frame(width: 66, height: 66, alignment: .center)
      .previewLayout(.sizeThatFits)
  }
}
