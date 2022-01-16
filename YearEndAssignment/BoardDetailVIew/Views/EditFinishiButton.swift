//
//  EditFinishiButton.swift
//  YearEndAssignment
//
//  Created by hoseung Lee on 2022/01/09.
//

import UIKit

class EditFinishButton: UIControl {
  
  let imageView: UIImageView = {
    let imageView = UIImageView()
    imageView.image = UIImage(systemName: "arrow.right")
    imageView.tintColor = .white
    return imageView
  }()
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    backgroundColor = .clear
    addSubview(imageView)
    
    
    imageView.translatesAutoresizingMaskIntoConstraints = false
    NSLayoutConstraint.activate([
      imageView.centerXAnchor.constraint(equalTo: centerXAnchor),
      imageView.centerYAnchor.constraint(equalTo: centerYAnchor),
      imageView.widthAnchor.constraint(equalTo: widthAnchor, multiplier: 0.8),
      imageView.heightAnchor.constraint(equalTo: widthAnchor, multiplier: 0.8)
    ])
  }
  
  required init?(coder: NSCoder) {
    fatalError()
  }
  
  override func draw(_ rect: CGRect) {
    super.draw(rect)
    
    let path = UIBezierPath(ovalIn: rect)
    UIColor.signature.setFill()
    path.fill()
  }
}
