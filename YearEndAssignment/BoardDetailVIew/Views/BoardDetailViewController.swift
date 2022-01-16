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

class BoardDetailViewController: NiblessViewController {
  
  let mainView = BoardDetailMainView()
  var viewModel: DetailViewModel!
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
    updateUI(animatingDiffrerences: false)
  }
  
  override func viewWillDisappear(_ animated: Bool) {
    super.viewWillDisappear(animated)
    mainView.notificationRemove()
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
            self.toast(text: "댓글을 작성했습니다✎", position: .bottom)
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
    
    mainView.bottomBar.editFinishButton.rx
      .controlEvent(.touchUpInside)
      .subscribe(onNext: { _ in
      self.viewModel.newCommentPost()
        .subscribe(onSuccess: { _ in
          DispatchQueue.main.async {
            self.mainView.bottomBar.textField.resignFirstResponder()            
          }
          self.toast(text: "댓글을 작성했습니다✎", position: .bottom)
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
      alert.addAction(.init(title: "수정하기", style: .default) { [weak self] _ in
        guard let self = self else { return }
        
        let controller = self.makeEditCommentView()

        controller.viewModel.viewDismiss
          .filter{$0 == true}
          .subscribe(onNext: { _ in
            self.viewModel.post?.text = controller.viewModel.text.value
            DispatchQueue.main.async {
              controller.navigationController?.popViewController(animated: true)
              self.updateUI(animatingDiffrerences: false)
            }
          })
          .disposed(by: self.bag)
        self.navigationController?.pushViewController(controller, animated: true)
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
      alert.addAction(.init(title: "수정하기", style: .default) { [weak self] _ in
        guard let self = self else { return }
        
        self.viewModel.makeCommentEditViewController()
          .observe(on: MainScheduler.instance)
          .subscribe()
          .disposed(by: self.bag)
        
      })
      alert.addAction(.init(title: "삭제하기", style: .destructive) { _ in
        self.viewModel.deleteComment()
          .subscribe(onSuccess: {
            self.commentInitLoad()
            self.updateUI(animatingDiffrerences: true)
            self.toast(text: "댓글을 삭제했습니다.", position: .bottom)
              .observe(on: MainScheduler.instance)
              .subscribe()
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

  @objc private func popThisView() {
    navigationController?.popViewController(animated: true)
  }
  
  private func makeEditCommentView() -> NewBoardViewController {
    let viewModel = NewPostViewModel(postId: self.viewModel.post!.id)
    let editBoardView = NewBoardViewController(
      viewModel: viewModel,
      worktype: .edit,
      postText: self.viewModel.post?.text ?? "")
    return editBoardView
  }
}

extension BoardDetailViewController: UITableViewDelegate {
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    tableView.deselectRow(at: indexPath, animated: true)
  }
}
