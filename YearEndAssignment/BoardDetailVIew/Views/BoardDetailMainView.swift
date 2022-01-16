//
//  BoardDetailMainView.swift
//  YearEndAssignment
//
//  Created by hoseung Lee on 2022/01/06.
//

import UIKit
import RxSwift
import SnapKit
import Then

class BoardDetailMainView: UIView {
  enum Section {
    case main
    case comment
  }
  
  let tableView = UITableView()
  let bottomBar = NewCommentInputField()
  let topBar = TopNavigationView()
  var bottomConstraint: Constraint? = nil
  var lineBottomConstraint: Constraint? = nil
  var returnedId: ((String, Int, Int) -> Void)?
  
  let lineView = UIView().then {
    $0.backgroundColor = .sesacGray
  }
  
//  let deleteMenu = UIAction(title: "삭제하기", attributes: .destructive) { _ in
//
//  }
//
//  let editMenu = UIAction(title: "수정하기") { _ in
//
//  }
  
  let notificationCenter = NotificationCenter.default
  
  var dataSource: UITableViewDiffableDataSource<Section, AnyHashable>!
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    viewSetup()
    layoutConfigure()
    tableViewSetup()
    notificationSetup()
    
//    topBar.detailButton.menu = UIMenu(title: "", children: [editMenu, deleteMenu])
//    topBar.detailButton.showsMenuAsPrimaryAction = true
  }
  
  required init?(coder: NSCoder) {
    fatalError()
  }
  
  private func viewSetup() {
    addSubview(bottomBar)
    addSubview(tableView)
    addSubview(topBar)
    addSubview(lineView)
  }
  
  private func layoutConfigure() {
    topBar.snp.makeConstraints { make in
      make.leading.trailing.equalToSuperview()
      make.top.equalTo(safeAreaLayoutGuide.snp.top)
      make.height.equalTo(44)
    }
    
    bottomBar.snp.makeConstraints { make in
      make.leading.trailing.equalToSuperview()
      bottomConstraint = make.bottom.equalTo(safeAreaLayoutGuide.snp.bottom).constraint
      make.height.equalTo(44)
    }
    
    bottomBar.layer.cornerRadius = 22
    bottomBar.clipsToBounds = true
    
    tableView.snp.makeConstraints { make in
      make.leading.trailing.equalToSuperview()
      make.top.equalTo(topBar.snp.bottom)
      make.bottom.equalTo(bottomBar.snp.top)
    }
  }
  
  private func tableViewSetup() {
    tableView.register(BoardDetailMainCotentCell.self, forCellReuseIdentifier: BoardDetailMainCotentCell.reuseIdentifier)
    tableView.register(BoardDetailCommentCell.self, forCellReuseIdentifier: BoardDetailCommentCell.reuseIdentifier)
    tableView.separatorStyle = .none
    tableView.keyboardDismissMode = .onDrag
    configureDataSource()
    configureSnapshot(board: nil, comments: nil)
  }
  
  private func notificationSetup() {
    
//    notificationCenter.addObserver(forName: UIResponder.keyboardWillChangeFrameNotification,
//                                   object: nil, queue: .main) { (notification) in
//                                    self.handleKeyboard(notification: notification) }
//    notificationCenter.addObserver(forName: UIResponder.keyboardWillHideNotification,
//                                   object: nil, queue: .main) { (notification) in
//                                    self.handleKeyboard(notification: notification) }
    notificationCenter.addObserver(self, selector: #selector(handleKeyboard(notification:)), name: UIResponder.keyboardWillChangeFrameNotification, object: nil)
    notificationCenter.addObserver(self, selector: #selector(handleKeyboard(notification:)), name: UIResponder.keyboardWillHideNotification, object: nil)
    
  }
  
  func notificationRemove() {
    notificationCenter.removeObserver(self, name: UIResponder.keyboardWillChangeFrameNotification, object: nil)
    notificationCenter.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
  }

  
  @objc private func handleKeyboard(notification: Notification) {
    print(#function)
    // 1
    guard notification.name == UIResponder.keyboardWillChangeFrameNotification else {
      bottomConstraint?.update(offset: 0)
      lineBottomConstraint?.update(offset: 0)
      layoutIfNeeded()
      return
    }
    
    guard
      let info = notification.userInfo,
      let keyboardFrame = info[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue
      else {
        return
    }
    // 2
    let keyboardHeight = keyboardFrame.cgRectValue.size.height
    UIView.animate(withDuration: 0.1, animations: { () -> Void in
      
      self.bottomConstraint?.update(offset: -keyboardHeight + 22)
      self.lineBottomConstraint?.update(offset: -keyboardHeight)
      
      self.layoutIfNeeded()
    })
  }
  
  private func configureDataSource() {
    dataSource = UITableViewDiffableDataSource<Section, AnyHashable>(tableView: tableView) { (tableView, indexPath, itemIdentifier) -> UITableViewCell? in
      
      if indexPath.section == 0 {
        guard
          let cell = tableView.dequeueReusableCell(withIdentifier: BoardDetailMainCotentCell.reuseIdentifier, for: indexPath)
            as? BoardDetailMainCotentCell,
          let board = itemIdentifier as? BoardElement else { fatalError() }
        
        cell.configure(board)
        return cell
      } else {
        guard
          let cell = tableView.dequeueReusableCell(withIdentifier: BoardDetailCommentCell.reuseIdentifier, for: indexPath)
            as? BoardDetailCommentCell,
          let comment = itemIdentifier as? DetailComment else { fatalError() }
        cell.returnCommentInfo = self.returnCommentInfo
        cell.configure(comment)
        return cell
      }
    }
  }
  
  func returnCommentInfo(text: String, id: Int, ownerId: Int) {
    returnedId?(text, id, ownerId)
  }
  
  func configureSnapshot(board: BoardElement?, comments: [DetailComment]?, animatingDiffrerences: Bool = true) {
    var snapshot = NSDiffableDataSourceSnapshot<Section, AnyHashable>()
    snapshot.appendSections([.main, .comment])
    if let board = board {
      snapshot.appendItems([board], toSection: .main)
    }
    
    if let comments = comments {
      snapshot.appendItems(comments, toSection: .comment)
    }
    
    dataSource.apply(snapshot, animatingDifferences: animatingDiffrerences)
  }
}
