//
//  LoginViewController.swift
//  BunjangClone
//
//  Created by 김민순 on 2021/03/14.
//

import UIKit
import KakaoSDKUser
import KeychainSwift

class LoginViewController: BaseViewController {
    @IBOutlet weak var pageControl: UIPageControl!
    @IBOutlet weak var kakaoLoginButton: UIButton!
    @IBOutlet weak var appleLoginButton: UIButton!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var myViewWidth: NSLayoutConstraint!
    @IBOutlet weak var myView: UIView!
    @IBOutlet weak var stackView: UIStackView!
    
    var containerView = UIView()
    var slideUpView = UIView()
    var slideUpViewHeight: CGFloat = 0.0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let loginImages = ["LoginImage1", "LoginImage2", "LoginImage3", "LoginImage4"]
        
        slideUpViewHeight = UIScreen.main.bounds.maxY - stackView.frame.minY
        
        myViewWidth.constant = UIScreen.main.bounds.width * CGFloat(loginImages.count)
        
        for i in 0..<loginImages.count {
            let imageView = UIImageView()
            imageView.frame = CGRect(x: UIScreen.main.bounds.maxX * CGFloat(i) + 50, y: myView.frame.minY, width: Device.width - 100, height: myView.frame.height)
            imageView.image = UIImage(named: loginImages[i])
            
            myView.addSubview(imageView)
        }
        // Do any additional setup after loading the view.
        
        pageControl.numberOfPages = loginImages.count
        pageControl.currentPage = 0
        
        scrollView.delegate = self
    }
    
    @IBAction func kakaoLoginButtonPressed(_ sender: UIButton) {
        UserApi.shared.loginWithKakaoTalk {(oauthToken, error) in
            if let error = error {
                print(error)
                print("Login with Kakao account")
                self.loginWithKakaoAcount()
            }
            else {
                print("loginWithKakaoTalk() success.")
//                //do something
                self.showIndicator()
                if let oauthToken = oauthToken {
                    let accessToken = oauthToken.accessToken
                    let input = LoginInput(accessToken: accessToken)
                    LoginDataManager().login(input, viewController: self)
                }
                
                _ = oauthToken
            }
        }
        
        
    }
    
    func loginWithKakaoAcount() {
        UserApi.shared.loginWithKakaoAccount {(oauthToken, error) in
            if let error = error {
                print(error)
            }
            else {
                print("loginWithKakaoAccount() success.")
                
                //do something
                
                self.showIndicator()
                if let oauthToken = oauthToken {
                    let accessToken = oauthToken.accessToken
                    let input = LoginInput(accessToken: accessToken)
                    LoginDataManager().login(input, viewController: self)                    
                }

                _ = oauthToken

            }
        }
    }
    
    @IBAction func popupButtonPressed(_ sender: UIButton) {
        
        slideUpView.backgroundColor = UIColor.white
        
        let window = self.view.window
        containerView.backgroundColor = UIColor.black.withAlphaComponent(0.9)
        containerView.frame = self.view.frame
        
        window?.addSubview(containerView)
        
        let tapGesture = UITapGestureRecognizer(target: self,
                                                action: #selector(slideUpViewTapped))
        containerView.addGestureRecognizer(tapGesture)
        
        
        containerView.alpha = 0
        UIView.animate(withDuration: 0.5,
                       delay: 0, usingSpringWithDamping: 1.0,
                       initialSpringVelocity: 1.0,
                       options: .curveEaseInOut, animations: {
                        self.containerView.alpha = 0.8
                       }, completion: nil)
        
        slideUpView.frame = CGRect(x: 0, y: Device.height, width: Device.width, height: slideUpViewHeight)
        window?.addSubview(slideUpView)
        
        
        UIView.animate(withDuration: 0.5,
                       delay: 0, usingSpringWithDamping: 1.0,
                       initialSpringVelocity: 1.0,
                       options: .curveEaseInOut, animations: {
                        self.containerView.alpha = 0.8
                        self.slideUpView.frame = CGRect(x: 0, y: Device.height - self.slideUpViewHeight, width: Device.width, height: self.slideUpViewHeight)
                       }, completion: nil)
        
        setUpSlideUpView()
    }
    
    @objc func slideUpViewTapped() {
        let screenSize = UIScreen.main.bounds.size
        UIView.animate(withDuration: 0.5,
                       delay: 0, usingSpringWithDamping: 1.0,
                       initialSpringVelocity: 1.0,
                       options: .curveEaseInOut, animations: {
                        self.containerView.alpha = 0
                        self.slideUpView.frame = CGRect(x: 0, y: screenSize.height, width: screenSize.width, height: self.slideUpViewHeight)
                       }, completion: nil)
    }
    
    func setUpSlideUpView() {
        let textLabel = UILabel()
        let closeButton = UIButton()
        let loginStackView = UIStackView()
        let facebookButton = UIButton()
        let naverButton = UIButton()
        let authButton = UIButton()
        
        loginStackView.frame = CGRect(x: 30, y: slideUpView.bounds.minY, width: Device.width - 60, height: slideUpView.bounds.height - 60)
        textLabel.font = .NotoSans(.medium, size: 20)
        textLabel.textColor = UIColor.black
        textLabel.text = "다른 방법으로 로그인"
        textLabel.textAlignment = .center
        textLabel.translatesAutoresizingMaskIntoConstraints = false
        facebookButton.setImage(UIImage(named: "Facebook"), for: .normal)
        facebookButton.translatesAutoresizingMaskIntoConstraints = false
        naverButton.setImage(UIImage(named: "Naver"), for: .normal)
        naverButton.translatesAutoresizingMaskIntoConstraints = false
        authButton.setImage(UIImage(named: "Auth"), for: .normal)
        authButton.translatesAutoresizingMaskIntoConstraints = false
        facebookButton.adjustsImageWhenHighlighted = false
        naverButton.adjustsImageWhenHighlighted = false
        authButton.adjustsImageWhenHighlighted = false
        loginStackView.addArrangedSubview(textLabel)
        loginStackView.addArrangedSubview(facebookButton)
        loginStackView.addArrangedSubview(naverButton)
        loginStackView.addArrangedSubview(authButton)
        loginStackView.axis = .vertical
        loginStackView.alignment = .fill
        loginStackView.distribution = .fillEqually
        loginStackView.spacing = 2
        
        slideUpView.addSubview(loginStackView)
        
        closeButton.frame = CGRect(x: slideUpView.bounds.maxX - 35, y: slideUpView.bounds.minY + 20, width: 20, height: 20)
        closeButton.setImage(UIImage(named: "Cancel"), for: .normal)
        
        slideUpView.addSubview(closeButton)
        
        closeButton.addTarget(self, action: #selector(closeButtonPressed), for: .touchUpInside)
    }
    
    @objc
    func closeButtonPressed(sender: UIButton) {
        let screenSize = UIScreen.main.bounds.size
        UIView.animate(withDuration: 0.5,
                       delay: 0, usingSpringWithDamping: 1.0,
                       initialSpringVelocity: 1.0,
                       options: .curveEaseInOut, animations: {
                        self.containerView.alpha = 0
                        self.slideUpView.frame = CGRect(x: 0, y: screenSize.height, width: screenSize.width, height: self.slideUpViewHeight)
                       }, completion: nil)
    }
    
}

extension LoginViewController: UIScrollViewDelegate {
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        pageControl.currentPage = Int(floor(scrollView.contentOffset.x / UIScreen.main.bounds.width))
    }
}
