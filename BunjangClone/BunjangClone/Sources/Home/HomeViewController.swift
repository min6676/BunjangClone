//
//  ViewController.swift
//  BunjangClone
//
//  Created by 김민순 on 2021/03/13.
//

import UIKit

class HomeViewController: BaseViewController {
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var collectionViewHeight: NSLayoutConstraint!
    var ItemArray : [HomeItem] = []
    var page = 1
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        collectionView.delegate = self
        collectionView.dataSource = self
        
        collectionView.register(UINib(nibName: Constant.homeHeaderViewIdentifier, bundle: nil), forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: Constant.homeHeaderViewIdentifier)
        collectionView.register(UINib(nibName: Constant.homeCollectionViewCell, bundle: nil), forCellWithReuseIdentifier: Constant.homeCollectionViewCell)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        showIndicator()
        HomeItemDataManager().getHomeItem(page: page, viewController: self)
        super.viewWillAppear(animated)
        
        self.navigationController?.navigationBar.isHidden = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        page = 1
        super.viewWillDisappear(animated)
        
        self.navigationController?.navigationBar.isHidden = false
    }
    
    func setProduct(_ result: [HomeItem]) {
        DispatchQueue.main.async {
            self.dismissIndicator()
            
            self.ItemArray += result
            self.collectionView.reloadData()
        }
    }
    
    @IBAction func scrollToTop(_ sender: UIButton) {
        self.collectionView.setContentOffset(CGPoint(x: 0, y: 0), animated: true)
    }
}

extension HomeViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return ItemArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: Constant.homeCollectionViewCell, for: indexPath) as! HomeCollectionViewCell
        
        let item = ItemArray[indexPath.row]
        
        if let url = item.postImgURL {
            cell.imageView.setImage(with: url)
        } else {
            cell.imageView.image = UIImage(named: "noImage")
        }
        cell.productNameLabel.text = item.productName
        cell.priceLabel.text = "\(String(item.price).insertComma)원"
        cell.userNameLabel.text = item.userName
        cell.timeLabel.text = item.time
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let header = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: Constant.homeHeaderViewIdentifier, for: indexPath) as! HeaderView
        
        for i in header.buttons.indices {
            header.buttons[i].addTarget(self, action: #selector(headerButtonPressed), for: .touchUpInside)
        }
        
        return header
    }
    
    @objc func headerButtonPressed(sender: UIButton) {
        if sender.tag == 1 {
            let storyboard = UIStoryboard(name: Constant.homeStoryBoardName, bundle: nil)
            if let vc = storyboard.instantiateViewController(withIdentifier: Constant.subCategoryViewController) as? SubCategoryViewController {
                vc.category = Category(id: 1, name: "여성의류")
                self.navigationController?.pushViewController(vc, animated: true)
            }
        } else if sender.tag == 2 {
            let storyboard = UIStoryboard(name: Constant.homeStoryBoardName, bundle: nil)
            if let vc = storyboard.instantiateViewController(withIdentifier: Constant.subCategoryViewController) as? SubCategoryViewController {
                vc.category = Category(id: 3, name: "패션잡화")
                self.navigationController?.pushViewController(vc, animated: true)
            }
        } else if sender.tag == 3 {
            let storyboard = UIStoryboard(name: Constant.homeStoryBoardName, bundle: nil)
            if let vc = storyboard.instantiateViewController(withIdentifier: Constant.subCategoryViewController) as? SubCategoryViewController {
                vc.category = Category(id: 7, name: "디지털/가전")
                self.navigationController?.pushViewController(vc, animated: true)
            }
        } else if sender.tag == 5 {
            performSegue(withIdentifier: Constant.goToFirstCategorySegueIdentifier, sender: self)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize(width: view.frame.size.width, height: 300)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = (Device.width - 1) / 2
        let height = width * 1.3
        return CGSize(width: width, height: height)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let storyboard = UIStoryboard(name: Constant.homeStoryBoardName, bundle: nil)
        if let vc = storyboard.instantiateViewController(withIdentifier: Constant.detailViewControllerIdentifier) as? DetailViewController {
            vc.postId = ItemArray[indexPath.row].postId
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        if indexPath.row == ItemArray.count - 1 {
            page += 1
            showIndicator()
            HomeItemDataManager().getHomeItem(page: page, viewController: self)
        }
    }
}
