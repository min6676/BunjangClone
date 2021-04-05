//
//  FirstCategoryViewController.swift
//  BunjangClone
//
//  Created by 김민순 on 2021/03/19.
//

import UIKit
import Kingfisher

class SubCategoryViewController: BaseViewController {
    @IBOutlet weak var categoryCollectionView: UICollectionView!
    @IBOutlet weak var productCollectionView: UICollectionView!
    @IBOutlet weak var categoryCollectionViewHeight: NSLayoutConstraint!
    @IBOutlet weak var productCollectionViewHeight: NSLayoutConstraint!
    
    var isExpand : Bool = false
    var categoryArray : [Category] = [Category(id: 0, name: "전체보기", count: 0)]
    var category : Category = Category(id: 0, name: "default")
    var productArray : [Product] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        showIndicator()
        SubCategoryDataManager().getSubCategory(id: category.id, clicked: 0, viewController: self)
        ProductDataManager().getSubCategory(id: category.id, page: 1, viewController: self)
        
        // Do any additional setup after loading the view.
        
        title = category.name
        
        categoryCollectionView.delegate = self
        categoryCollectionView.dataSource = self
        productCollectionView.delegate = self
        productCollectionView.dataSource = self
        
        categoryCollectionView.register(UINib(nibName: Constant.subCategoryCellIdentifier, bundle: nil), forCellWithReuseIdentifier: Constant.subCategoryCellIdentifier)
        categoryCollectionView.register(UINib(nibName: Constant.subCategoryFooterView, bundle: nil), forSupplementaryViewOfKind: UICollectionView.elementKindSectionFooter, withReuseIdentifier: Constant.subCategoryFooterView)
        productCollectionView.register(UINib(nibName: Constant.productCell, bundle: nil), forCellWithReuseIdentifier: Constant.productCell)
        productCollectionView.register(UINib(nibName: Constant.productHeaderView, bundle: nil), forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: Constant.productHeaderView)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        let height = categoryCollectionView.collectionViewLayout.collectionViewContentSize.height
        categoryCollectionViewHeight.constant = height
        
        let productHeight = productCollectionView.collectionViewLayout.collectionViewContentSize.height
        productCollectionViewHeight.constant = productHeight
        
        self.view.layoutIfNeeded()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.tabBarController?.tabBar.isHidden = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        self.tabBarController?.tabBar.isHidden = false
    }
    
    @IBAction func closeBarButtonPressed(_ sender: UIBarButtonItem) {
        self.navigationController?.popViewController(animated: true)
    }
    
    override func setCategory(_ result: [Category]) {
        DispatchQueue.main.async {
            self.categoryArray = [Category(id: 0, name: "전체보기", count: 0)]
            self.categoryArray += result
            self.categoryCollectionView.reloadData()
            self.viewDidLayoutSubviews()
        }
    }
    
    func setProduct(_ result: [Product]) {
        DispatchQueue.main.async {
            self.dismissIndicator()
            
            self.productArray = result
            self.productCollectionView.reloadData()
            self.viewDidLayoutSubviews()
        }
    }
}

extension SubCategoryViewController: UICollectionViewDelegate,
                                     UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == categoryCollectionView {
            return categoryArray.count
        } else {
            return productArray.count
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if collectionView == categoryCollectionView {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: Constant.subCategoryCellIdentifier, for: indexPath) as! SubCategoryCell
            
            
            cell.nameLabel.text = categoryArray[indexPath.row].name
            cell.countLabel.text = String(categoryArray[indexPath.row].count!).insertComma
            
            if cell.nameLabel.text == "전체보기" {
                cell.accesoryImage.image = UIImage(systemName: "chevron.right")
                cell.accesoryImage.tintColor = UIColor.black
                cell.countLabel.text = ""
            } else {
                cell.accesoryImage.image = UIImage()
            }
            
            return cell
        } else {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: Constant.productCell, for: indexPath) as! ProductCell
            
            let product = productArray[indexPath.row]
            
            cell.imageView.setImage(with: product.postImgURL)
            
            cell.priceLabel.text = "\(String(product.price).insertComma) 원"
            cell.nameLabel.text = product.productName
            
            return cell
        }
        
        
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        if collectionView == categoryCollectionView {
            let section = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionFooter, withReuseIdentifier: Constant.subCategoryFooterView, for: indexPath) as! SubCategoryFooterView
            section.button.addTarget(self, action: #selector(buttonPressed), for: .touchUpInside)
            
            return section
        } else {
            let section = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: Constant.productHeaderView, for: indexPath)
            
            return section
        }
        
    }
    
    @objc func buttonPressed(_ sender: UIButton) {
        isExpand = !isExpand
        if isExpand {
            sender.setImage(UIImage(named: "fold"), for: .normal)
            print("expand button pressed")
            SubCategoryDataManager().getSubCategory(id: category.id, clicked: 1, viewController: self)
        } else {
            sender.setImage(UIImage(named: "expand"), for: .normal)
            print("fold button pressed")
            SubCategoryDataManager().getSubCategory(id: category.id, clicked: 0, viewController: self)
            
        }
    }
    
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForFooterInSection section: Int) -> CGSize {
        if collectionView == categoryCollectionView {
            return CGSize(width: Device.width, height: (Device.width - 1) / 2 * 0.27)
        } else {
            return CGSize()
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        if collectionView == categoryCollectionView {
            return CGSize()
        } else {
            return CGSize(width: Device.width, height: 60)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if collectionView == categoryCollectionView {
            let halfWidth = (Device.width - 1) / 2
            let fullWidth = Device.width
            let height =  halfWidth * 0.25
            
            if categoryArray.count % 2 == 0 {
                return CGSize(width: halfWidth, height: height)
            } else {
                if indexPath.row != categoryArray.count - 1 {
                    return CGSize(width: halfWidth, height: height)
                } else {
                    return CGSize(width: fullWidth, height: height)
                }
            }
        } else {
            let width = (Device.width - 3) / 3
            let height = width * 1.4
            
            return CGSize(width: width, height: height)
        }
        
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        if collectionView == categoryCollectionView {
            let storyboard = UIStoryboard(name: Constant.homeStoryBoardName, bundle: nil)
            if let secondVC = storyboard.instantiateViewController(withIdentifier: Constant.secondSubCategoryViewController) as? SecondSubCategoryViewController {
                
                secondVC.currentId = category.id
                secondVC.category = Category(id: categoryArray[indexPath.row].id, name: categoryArray[indexPath.row].name)
                print(indexPath.row)
                print(categoryArray[indexPath.row].name)
                
                self.navigationController?.pushViewController(secondVC, animated: true)
            }
        }
        
    }
}
