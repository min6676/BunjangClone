//
//  FollowingResponse.swift
//  BunjangClone
//
//  Created by 김민순 on 2021/03/26.
//

import Foundation

struct FollowingResponse: Decodable {
    let isSuccess: Bool
    let code: Int
    let message: String
    let result: [FollowingData]
}
