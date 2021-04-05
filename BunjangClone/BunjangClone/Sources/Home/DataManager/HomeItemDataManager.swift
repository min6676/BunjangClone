//
//  LoginDataManager.swift
//  BunjangClone
//
//  Created by 김민순 on 2021/03/18.
//

import Alamofire

class HomeItemDataManager {

    func getHomeItem(page: Int, viewController: HomeViewController) {
        AF.request("\(Constant.BASE_URL)/?page=\(page)", method: .get).validate().responseDecodable(of: HomeItemResponse.self) { response in
            switch response.result {
            case .success(let response):
                let message = response.message
                if response.isSuccess {
                    print(message)
                    viewController.setProduct(response.result!)
                } else {
                    switch response.code {
                    
                    // 검색 결과 없을 시
                    case 3008:
                        viewController.presentBottomAlert(message: "마지막 상품입니다.")
                        viewController.dismissIndicator()
                        print(message)
                    default:
                        print(message)
                    }

                }
            case .failure(let error):
                print(error.localizedDescription)
                viewController.presentAlert(title: "서버와의 연결이 원활하지 않습니다.")
            }
        }
    }
}
