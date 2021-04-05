//
//  RegisterDataManager.swift
//  BunjangClone
//
//  Created by 김민순 on 2021/03/23.
//

import Foundation

import Alamofire
import KeychainSwift

class RegisterDataManager {

    func registerItem(_ parameters: RegisterdItem, viewController: BaseViewController) {
        let keyChain = KeychainSwift()
        if let jwt = keyChain.get("jwtToken") {
            let headers: HTTPHeaders = ["x-access-token" : jwt]
            AF.request("\(Constant.BASE_URL)/post/", method: .post, parameters: parameters, headers: headers).validate().responseDecodable(of: RegisterResponse.self) { response in
                switch response.result {
                case .success(let response):
                    let message = response.message
                    if response.isSuccess {
                        print(message)
                        viewController.presentBottomAlert(message: "상품 등록 성공")
                        viewController.goToMain()
                    } else {
                        switch response.code {
                        // 카테고리 메뉴 미존재
                        case 3007:
                            print(message)
                            
                        // 데이터베이스 에러
                        default:
                            print(message)
                        }
                    }
                case .failure(let error):
                    debugPrint(error)
                    viewController.presentAlert(title: "서버와의 연결이 원활하지 않습니다.")
                    
                }
            }
        } else {
            print("로그인 하세요")
        }
        
    }
}
