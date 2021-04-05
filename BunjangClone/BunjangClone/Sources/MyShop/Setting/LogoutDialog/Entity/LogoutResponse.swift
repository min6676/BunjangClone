//
//  LogoutResponse.swift
//  BunjangClone
//
//  Created by 김민순 on 2021/03/18.
//

struct LogoutResponse: Decodable {
    let isSuccess: Bool
    let code: Int
    let message: String
}
