//
//  WriteCommentView.swift
//  YearEndAssignment
//
//  Created by hoseung Lee on 2022/01/02.
//

import UIKit
import SwiftUI

class WriteCommentView: UIView {
  
  let imageView: UIImageView = {
    let imageView = UIImageView()
    guard let uiImage = UIImage(systemName: "message"), let cgImage = uiImage.cgImage else { return UIImageView() }
    let image = UIImage(cgImage: cgImage, scale: 1, orientation: .upMirrored).withTintColor(.secondaryLabel)
    imageView.image = image
    return imageView
  }()
  
  let writeCommentUILabel: UILabel = {
    let label = UILabel()
    label.text = "댓글쓰기"
    label.font = .systemFont(ofSize: 14, weight: .semibold)
    label.textColor = .secondaryLabel
    return label
  }()
  
  var commentCount: Int = 0 {
    didSet {
      writeCommentUILabel.text = commentCount > 0 ? "댓글 \(commentCount)" : "댓글쓰기"
    }
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
    [imageView, writeCommentUILabel].forEach {
      addSubview($0)
    }
  }
  
  private func layoutConfigure() {
    imageView.snp.makeConstraints { make in
      make.width.height.equalTo(14)
      make.centerY.equalToSuperview()
      make.leading.equalToSuperview()
    }
    
    writeCommentUILabel.snp.makeConstraints { make in
      make.leading.equalTo(imageView.snp.trailing).offset(5)
      make.trailing.equalToSuperview()
      make.centerY.equalToSuperview()
    }
  }
}

struct WriteCommentViewRP: UIViewRepresentable {
  func makeUIView(context: UIViewRepresentableContext<WriteCommentViewRP>) -> WriteCommentView {
    WriteCommentView()
  }
  
  func updateUIView(_ uiView: WriteCommentView, context: Context) {
    
  }
}

struct WriteCommentViewRP_Previews: PreviewProvider {
  static var previews: some View {
    WriteCommentViewRP()
      .previewLayout(.sizeThatFits)
  }
}
