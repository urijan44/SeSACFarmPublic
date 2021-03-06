//
//  BoardTableViewCell.swift
//  YearEndAssignment
//
//  Created by hoseung Lee on 2022/01/02.
//

import UIKit
import SwiftUI
import SnapKit

class BoardTableViewCell: UITableViewCell {
  
  static let reuseIdentifier = "BoardTableViewCell"
  
  let nickNameLabel = NicknameFieldView()
  
  let contentLabel: UILabel = {
    let label = UILabel()
    label.numberOfLines = 4
    label.font = .systemFont(ofSize: 14, weight: .regular)
    return label
  }()
  
  let datelabel: UILabel = {
    let label = UILabel()
    label.font = .systemFont(ofSize: 11, weight: .medium)
    label.textColor = .secondaryLabel
    return label
  }()
  
  let divider: UIView = {
    let view = UIView()
    view.backgroundColor = .systemGray6
    return view
  }()
  
  let commentPreview = WriteCommentView()
  
  let containerView: UIView = {
    let view = UIView()
    view.backgroundColor = .white
    return view
  }()
  
  let separatorView: UIView = {
    let view = UIView()
    view.backgroundColor = .systemGray6
    return view
  }()
  
  override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
    super.init(style: style, reuseIdentifier: reuseIdentifier)
    createView()
    layoutConfigure()
  }
  
  required init?(coder: NSCoder) {
    fatalError()
  }
  
  private func createView() {
    addSubview(separatorView)
    addSubview(containerView)
    [nickNameLabel, contentLabel, datelabel, divider, commentPreview].forEach {
      containerView.addSubview($0)
    }
    
    
  }
  
  private func layoutConfigure() {
    
    containerView.snp.makeConstraints { make in
      make.leading.trailing.equalToSuperview()
      make.top.equalTo(separatorView.snp.top)
      make.bottom.equalTo(separatorView.snp.bottom).inset(6)
    }
    
    separatorView.snp.makeConstraints { make in
      make.edges.equalToSuperview()
    }
    
    nickNameLabel.snp.makeConstraints { make in
      make.leading.trailing.equalToSuperview().inset(8)
      make.top.equalTo(separatorView.snp.top).inset(16)
    }
    
    commentPreview.snp.makeConstraints { make in
      make.leading.trailing.equalToSuperview().inset(8)
      make.height.equalTo(44)
      make.bottom.equalToSuperview()
    }
    
    divider.snp.makeConstraints { make in
      make.width.equalToSuperview()
      make.height.equalTo(1)
      make.bottom.equalTo(commentPreview.snp.top)
    }
    
    datelabel.snp.makeConstraints { make in
      make.leading.trailing.equalToSuperview().inset(8)
      make.bottom.equalTo(divider.snp.top).offset(-16)
    }
    
    contentLabel.snp.makeConstraints { make in
      make.leading.trailing.equalToSuperview().inset(8)
      make.top.equalTo(nickNameLabel.snp.bottom).offset(16)
      make.bottom.equalTo(datelabel.snp.top).offset(-16)
    }
  }
  
  func configure(_ board: BoardElement) {
    nickNameLabel.text = board.user.username
    contentLabel.text = board.text
    datelabel.text = board.updatedAt.dateConvert.mmDD
    commentPreview.commentCount = board.comments.count
  }
  
}

struct BoardCellRP: UIViewRepresentable {
  func makeUIView(context: UIViewRepresentableContext<BoardCellRP>) -> BoardTableViewCell {
    BoardTableViewCell()
  }
  
  func updateUIView(_ uiView: BoardTableViewCell, context: Context) {
    uiView.nickNameLabel.text = "???????????????"
    uiView.datelabel.text = "12/08"
    uiView.contentLabel.text = "??????????????????! ????????? ?????? ????????? ????????? ????????? ?????? ????????? ??? ???????????? ????????? ????????? ????????? ????????? ?????? ???????????? ??????????????? ????????? ??????????????????, ?????? ?????? ??????????????? ????????? ?????????! ????????? ????????? ???????????? ?????? ??????"
  }
}

struct BoardCell_Previews: PreviewProvider {
  static var previews: some View {
    BoardCellRP()
      .frame(width: 350, height: 200, alignment: .center)
      .previewLayout(.sizeThatFits)
  }
}
