//
//  APIError.swift
//  YearEndAssignment
//
//  Created by hoseung Lee on 2022/01/09.
//

import Foundation

// MARK: - SignUpError


enum APIError: Error, LocalizedError {
  case invalidResponse(String)
  case noData
  case failure
  case invalidData
  
  public var errorDescription: String? {
    switch self {
      case .invalidResponse(let string):
        return string
      case .noData:
        return "noData"
      case .failure:
        return "failure"
      case .invalidData:
        return "invalid data"
    }
  }
}

extension APIError {
  
  struct SignUpError: Codable {
      let statusCode: Int
      let error: String
      let message, data: [Datum]
  }

  // MARK: - Datum
  struct Datum: Codable {
      let messages: [Message]
  }

  // MARK: - Message
  struct Message: Codable {
      let id, message: String
  }

}
