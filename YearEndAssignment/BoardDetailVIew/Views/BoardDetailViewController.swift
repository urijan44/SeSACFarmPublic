//
//  BoardDetailViewController.swift
//  YearEndAssignment
//
//  Created by hoseung Lee on 2022/01/03.
//

import UIKit
import RxSwift
import RxCocoa
import SnapKit
import Then

class BoardDetailViewController: UIViewController {
  
  let mainView = BoardDetailMainView()
  let viewModel = DetailViewModel()
  let bag = DisposeBag()
  override func loadView() {
    view = mainView
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    view.backgroundColor = .white
    mainView.tableView.delegate = self
    mainView.returnedId = commentId
    targetConnect()
  }
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    commentInitLoad()
    updateUI()
  }
  
  private func commentInitLoad() {
    viewModel.fetchDetailComments(postNumber: viewModel.post?.id ?? -1) { error in
      if let error = error {
        print(error)
      }
    }
  }
  
  private func updateUI(animatingDiffrerences: Bool = true) {
    
    viewModel.comments.subscribe(onNext: {
      self.mainView.configureSnapshot(board: self.viewModel.post, comments: $0, animatingDiffrerences: animatingDiffrerences)
    })
      .disposed(by: bag)
  }
  
  private func targetConnect() {
    mainView.topBar.leftBarButton.addTarget(self, action: #selector(popThisView), for: .touchUpInside)
    mainView.bottomBar.textField.rx.text
      .orEmpty
      .subscribe(onNext: {
        self.viewModel.newComment.accept($0)
      })
      .disposed(by: bag)
    
    mainView.bottomBar.textField.rx
      .controlEvent(.editingDidEndOnExit)
      .subscribe(onNext: { _ in
        self.viewModel.newCommentPost()
          .subscribe(onSuccess: { _ in
            self.commentToast(text: "댓글을 작성했습니다✎")
              .subscribe()
              .disposed(by: self.bag)
          }, onFailure: { error in
            DispatchQueue.main.async {
              self.alert(title: error.localizedDescription)
                .subscribe()
                .disposed(by: self.bag)
            }
          })
          .disposed(by: self.bag)
      })
      .disposed(by: bag)
      
    viewModel.newComment
      .bind(to: mainView.bottomBar.textField.rx.text)
      .disposed(by: bag)
    
    
    mainView.topBar.detailButton.rx.tap.bind(onNext: {
      self.showMenu()
    })
      .disposed(by: bag)
    
    
  }
  
  private func commentId(comment: String, id: Int, ownerId: Int) {
    viewModel.selectedCommentId = id
    viewModel.selectedCommentText = comment
    viewModel.selectedCommentOwnerId = ownerId
    commentMenu()
  }
  
  private func showMenu() {
    
    let alert = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
    if viewModel.boardOwnership {
      alert.addAction(.init(title: "수정하기", style: .default) { _ in
        let editBoardView = NewBoardViewController()
        editBoardView.worktype = .edit
        editBoardView.viewModel.postId = self.viewModel.post?.id
        editBoardView.mainView.textView.text = self.viewModel.post?.text ?? ""
        editBoardView.viewModel.viewDismiss
          .filter{$0 == true}
          .subscribe(onNext: { _ in
            self.viewModel.post?.text = editBoardView.viewModel.text.value
            DispatchQueue.main.async {
              editBoardView.navigationController?.popViewController(animated: true)
              self.updateUI(animatingDiffrerences: false)
            }
          })
          .disposed(by: self.bag)
        self.navigationController?.pushViewController(editBoardView, animated: true)
      })
      alert.addAction(.init(title: "삭제하기", style: .destructive) { _ in
        self.viewModel.deletePost()
          .subscribe(onSuccess: { _ in
            self.viewModel.viewDismiss.accept(true)
          }, onFailure: { error in
            self.alert(title: error.localizedDescription)
              .subscribe()
              .disposed(by: self.bag)
          })
          .disposed(by: self.bag)
      })
    }
    alert.addAction(.init(title: "닫기", style: .cancel, handler: nil))
    
    present(alert, animated: true)
    
  }
  
  private func commentMenu() {
    
    let alert = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
    if viewModel.commentOwnership {
      alert.addAction(.init(title: "수정하기", style: .default) { _ in
        let controller = CommentEditViewController()
        controller.viewModel.commentId.accept(self.viewModel.selectedCommentId)
        controller.viewModel.text.accept(self.viewModel.selectedCommentText)
        guard let postId = self.viewModel.post?.id else { return }
        controller.viewModel.postId.accept(postId)
        self.navigationController?.pushViewController(controller, animated: true)
      })
      alert.addAction(.init(title: "삭제하기", style: .destructive) { _ in
        self.viewModel.deleteComment()
          .subscribe(onSuccess: {
            self.commentToast(text: "댓글을 삭제했습니다.")
              .observe(on: MainScheduler.instance)
              .subscribe(onDisposed: {
                self.commentInitLoad()
                self.updateUI()
              })
              .disposed(by: self.bag)
          }, onFailure: {
            self.alert(title: $0.localizedDescription)
              .observe(on: MainScheduler.instance)
              .subscribe()
              .disposed(by: self.bag)
          })
          .disposed(by: self.bag)
      })
    }
      
    alert.addAction(.init(title: "닫기", style: .cancel, handler: nil))
    
    present(alert, animated: true)
  }
  
  
  override func viewWillDisappear(_ animated: Bool) {
    super.viewWillDisappear(animated)
  }

  @objc private func popThisView() {
    navigationController?.popViewController(animated: true)
  }
}

extension BoardDetailViewController: UITableViewDelegate {
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    tableView.deselectRow(at: indexPath, animated: true)
  }
}
