//
//  BoardDetailMainContentCell.swift
//  YearEndAssignment
//
//  Created by hoseung Lee on 2022/01/03.
//

import UIKit
import SwiftUI
import SnapKit
import Then

class BoardDetailMainCotentCell: UITableViewCell {
  
  static let reuseIdentifier = "BoardDetailMainCotentCell"
  
  let writerView = WriterView()
  let containerView = UIView().then {
    $0.backgroundColor = .white
  }
  
  let contentLabel = UILabel().then {
    $0.numberOfLines = 0
    $0.font = .systemFont(ofSize: 14, weight: .regular)
  }
  let commentInfoView = WriteCommentView()
  
  
  let divider1 = UIView().then {
    $0.backgroundColor = .systemGray6
  }
  
  let divider2 = UIView().then {
    $0.backgroundColor = .systemGray6
  }
  
  let divider3 = UIView().then {
    $0.backgroundColor = .systemGray6
  }
  
  let divider4 = UIView().then {
    $0.backgroundColor = .systemGray6
  }
  
  override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
    super.init(style: style, reuseIdentifier: reuseIdentifier)
    createView()
    layoutConfigure()
  }
  
  required init?(coder: NSCoder) {
    fatalError()
  }
  
  private func createView() {
    addSubview(containerView)
    [writerView, contentLabel, commentInfoView, divider1, divider2, divider3, divider4].forEach {
      containerView.addSubview($0)
    }
  }
  
  private func layoutConfigure() {
    containerView.snp.makeConstraints { make in
      make.edges.equalToSuperview()
    }
    
    writerView.snp.makeConstraints { make in
      make.leading.trailing.equalToSuperview()
      make.top.equalToSuperview().offset(8)
      make.height.equalTo(44)
    }
    
    divider1.snp.makeConstraints { make in
      make.leading.trailing.equalToSuperview()
      make.height.equalTo(1)
      make.top.equalTo(writerView.snp.bottom).offset(16)
    }
    
    contentLabel.snp.makeConstraints { make in
      make.leading.trailing.equalToSuperview().offset(8)
      make.top.equalTo(divider1.snp.bottom).offset(16)
      make.bottom.equalTo(divider2.snp.top).offset(-16)
    }
    
    divider2.snp.makeConstraints { make in
      make.leading.trailing.equalToSuperview()
      make.height.equalTo(1)
      make.bottom.equalTo(commentInfoView.snp.top).offset(-8)
    }
    
    commentInfoView.snp.makeConstraints { make in
      make.leading.trailing.equalToSuperview().offset(8)
      make.height.equalTo(22)
      make.bottom.equalTo(divider3.snp.top).offset(-8)
    }
    
    divider3.snp.makeConstraints { make in
      make.leading.trailing.equalToSuperview()
      make.height.equalTo(1)
      make.bottom.equalToSuperview().offset(-8)
    }
  }
  
  func configure(_ board: BoardElement) {
    writerView.nicknameLabel.text = board.user.username
    writerView.dateLabel.text = board.updatedAt.dateConvert.mmDD
    contentLabel.text = board.text
    commentInfoView.commentCount = board.comments.count
  }
}

struct BoardDetailMainCotentViewRP: UIViewRepresentable {
  func makeUIView(context: UIViewRepresentableContext<BoardDetailMainCotentViewRP>) -> BoardDetailMainCotentCell {
    BoardDetailMainCotentCell()
  }
  
  func updateUIView(_ uiView: BoardDetailMainCotentCell, context: Context) {
    uiView.writerView.nicknameLabel.text = "당근당근당근"
    uiView.writerView.dateLabel.text = "02/08"
    uiView.contentLabel.text = "코로나로 인해서 일자리도 많이 줄고 취업하기도 어렵구 쓸쓸하네요오\n\n\n\n\n"
  }
}

struct BoardDetailMainCotentViewRP_Preview: PreviewProvider {
  static var previews: some View {
    BoardDetailMainCotentViewRP()
      .previewLayout(.sizeThatFits)
  }
}
