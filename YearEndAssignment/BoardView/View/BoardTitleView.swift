//
//  BoardTitleView.swift
//  YearEndAssignment
//
//  Created by hoseung Lee on 2022/01/03.
//

import UIKit
import SnapKit

class BoardTitleView: UIView {
  
  let titleLabel: UILabel = {
    let label = UILabel()
    label.text = "새싹농장"
    label.font = .systemFont(ofSize: 22, weight: .bold)
    return label
  }()
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    addSubview(titleLabel)
    backgroundColor = .white
    titleLabel.snp.makeConstraints { make in
      make.centerY.equalToSuperview()
      make.leading.trailing.equalToSuperview().inset(8)
    }
    
    
  }
  
  required init?(coder: NSCoder) {
    fatalError()
  }
}
