//
//  ViewController.swift
//  YearEndAssignment
//
//  Created by hoseung Lee on 2022/01/01.
//

import UIKit
import SwiftUI

class StartViewController: UIViewController {

  let mainView = StartMainView()
  override func loadView() {
    view = mainView
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    view.backgroundColor = .white
    mainView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(showLoginService)))
    mainView.startButton.addTarget(self, action: #selector(showSignUpView(_:)), for: .touchUpInside)
  }
  
  @objc private func showLoginService() {
    let vc = LoginViewController()
    vc.modalPresentationStyle = .fullScreen
    vc.modalTransitionStyle = .coverVertical
    present(vc, animated: true, completion: nil)
  }
  
  @objc private func showSignUpView(_ button: UIButton) {
    let vc = SignUpViewController()
    vc.modalPresentationStyle = .fullScreen
    vc.modalTransitionStyle = .coverVertical
    present(vc, animated: true, completion: nil)
  }


}

struct StartRP: UIViewControllerRepresentable {
  func makeUIViewController(context: UIViewControllerRepresentableContext<StartRP>) -> StartViewController {
    StartViewController()
  }
  func updateUIViewController(_ uiViewController: StartViewController, context: Context) {
    
  }
}

struct Start_Previews: PreviewProvider {
  static var previews: some View {
    StartRP()
  }
}

