//
//  Date+Extension.swift
//  YearEndAssignment
//
//  Created by hoseung Lee on 2022/01/03.
//

import Foundation

extension Date {
  var mmDD: String {
    let formatter = DateFormatter()
    formatter.dateFormat = "MM/dd"
    return formatter.string(from: self)
  }
}
