//
//  BoardModel.swift
//  YearEndAssignment
//
//  Created by hoseung Lee on 2022/01/03.
//

import Foundation

// MARK: - BoardElement
struct BoardElement: Codable, Hashable {
    let id: Int
    var text: String
    let user: BoardUser
    let createdAt, updatedAt: String
    let comments: [BoardComment]

    enum CodingKeys: String, CodingKey {
        case id, text, user
        case createdAt = "created_at"
        case updatedAt = "updated_at"
        case comments
    }
}

// MARK: - Comment
struct BoardComment: Codable, Hashable {
    let id: Int
    let comment: String
    let user, post: Int
    let createdAt, updatedAt: String

    enum CodingKeys: String, CodingKey {
        case id, comment, user, post
        case createdAt = "created_at"
        case updatedAt = "updated_at"
    }
}

struct DetailComment: Codable, Hashable {
  let id: Int
  let comment: String
  let user: BoardUser
}

// MARK: - User
struct BoardUser: Codable, Hashable {
    let id: Int
    let username, email, provider: String
    let confirmed: Bool
    let blocked: Bool?
    let role: Int
    let createdAt, updatedAt: String

    enum CodingKeys: String, CodingKey {
        case id, username, email, provider, confirmed, blocked, role
        case createdAt = "created_at"
        case updatedAt = "updated_at"
    }
}


typealias Board = [BoardElement]
//struct Comment: Codable, Hashable {
//  var id = UUID().uuidString
//  let nickname: String
//  let content: String
//}

//enum Dummy {
//  static let dummyBoard: [Board] = [
//    Board(nickname: "미묘한도사", content: "드라이브가실분 심심해염", date: Date(), comments: [.init(nickname: "", content: ""), .init(nickname: "", content: "")]),
//    Board(nickname: "쭙쭙이", content: "거래완료했으면 오나료로 좀 돌리지ㅠ 계속 헛탕치네요...", date: Date(), comments: []),
//    Board(nickname: "미묘한도사", content: "코로나로 인해서 일자리도 많이 줄고 취업하끼도 어렵고 씁쓸하네요오\n다음줄\n다음줄2\n다음줄3", date: Date(), comments: dummyComment),
//    Board(nickname: "크리스마스", content: "질문있습니다. 낙성대 살 때 삼겹살 먹으러 돼지네 자주 갔었는데 고기질도 그렇고 반찬들 사이드 메뉴들 모두 너무 너무 맛있었는데, 비슷한 식당을 찾골싶은데 \n다음줄은 잘 보이닝\n그다음줄은", date: Date(), comments: []),
//  ]
//
//  static let dummyComment: [Comment] = [
//    Comment(nickname: "테이크아웃좋아", content: "연말이라 슬럼프가 오고 있어요 도와주세요\n빠르게\n회복\n해야합니다!!!"),
//    Comment(nickname: "메밀이", content: "과제가 너무 많아요\n우엥 우엥\n우엥\n우엥"),
//    Comment(nickname: "두부랑 치즈", content: "안녕하세요. 내이름을 불러줘 내 내가 먼저 엿보고 온 시간들 너와 내가 함께였었지 나랑 놀아주는 그대가 좋아 내가 물어보면 그대도 좋아 네 이름이 뭐야 Repeat 눈 깜빡하면 어른이 될 거에요 날 알아보겠죠"),
//    Comment(nickname: "잭잭잭", content: "자고싶어요")
//  ]
//}



