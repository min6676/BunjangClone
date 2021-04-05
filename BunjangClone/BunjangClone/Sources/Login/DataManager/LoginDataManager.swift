//
//  LoginDataManager.swift
//  BunjangClone
//
//  Created by 김민순 on 2021/03/18.
//

import Alamofire
import KeychainSwift

class LoginDataManager {
    func login(_ parameters: LoginInput, viewController: LoginViewController) {
        AF.request("\(Constant.BASE_URL)/login", method: .post, parameters: parameters).validate().responseDecodable(of: LoginResponse.self) { response in
            switch response.result {
            case .success(let response):
                let message = response.message
                if response.isSuccess {
                    // 로그인 성공
//                    print(message)  
//                    print(response.jwt)
                    let keyChain = KeychainSwift()
                    keyChain.set(response.result.jwt, forKey: "jwtToken")
                    viewController.goToMain()
                } else {
                    switch response.code {
                    // 탈퇴 후 재가입 불가
                    case 3006:
                        print(message)
                    // JWT 토큰 검증 실패
                    case 3000:
                        print(message)
                    // 데이터베이스 에러
                    default:
                        print(message)
                    }
                }
            case .failure(let error):
                print(error.localizedDescription)
                viewController.presentAlert(title: "서버와의 연결이 원할하지 않습니다.")
            }
        }
    }
}
