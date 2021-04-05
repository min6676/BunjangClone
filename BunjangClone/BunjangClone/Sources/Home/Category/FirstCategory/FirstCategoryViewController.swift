//
//  FirstCategoryViewController.swift
//  BunjangClone
//
//  Created by 김민순 on 2021/03/19.
//

import UIKit

class FirstCategoryViewController: BaseViewController {
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var bottomView: UIView!
    
    var sectionArray : [String] = ["추천서비스", "중고거래", "생활거래"]
    let serviceArray : [String] = ["우리동네", "팔로잉", "번개유심", "혜택/이벤트", "친구초대", "내폰시세"]
    var categoryArray : [Category] = []
    let lifeArray : [String] = ["지역 서비스", "원룸/함께살아요", "구인구직", "재능"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        showIndicator()
        CategoryDataManager().getCategory(viewController: self)

        // Do any additional setup after loading the view.
        self.navigationItem.setHidesBackButton(true, animated: true)

        bottomView.layer.shadowColor = UIColor.lightGray.cgColor
        bottomView.layer.shadowOpacity = 0.5
        bottomView.layer.shadowOffset = .zero
        bottomView.layer.shadowRadius = 4
        
        collectionView.delegate = self
        collectionView.dataSource = self
        
        collectionView.register(UINib(nibName: Constant.firstCategoryCellIdentifier, bundle: nil), forCellWithReuseIdentifier: Constant.firstCategoryCellIdentifier)
        collectionView.register(UINib(nibName: Constant.firstCategorySectionIdentifier, bundle: nil), forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: Constant.firstCategorySectionIdentifier)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.tabBarController?.tabBar.isHidden = true
        self.navigationController?.navigationBar.isTransparent = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        self.tabBarController?.tabBar.isHidden = false
    }

    @IBAction func closeBarButtonPressed(_ sender: UIBarButtonItem) {
        self.navigationController?.popViewController(animated: true)
    }
    
    override func setCategory(_ result: [Category]) {
        dismissIndicator()
        
        categoryArray = result
        self.collectionView.reloadData()
    }
}

extension FirstCategoryViewController: UICollectionViewDelegate,
                                       UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return sectionArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if section == 0 {
            return serviceArray.count
        } else if section == 1 {
            return categoryArray.count
        } else {
            return lifeArray.count
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: Constant.firstCategoryCellIdentifier, for: indexPath) as! CategoryCell
        var name = ""
        
        if indexPath.section == 0 {
            name = serviceArray[indexPath.row]
        } else if indexPath.section == 1 {
            let category = categoryArray[indexPath.row]
            name = category.name
        } else {
            name = lifeArray[indexPath.row]
        }
        
        let charsToRemove: Set<Character> = Set("/")
        let imageName = String(name.filter { !charsToRemove.contains($0) })
        
        cell.imageView.image = UIImage(named: imageName)
        cell.categoryLabel.text = name
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let section = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: Constant.firstCategorySectionIdentifier, for: indexPath) as! CategorySection
        
        if let label = section.label {
            let lineView = UIView(frame: CGRect(x: label.frame.minX,
                                                y: section.frame.height - 2,
                                                width: label.frame.width,
                                                height: 2.0))
            
            lineView.backgroundColor = #colorLiteral(red: 0.9961063266, green: 0, blue: 0.0002579989086, alpha: 1)
            section.addSubview(lineView)
        }
        
        section.label.text = sectionArray[indexPath.section]
        
        return section
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize(width: Device.width, height: 45)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = (Device.width - 60) / 2
        let height =  width * 0.33
        return CGSize(width: width, height: height)
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        if indexPath.section == 1{
            let storyboard = UIStoryboard(name: Constant.homeStoryBoardName, bundle: nil)
            if let secondVC = storyboard.instantiateViewController(withIdentifier: Constant.subCategoryViewController) as? SubCategoryViewController {
                secondVC.category = categoryArray[indexPath.row]
                print(categoryArray[indexPath.row].id)
                
                self.navigationController?.pushViewController(secondVC, animated: true)
            }
        }
    }
}
