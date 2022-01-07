//
//  SignUpViewController.swift
//  YearEndAssignment
//
//  Created by hoseung Lee on 2022/01/02.
//

import UIKit
import SwiftUI
import RxSwift
import RxCocoa

class SignUpViewController: UIViewController {
  
  let mainView = SignUpMainView()
  let viewModel = SignUpViewModel()
  
  let navBarItem = UINavigationItem(title: "새싹농장 가입하기")
  let backButton = UIBarButtonItem(image: UIImage(systemName: "arrow.left"), style: .done, target: self, action: #selector(dismissView))
  
  let bag = DisposeBag()
  
  var startButtonIsEnabled = false {
    didSet {
      mainView.startButton.isEnabled = startButtonIsEnabled
    }
  }
  
  override func loadView() {
    view = mainView
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    view.backgroundColor = .white
    createView()
    layoutConfigure()
    
    actionConnect()
    bindConfigure()
  }
  
  private func createView() {
    navBarItem.leftBarButtonItem = backButton
    mainView.navigationBar.items = [navBarItem]
    mainView.navigationBar.tintColor = .black
  }
  
  private func layoutConfigure() {
    
  }
  
  private func actionConnect() {
    mainView.startButton.addTarget(self, action: #selector(tappedStartButton(_:)), for: .touchUpInside)
    mainView.emailTextField.subTextField.addTarget(self, action: #selector(emailTextFieldDidChanged(_:)), for: .editingChanged)
    mainView.nickNameTextField.subTextField.addTarget(self, action: #selector(nicknameFieldDidChanged(_:)), for: .editingChanged)
    mainView.passwordTextField.subTextField.addTarget(self, action: #selector(passwordFieldDidChanged(_:)), for: .editingChanged)
    mainView.passwordValidTextFIeld.subTextField.addTarget(self, action: #selector(validPasswordFieldDidChanged(_:)), for: .editingChanged)
  }
  
  private func bindConfigure() {
    viewModel.isValidInput    
      .bind(to: mainView.startButton.rx.isEnabled)
      .disposed(by: bag)
  }
  

  
  @objc private func dismissView() {
    dismiss(animated: true, completion: nil)
  }
  
  @objc private func tappedStartButton(_ sender: UIButton) {
    
    viewModel.requestSignUp { success, error in
      DispatchQueue.main.async {
        if let error = error {
          self.alert(title: error.localizedDescription)
            .subscribe()
            .disposed(by: self.bag)
          return
        }
        
        if success {
          guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene else { return }
          let nav = UINavigationController(rootViewController: BoardViewController())
          windowScene.windows.first?.rootViewController = nav
          windowScene.windows.first?.makeKeyAndVisible()
          
          UIView.transition(with: windowScene.windows.first!, duration: 0.3, options: .transitionCrossDissolve, animations: nil, completion: nil)
          return
        }
        
      }
    }
    
    
  }
  
  @objc private func emailTextFieldDidChanged(_ textField: UITextField) {
    viewModel.email.accept(textField.text ?? "")
  }
  
  @objc private func nicknameFieldDidChanged(_ textField: UITextField) {
    viewModel.nickname.accept(textField.text ?? "")
  }
  
  @objc private func passwordFieldDidChanged(_ textField: UITextField) {
    viewModel.password.accept(textField.text ?? "")
  }
  
  @objc private func validPasswordFieldDidChanged(_ textField: UITextField) {
    viewModel.validpassword.accept(textField.text ?? "")
  }
}

struct SignUpVCRP: UIViewControllerRepresentable {
  func makeUIViewController(context: UIViewControllerRepresentableContext<SignUpVCRP>) -> SignUpViewController {
    SignUpViewController()
  }
  
  func updateUIViewController(_ uiViewController: SignUpViewController, context: Context) {
    
  }
}

struct SignUpVCRP_Previews: PreviewProvider {
  static var previews: some View {
    SignUpRP()
  }
}
