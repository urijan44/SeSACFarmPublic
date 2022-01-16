//
//  LoginViewController.swift
//  YearEndAssignment
//
//  Created by hoseung Lee on 2022/01/04.
//

import UIKit
import RxSwift

class LoginViewController: UIViewController {
  
  let mainView = LoginMainView()
  let viewModel = SignInViewModel()
  let bag = DisposeBag()
  let navBarItem = UINavigationItem(title: "새싹농장 로그인")
  let backButton = UIBarButtonItem(image: UIImage(systemName: "arrow.left"), style: .done, target: self, action: #selector(dismissView))
  
  override func loadView() {
    view = mainView
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    view.backgroundColor = .white
    createView()
    mainView.startButton.addTarget(self, action: #selector(tappedStartButton(_:)), for: .touchUpInside)
  }
  
  private func createView() {
    navBarItem.leftBarButtonItem = backButton
    mainView.navigationBar.items = [navBarItem]
    mainView.navigationBar.tintColor = .black
  }
  
  @objc private func dismissView() {
    dismiss(animated: true, completion: nil)
  }
  
  @objc private func tappedStartButton(_ sender: SeSACButton) {
    sender.startAnimating()
    viewModel.loginRequest(
      id: mainView.idTextField.text,
      pass: mainView.passwordTextField.text) { error in
        if let error = error {
          self.alert(title: error.localizedDescription)
            .subscribe(onDisposed: {
              sender.stopAnimating()
            })
            .disposed(by: self.bag)
          return
        }
        
        guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene else { return }
        let nav = UINavigationController(rootViewController: BoardViewController())
        windowScene.windows.first?.rootViewController = nav
        windowScene.windows.first?.makeKeyAndVisible()
        
        UIView.transition(with: windowScene.windows.first!, duration: 0.3, options: .transitionCrossDissolve, animations: nil, completion: nil)
      }
    
    
  }
}
