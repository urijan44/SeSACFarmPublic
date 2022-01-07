//
//  NewBoardMainView.swift
//  YearEndAssignment
//
//  Created by hoseung Lee on 2022/01/03.
//

import UIKit
import Then
import SnapKit

class NewBoardMainView: UIView {
  
  let textView = UITextView().then {
    $0.font = .systemFont(ofSize: 13, weight: .medium)
    $0.textColor = .black
  }
  
  let cancel = UIBarButtonItem(image: UIImage(systemName: "xmark"), style: .plain, target: self, action: nil)
  let complete = UIBarButtonItem(title: "완료", style: .done, target: self, action: nil)
  override init(frame: CGRect) {
    super.init(frame: frame)
    
    addSubview(textView)
    textView.snp.makeConstraints { make in
      make.edges.equalToSuperview().inset(8)
    }
  }
  
  required init?(coder: NSCoder) {
    fatalError()
  }
}
