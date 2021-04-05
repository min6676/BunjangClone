//
//  PushRegisterViewController.swift
//  BunjangClone
//
//  Created by 김민순 on 2021/03/14.
//

import UIKit
import KakaoSDKUser
import KakaoSDKAuth
import KakaoSDKCommon
import FirebaseFirestore
import FirebaseStorage

class RegisterViewController: BaseViewController {
    @IBOutlet weak var itemImageView: UIImageView!
    let imagePickerController = UIImagePickerController()
    @IBOutlet weak var productName: UITextField!
    @IBOutlet weak var negoView: UIView!
    @IBOutlet weak var necoCheckImage: UIImageView!
    @IBOutlet weak var negoLabel: UILabel!
    @IBOutlet weak var shippingView: UIView!
    @IBOutlet weak var shippingCheckImage: UIImageView!
    @IBOutlet weak var shippingLabel: UILabel!
    @IBOutlet weak var categoryTextField: UITextField!
    @IBOutlet weak var priceTextField: UITextField!
    @IBOutlet weak var tagTextField: UITextField!
    
    let storage = Storage.storage()
    
    var itemImage = UIImage()
    var nego: Bool = false
    var includeShippingFee: Bool = false
    var categoryId: [Category] = []
    var imageURL: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if !isLogin() {
            goToLogin()
        }

        productName.isEnabled = true
        productName.allowsEditingTextAttributes = true
        productName.isUserInteractionEnabled = true
        imagePickerController.delegate = self
        self.negoView.isUserInteractionEnabled = true
        self.negoView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.checkNego(sender:))))
        self.shippingView.isUserInteractionEnabled = true
        self.shippingView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.checkIncludeShippingFee(sender:))))
        self.categoryTextField.isUserInteractionEnabled = true
        self.categoryTextField.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.goToCategory(sender:))))
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if categoryId.count > 1 {
            print(categoryId[0].name, categoryId[2].name)
            print(categoryId)
            categoryTextField.text = "\(categoryId[0].name)>\(categoryId[2].name))"
        }
        
        
        self.navigationController?.navigationBar.isTransparent = true
        self.tabBarController?.tabBar.isHidden = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        self.tabBarController?.tabBar.isHidden = true
    }
    
    @IBAction func backButtonPressed(_ sender: UIBarButtonItem) {
        goToMain()
    }
    
    @IBAction func submitButtonPressed(_ sender: UIButton) {
        if itemImageView.image == nil {
            presentAlert(title: "사진을 등록해주세요.")
        } else if productName.text == "" {
            presentAlert(title: "상품명을 입력해주세요.")
        } else if categoryId.count < 1 {
            presentAlert(title: "카테고리를 선택해주세요.")
        } else if priceTextField.text == "" {
            presentAlert(title: "가격을 입려해주세요")
        } else if tagTextField.text == "" {
            presentAlert(title: "태그를 입력해주세요")
        } else {
            let name = productName.text!
            print("Submit Button Pressed")
            uploadImage(img: itemImage, name: name)
        }
    }
    
    func uploadImage(img: UIImage, name: String) {
        var data = Data()
        data = img.jpegData(compressionQuality: 0.8)!
        let filePath = name
        let metadata = StorageMetadata()
        metadata.contentType = "image/png"
        storage.reference().child(filePath).putData(data, metadata: metadata) {
            (metadata, error) in if let error = error {
                print(error)
                return
            } else {
                print("성공")
                self.getUrlOfImage(name: name)
                
            }
        }
    }
    
    func getUrlOfImage(name: String) {
        let imageRef = storage.reference().child(name)
        
        // Fetch the download URL
        imageRef.downloadURL { url, error in
            if let error = error {
                // Handle any errors
                print(error)
            } else {
                let imageURL = String(describing: url!)
                let imageArray = [imageURL]
                print(imageArray)
                let registeredItem = RegisterdItem(productImage: imageArray, productName: self.productName.text!, categoryId: self.categoryId[0].id, subCategoryId: self.categoryId[1].id, thirdCategoryId: self.categoryId[2].id, price: Int(self.priceTextField.text!)! , changePrice: self.nego, containDelivery: self.includeShippingFee, setMyPlace: false, tag: [self.tagTextField.text!])
                RegisterDataManager().registerItem(registeredItem, viewController: self)
            }
        }
    }
}

extension RegisterViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    @IBAction func cameraButtonPressed(_ sender: UIButton) {
        
        let actionCamera = UIAlertAction(title: "사진 촬영", style: .default) { action in
            if(UIImagePickerController .isSourceTypeAvailable(.camera)) {
                self.imagePickerController.sourceType = .camera
                self.present(self.imagePickerController, animated: true, completion: nil)
            } else {
                self.presentBottomAlert(message: "카메라 사용이 불가능합니다.")
            }
            
        }
        let actionPhoto = UIAlertAction(title: "앨범에서 가져오기", style: .default) { action in
            self.imagePickerController.sourceType = .photoLibrary
            self.present(self.imagePickerController, animated: true, completion: nil)
        }
        let cancelAction = UIAlertAction(title: "취소", style: .cancel)
        self.presentAlert(
            title: "상품 이미지 추가",
            preferredStyle: .actionSheet,
            with: actionCamera, actionPhoto, cancelAction
        )
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        print(info)
        if let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            self.itemImageView.image = image
            self.itemImage = image
        }
        
        dismiss(animated: true, completion: nil)
    }
    
    @objc func checkNego(sender: UIGestureRecognizer) {
        if nego == false {
            if includeShippingFee {
                includeShippingFee = false
                changeTintColor(shippingCheckImage, shippingLabel, #colorLiteral(red: 0.6666666865, green: 0.6666666865, blue: 0.6666666865, alpha: 1))
            }
            changeTintColor(necoCheckImage, negoLabel, #colorLiteral(red: 0.9921750426, green: 0.3176675141, blue: 0.3568457663, alpha: 1))
        } else {
            changeTintColor(necoCheckImage, negoLabel, #colorLiteral(red: 0.6666666865, green: 0.6666666865, blue: 0.6666666865, alpha: 1))
        }

        nego = !nego
        priceTextFieldEnable(!nego)
    }

    @objc func checkIncludeShippingFee(sender: UIGestureRecognizer) {
        if includeShippingFee == false {
            if nego {
                nego = false
                changeTintColor(necoCheckImage, negoLabel, #colorLiteral(red: 0.6666666865, green: 0.6666666865, blue: 0.6666666865, alpha: 1))
                priceTextFieldEnable(!nego)
            }
            changeTintColor(shippingCheckImage, shippingLabel, #colorLiteral(red: 0.9921750426, green: 0.3176675141, blue: 0.3568457663, alpha: 1))
        } else {
            changeTintColor(shippingCheckImage, shippingLabel, #colorLiteral(red: 0.6666666865, green: 0.6666666865, blue: 0.6666666865, alpha: 1))
        }

        includeShippingFee = !includeShippingFee
    }

    @objc func goToCategory(sender: UIGestureRecognizer) {
        let storyboard = UIStoryboard(name: Constant.registerStoryBoardName, bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: Constant.registerCategoryViewControllerIdentifier)

        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    func priceTextFieldEnable(_ bool: Bool) {
        if bool {
            priceTextField.isEnabled = true
            priceTextField.backgroundColor = .white
        } else {
            priceTextField.text = ""
            priceTextField.isEnabled = false
            priceTextField.backgroundColor = .lightGray
        }
    }
    
    func changeTintColor(_ image: UIImageView, _ label: UILabel, _ color: UIColor) {
        image.tintColor = color
        label.textColor = color
    }
}
