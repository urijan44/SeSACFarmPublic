//
//  SceneCoordinatorType.swift
//  YearEndAssignment
//
//  Created by hoseung Lee on 2022/01/14.
//

import UIKit
import RxSwift

protocol SceneCoordinatorType {
  
  @discardableResult
  func transition(to scene: Scene, type: SceneTransitionType) -> Completable
  
  @discardableResult
  func pop(animated: Bool) -> Completable
}

extension SceneCoordinatorType {
  @discardableResult
  func pop() -> Completable {
    pop(animated: true)
  }
}
