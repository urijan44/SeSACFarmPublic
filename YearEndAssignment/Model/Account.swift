//
//  Account.swift
//  YearEndAssignment
//
//  Created by hoseung Lee on 2022/01/04.
//

import Foundation

// MARK: - Account
struct Account: Codable {
  let jwt: String
  let user: User
}

// MARK: - User
struct User: Codable, Hashable {
  let id: Int
  let username, email, provider: String
  let confirmed: Bool
  let role: Role
  let createdAt, updatedAt: String
  let posts: [Post]
//  let comments: [Comment] = []
  
  enum CodingKeys: String, CodingKey {
    case id, username, email, provider, confirmed, role
    case createdAt = "created_at"
    case updatedAt = "updated_at"
    case posts
  }
}

// MARK: - Comment
struct Comment: Codable, Hashable {
  
  let id: Int
  let content: String
  let user: String
  let post: String
  let createdAt, updatedAt: String
  
  enum CodingKeys: String, CodingKey {
    case id, user, post
    case content = "comment"
    case createdAt = "created_at"
    case updatedAt = "updated_at"
  }
}

// MARK: - Post
struct Post: Codable, Hashable {
  let id: Int
  let text: String
  let user: Int
  let createdAt, updatedAt: String
  
  enum CodingKeys: String, CodingKey {
    case id, text, user
    case createdAt = "created_at"
    case updatedAt = "updated_at"
  }
}

// MARK: - Role
struct Role: Codable, Hashable {
  let id: Int
  let name, roleDescription, type: String
  
  enum CodingKeys: String, CodingKey {
    case id, name
    case roleDescription = "description"
    case type
  }
}
