//
//  LoginDataManager.swift
//  BunjangClone
//
//  Created by 김민순 on 2021/03/18.
//

import Alamofire
import KeychainSwift

class CategoryDataManager {

    func getCategory(viewController: BaseViewController) {

        AF.request("\(Constant.BASE_URL)/category", method: .get).validate().responseDecodable(of: CategoryResponse.self) { response in
            switch response.result {
            case .success(let response):
                let message = response.message
                if response.isSuccess {
                    print(message)
                    viewController.setCategory(response.result)
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
                print(error.localizedDescription)
                viewController.presentAlert(title: "서버와의 연결이 원할하지 않습니다.")
            }
        }
    }
}
