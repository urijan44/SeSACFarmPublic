//
//  CommentEditView.swift
//  YearEndAssignment
//
//  Created by hoseung Lee on 2022/01/06.
//

import UIKit
import Then
import SnapKit

class CommentEditView: UIView {
  let textView = UITextView().then {
    $0.font = .systemFont(ofSize: 13, weight: .medium)
    $0.textColor = .black
    $0.layer.cornerRadius = 8
    $0.layer.borderColor = UIColor.sesacGray.cgColor
    $0.layer.borderWidth = 1.5
  }
  
  let navigationBar = UINavigationBar().then {
    $0.shadowImage = UIImage()
    $0.setBackgroundImage(UIImage(), for: .default)
  }
  
  let cancel = UIBarButtonItem(image: UIImage(systemName: "arrow.left"), style: .plain, target: self, action: nil)
  let complete = UIBarButtonItem(title: "완료", style: .done, target: self, action: nil)
  let navBarItem = UINavigationItem(title: "댓글 수정")
  override init(frame: CGRect) {
    super.init(frame: frame)
    addSubview(navigationBar)
    addSubview(textView)
    
    navigationBar.items = [navBarItem]
    navBarItem.leftBarButtonItem = cancel
    navBarItem.rightBarButtonItem = complete
    navigationBar.tintColor = .black
    
    textView.snp.makeConstraints { make in
      make.leading.trailing.equalTo(safeAreaLayoutGuide).inset(16)
      make.top.equalTo(navigationBar.snp.bottom).offset(8)
      make.height.equalTo(240)
    }
    
    navigationBar.snp.makeConstraints { make in
      make.leading.trailing.equalToSuperview()
      make.top.equalTo(safeAreaLayoutGuide.snp.top)
      make.height.equalTo(44)
    }
  }
  
  required init?(coder: NSCoder) {
    fatalError()
  }
}
