//
//  BoardMainView.swift
//  YearEndAssignment
//
//  Created by hoseung Lee on 2022/01/05.
//

import UIKit
import Then

class BoardMainView: UIView {
  
  enum Section {
    case main
  }
  
  let tableView = UITableView()
  let boardTitleView = BoardTitleView()
  let newPostButton: NewPostButton = {
    let button = NewPostButton()
    button.layer.shadowRadius = 2
    button.layer.shadowOffset = .init(width: 0, height: 1)
    button.layer.shadowOpacity = 0.3
    return button
  }()
  let preferenceButton = UIButton().then {
    $0.setImage(UIImage(systemName: "gearshape.fill"), for: .normal)
    $0.tintColor = .black
  }
  
  let refresh = UIRefreshControl()
  var dataSource: UITableViewDiffableDataSource<Section, BoardElement>!
  let viewModel = BoardViewModel()
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    createView()
    layoutConfigure()
    tableViewConfigure()

  }
  
  required init?(coder: NSCoder) {
    fatalError()
  }
  
  private func createView() {
    addSubview(boardTitleView)
    addSubview(tableView)
    addSubview(newPostButton)
    tableView.refreshControl = self.refresh
    boardTitleView.addSubview(preferenceButton)
  }
  
  private func layoutConfigure() {

    boardTitleView.snp.makeConstraints { make in
      make.leading.trailing.equalToSuperview()
      make.top.equalTo(safeAreaLayoutGuide.snp.top)
      make.height.equalTo(44)
    }
    
    tableView.snp.makeConstraints { make in
      make.leading.trailing.bottom.equalToSuperview()
      make.top.equalTo(boardTitleView.snp.bottom)
    }
    
    newPostButton.snp.makeConstraints { make in
      make.width.height.equalTo(55)
      make.trailing.equalToSuperview().inset(32)
      make.bottom.equalToSuperview().inset(55)
    }
    
    preferenceButton.snp.makeConstraints { make in
      make.size.equalTo(27)
      make.top.trailing.equalToSuperview().inset(8)
    }
  }
  
  private func tableViewConfigure() {
    tableView.register(BoardTableViewCell.self, forCellReuseIdentifier: BoardTableViewCell.reuseIdentifier)
    tableView.separatorStyle = .none
    configureDataSource()
    configureSnapshot(posts: [])
  }
  
  func configureDataSource() {
    dataSource = UITableViewDiffableDataSource<Section, BoardElement>(tableView: tableView) { tableView, indexPath, board -> UITableViewCell? in
      
      guard let cell = tableView.dequeueReusableCell(withIdentifier: BoardTableViewCell.reuseIdentifier, for: indexPath)
              as? BoardTableViewCell else { fatalError() }
      
      cell.configure(board)
      
      return cell
    }
  }
  
  func configureSnapshot(posts: [BoardElement]) {
    var snapshot = NSDiffableDataSourceSnapshot<Section, BoardElement>()
    snapshot.appendSections([.main])
    snapshot.appendItems(posts, toSection: .main)
    
    dataSource.apply(snapshot, animatingDifferences: true)
  }
}
