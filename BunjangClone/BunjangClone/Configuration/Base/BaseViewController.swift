//
//  BaseViewController.swift
//  EduTemplate - storyboard
//
//  Created by Zero Yoon on 2022/02/23.
//

import UIKit
import KeychainSwift

class BaseViewController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // MARK: 아래 예시들처럼 상황에 맞게 활용하시면 됩니다.
        // Navigation Bar
//        self.navigationController?.navigationBar.titleTextAttributes = [
//            .font : UIFont.NotoSans(.medium, size: 16),
//        ]
        // Background Color
//        self.view.backgroundColor = .white
        
        // Navigation Back Button
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: self, action: nil)
        self.navigationController?.navigationBar.backgroundColor = UIColor.white
        self.navigationController?.navigationBar.setBackButtonImage(UIImage(systemName: "arrow.left"))
        self.navigationController?.navigationBar.tintColor = UIColor.black
//        self.navigationController?.navigationBar.isTransparent = true
    }
    
    func isLogin() -> Bool {
        let keyChain = KeychainSwift()
        if keyChain.get("jwtToken") != nil {
            return true
        } else {
            return false
        }
    }
    
    func goToMain() {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let mainTabBarController = storyboard.instantiateViewController(identifier: Constant.mainTabBarControllerIdentifier)
        
        changeRootViewController(mainTabBarController)
    }
    
    func goToLogin() {
        let storyboard = UIStoryboard(name: "LoginStoryboard", bundle: nil)
        let loginViewController = storyboard.instantiateViewController(identifier: Constant.loginViewControllerIdentifier)
        
        changeRootViewController(loginViewController)
    }
    
    func setCategory(_ result: [Category]) {
    }
    
    func setFollowing(_ result: [FollowingData]) {
        
    }
    
}
