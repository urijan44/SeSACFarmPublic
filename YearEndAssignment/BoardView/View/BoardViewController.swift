//
//  BoardViewController.swift
//  YearEndAssignment
//
//  Created by hoseung Lee on 2022/01/03.
//

import UIKit
import RxSwift
import RxCocoa

class BoardViewController: UIViewController {
  
  let mainView = BoardMainView()
  let viewModel = BoardViewModel()
  let bag = DisposeBag()
  override func loadView() {
    view = mainView
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    view.backgroundColor = .white
    navigationConfigure()
    mainView.newPostButton.addTarget(self, action: #selector(writeNewBoard(_:)), for: .touchUpInside)
    subscribes()
    bindSetup()
  }
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    fetchBoard()
  }
  
  
  func fetchBoard() {
    viewModel.fetchBoardElement { error in
      if let error = error {
        self.alert(title: error.localizedDescription)
          .subscribe()
          .disposed(by: self.bag)
        return
      }
    }
  }
  
  private func subscribes() {
    viewModel.posts.subscribe(onNext: {
      self.mainView.configureSnapshot(posts: $0.reversed())
    })
      .disposed(by: bag)
     
    //MARK: - 아래로 잡아 당기면 포스트 다시 받아오기
    mainView.refresh
      .rx
      .controlEvent(.valueChanged)
      .subscribe(onNext: {
        let current = self.viewModel.page.value
        self.viewModel.page.accept(current + 10)
        self.fetchBoard()
      })
      .disposed(by: bag)
    
    viewModel.posts.subscribe(onNext: { _ in
      self.mainView.refresh.endRefreshing()
    })
      .disposed(by: bag)

    //MARK: - 테이블 아래로 스크롤 하면 페이지네이션
    mainView.tableView.rx
      .contentOffset
      .filter{$0.y > self.mainView.tableView.contentSize.height - self.mainView.tableView.frame.height}
      .debounce(RxTimeInterval.milliseconds(100), scheduler: MainScheduler.instance)
      .subscribe(onNext: { _ in
        let current = self.viewModel.page.value
        self.viewModel.page.accept(current + 10)
        self.fetchBoard()
      })
      .disposed(by: bag)
  }
  
  private func bindSetup() {
    
    //MARK: - 보드 디테일
    //삭제하면 나오고 토스트 출력
    mainView.tableView
      .rx
      .itemSelected
      .subscribe(onNext: { [unowned self] in
        mainView.tableView.deselectRow(at: $0, animated: true)
        let boardDetailVC = BoardDetailViewController()
        let viewModel = DetailViewModel(coordinator: boardDetailVC)
        boardDetailVC.viewModel = viewModel
        let selectedPost = mainView.dataSource.itemIdentifier(for: $0)
        boardDetailVC.viewModel.post = selectedPost
        boardDetailVC.viewModel.viewDismiss
          .filter{$0 == true}
          .subscribe(onNext: { _ in
            DispatchQueue.main.async {
              boardDetailVC.navigationController?.popViewController(animated: true)
              toast(text: "게시글을 삭제했습니다.", size: CGSize(width: 150, height: 44))
                .subscribe(onDisposed: {
                  fetchBoard()
                })
                .disposed(by: bag)
            }
          })
          .disposed(by: bag)
        navigationController?.pushViewController(boardDetailVC, animated: true)
      })
      .disposed(by: bag)
    
    //MARK: - 암호 수정
    mainView.preferenceButton.rx
      .tap
      .subscribe(onNext: {
        let controller = PreferenceViewController()
        controller.viewModel.viewDismiss
          .filter{$0 == true}
          .subscribe(onNext: { _ in
            DispatchQueue.main.async {
              controller.navigationController?.popViewController(animated: true)
            }
        })
          .disposed(by: self.bag)
        self.navigationController?.pushViewController(controller, animated: true)
      })
      .disposed(by: bag)
  }
  
  override func viewWillDisappear(_ animated: Bool) {
    super.viewWillDisappear(animated)
  }
  
  private func navigationConfigure() {
    navigationController?.isNavigationBarHidden = true
  }
  
  @objc func writeNewBoard(_ sender: UIButton) {
    let viewModel = NewPostViewModel()
    
    let controller = NewBoardViewController(
      viewModel: viewModel,
      worktype: .new,
      postText: "")
    controller.viewModel.viewDismiss
      .filter{$0 == true}
      .subscribe(onNext: { _ in
        DispatchQueue.main.async {
          controller.navigationController?.popViewController(animated: true)
        }
    })
      .disposed(by: bag)
    navigationController?.pushViewController(controller, animated: true)
  }
  
}
