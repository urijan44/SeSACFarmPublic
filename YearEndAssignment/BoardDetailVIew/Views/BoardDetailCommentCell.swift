//
//  BoardDetailCommentCell.swift
//  YearEndAssignment
//
//  Created by hoseung Lee on 2022/01/03.
//

import UIKit
import SwiftUI
import SnapKit
import Then

class BoardDetailCommentCell: UITableViewCell {

  static let reuseIdentifier = "BoardDetailCommentCell"
  var postId: Int?
  var ownerId: Int?
  var returnCommentInfo: ((String, Int, Int) -> Void)?
  let profileImageView = UIImageView().then {
    $0.contentMode = .scaleAspectFit
    $0.image = UIImage(systemName: "person") ?? UIImage()
    $0.tintColor = .gray
    $0.backgroundColor = .systemGray6
    $0.clipsToBounds = true
  }
  
  let nicknameLabel = UILabel().then {
    $0.font = .systemFont(ofSize: 12, weight: .semibold)
    $0.numberOfLines = 1
  }
  
  let commentLabel = UILabel().then {
    $0.font = .systemFont(ofSize: 13, weight: .regular)
    $0.numberOfLines = 0
  }
  
  let moreButton = UIButton().then {
    let image = UIImage(systemName: "ellipsis")
    $0.tintColor = .systemGray
    $0.setImage(image, for: .normal)
    $0.transform = .init(rotationAngle: .pi / 2)
  }
  
  let likeLabel = UILabel().then {
    $0.font = .systemFont(ofSize: 11, weight: .semibold)
    $0.textColor = .secondaryLabel
    $0.text = "좋아요"
  }
  
  let replyLabel = UILabel().then {
    $0.font = .systemFont(ofSize: 11, weight: .semibold)
    $0.textColor = .secondaryLabel
    $0.text = "답글쓰기"
  }
  
  override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
    super.init(style: style, reuseIdentifier: reuseIdentifier)
    selectionStyle = .none
    contentView.isUserInteractionEnabled = true
    createView()
    layoutConfigure()
  }

  required init?(coder: NSCoder) {
    fatalError()
  }
  
  private func createView() {
    [nicknameLabel, commentLabel, moreButton, likeLabel, replyLabel, profileImageView].forEach {
      addSubview($0)
    }
    
    moreButton.addTarget(self, action: #selector(tappedDetailButton(_:)), for: .touchUpInside)
  }
  
  @objc private func tappedDetailButton(_ sender: UIButton) {
    guard let postId = postId,
    let ownerId = ownerId  else {
      return
    }
    //comment내용과 comment id내보냄
    returnCommentInfo?(commentLabel.text ?? "", postId, ownerId)
  }
  
  private func layoutConfigure() {
    
    profileImageView.snp.makeConstraints { make in
      make.leading.top.equalToSuperview().inset(8)
      make.size.equalTo(27)
    }
    
    nicknameLabel.snp.makeConstraints { make in
      make.leading.equalTo(profileImageView.snp.trailing).offset(6)
      make.top.equalTo(profileImageView.snp.top)
      make.trailing.equalTo(moreButton.snp.leading).inset(4)
    }
    
    commentLabel.snp.makeConstraints { make in
      make.leading.trailing.equalTo(nicknameLabel)
      make.top.equalTo(profileImageView.snp.bottom).offset(8)
      make.bottom.equalTo(likeLabel.snp.top).offset(-8)
    }
    
    moreButton.snp.makeConstraints { make in
      make.size.equalTo(22)
      make.trailing.top.equalToSuperview().inset(8)
    }
    
    likeLabel.snp.makeConstraints { make in
      make.bottom.equalToSuperview().offset(-8)
      make.leading.equalTo(nicknameLabel)
    }
    
    replyLabel.snp.makeConstraints { make in
      make.leading.equalTo(likeLabel.snp.trailing).offset(16)
      make.bottom.equalTo(likeLabel.snp.bottom)
    }
  }
  
  func configure(_ comment: DetailComment) {
    nicknameLabel.text = comment.user.username
    commentLabel.text = comment.comment
    postId = comment.id
    ownerId = comment.user.id
  }
  
  override func layoutSubviews() {
    super.layoutSubviews()
    profileImageView.layer.cornerRadius = 27 / 2
  }
}

struct BoardDetailCommentCellRP: UIViewRepresentable {
  func makeUIView(context: UIViewRepresentableContext<BoardDetailCommentCellRP>) -> BoardDetailCommentCell {
    BoardDetailCommentCell()
  }
  
  func updateUIView(_ uiView: BoardDetailCommentCell, context: Context) {
    uiView.nicknameLabel.text = "테이크아웃좋아매우매우긴이름닉네임이어디까지작성이될까요알아맞춰봅시다."
    uiView.commentLabel.text = "과제가 너무 많아요\n우엥\n우엥\n우엥"
  }
}

struct BoardDetailCommentCellRP_Preview: PreviewProvider {
  static var previews: some View {
    BoardDetailCommentCellRP()
      .frame(width: 350, height: 155, alignment: .center)
      .previewLayout(.sizeThatFits)
  }
}
