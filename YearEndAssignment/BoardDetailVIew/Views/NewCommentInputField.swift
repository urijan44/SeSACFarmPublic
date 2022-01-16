//
//  NewCommentView.swift
//  YearEndAssignment
//
//  Created by hoseung Lee on 2022/01/03.
//

import UIKit
import SwiftUI
import SnapKit

class NewCommentInputField: UIView {
  
  let containerView = UIView().then {
    $0.backgroundColor = .white
  }
  
  let textContainerView = UIView().then {
    $0.backgroundColor = .sesacGray
  }
  
  let textField = UITextField().then {
    $0.placeholder = "댓글을 입력해주세요"
    $0.font = .systemFont(ofSize: 13, weight: .medium)
    $0.enablesReturnKeyAutomatically = true
    $0.textColor = .black
  }
  
  let lineView = UIView().then {
    $0.backgroundColor = .sesacGray
  }
  
  let editFinishButton = EditFinishButton().then {
    $0.alpha = 0.0
    $0.isHidden = true
  }
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    backgroundColor = .sesacGray
    addSubview(containerView)
    addSubview(lineView)
    containerView.addSubview(textContainerView)
    textContainerView.addSubview(textField)
    textContainerView.addSubview(editFinishButton)

    lineView.snp.makeConstraints { make in
      make.leading.top.trailing.equalToSuperview()
      make.height.equalTo(1)
    }
      
    containerView.snp.makeConstraints { make in
      make.edges.equalToSuperview()
    }
    
    textContainerView.snp.makeConstraints { make in
      make.top.bottom.equalToSuperview().inset(4)
      make.leading.trailing.equalToSuperview().inset(12)
    }
    
    textField.snp.makeConstraints { make in
      make.centerY.equalToSuperview()
      make.leading.equalToSuperview().inset(12)
      make.trailing.equalTo(editFinishButton.snp.leading).inset(-12)
    }
    
    textField.backgroundColor = .sesacGray
    textField.delegate = self
    textContainerView.layer.cornerRadius = 40 / 2
    textContainerView.clipsToBounds = true
    
    editFinishButton.snp.makeConstraints { make in
      make.size.equalTo(textContainerView.snp.height).multipliedBy(0.8)
      make.centerY.equalToSuperview()
      make.trailing.equalToSuperview().offset(-6)
    }
    
    
    textField.addTarget(self, action: #selector(textFieldBeginEditing(_:)), for: .editingChanged)
  }
  
  required init?(coder: NSCoder) {
    fatalError()
  }
  
  override func layoutSubviews() {
    super.layoutSubviews()
    
    //? 뷰 컨트롤러에서 사라짐? 레이어 디버그에서는 보임
//    clipsToBounds = true
//    layer.cornerRadius = frame.midY
  }
  
  override func draw(_ rect: CGRect) {
//    super.draw(rect)
//
//    guard let context = UIGraphicsGetCurrentContext() else { return }
//    context.setStrokeColor(UIColor.systemRed.cgColor)
//    context.setLineWidth(1)
//    context.move(to: CGPoint(x: bounds.minX, y: bounds.midY))
//    context.addLine(to: CGPoint(x: bounds.maxX, y: bounds.midY))
//    context.strokePath()
  }
  
  
  @objc func textFieldBeginEditing(_ textFiend: UITextField) {
    guard let text = textField.text else { return }
    if text.count > 0 && editFinishButton.isHidden {
      showButton()
    } else if text.isEmpty {
      hideButton()
    }
  }
  
  private func showButton() {
    self.editFinishButton.isHidden = false
    UIView.animate(withDuration: 0.3) {
      self.editFinishButton.alpha = 1.0
    }
  }
  
  private func hideButton() {
    UIView.animate(withDuration: 0.3) {
      self.editFinishButton.alpha = 0.0
    } completion: { _ in
      self.editFinishButton.isHidden = true
    }
  }
}

extension NewCommentInputField: UITextFieldDelegate {
  
  func textFieldDidEndEditing(_ textField: UITextField) {
    hideButton()
  }
}


struct NewCommentViewRP: UIViewRepresentable {
  func makeUIView(context: UIViewRepresentableContext<NewCommentViewRP>) -> NewCommentInputField {
    NewCommentInputField()
  }
  
  func updateUIView(_ uiView: NewCommentInputField, context: Context) {

  }
}

struct NewCommentViewRP_Preview: PreviewProvider {
  static var previews: some View {
    NewCommentViewRP()
      .frame(width: 350, height: 48, alignment: .center)
      .previewLayout(.sizeThatFits)
  }
}
