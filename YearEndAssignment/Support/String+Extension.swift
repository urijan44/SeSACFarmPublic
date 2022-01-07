//
//  String+Extension.swift
//  YearEndAssignment
//
//  Created by hoseung Lee on 2022/01/05.
//

import Foundation

extension String {
  var dateConvert: Date {
    let formatter = DateFormatter()
    formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'"
    return formatter.date(from: self) ?? Date()
  }
}
