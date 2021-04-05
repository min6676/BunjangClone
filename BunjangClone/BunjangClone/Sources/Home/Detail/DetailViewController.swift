//
//  DetailViewController.swift
//  BunjangClone
//
//  Created by 김민순 on 2021/03/23.
//

import UIKit

class DetailViewController: BaseViewController {
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var productNameLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var watchedLabel: UILabel!
    @IBOutlet weak var contentTextView: UITextView!
    @IBOutlet weak var placeLabel: UILabel!
    @IBOutlet weak var categoryLabel: UILabel!
    @IBOutlet weak var tagLabel: UILabel!
    @IBOutlet weak var postQuestionLabel: UILabel!
    
    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var openDateLabel: UILabel!
    @IBOutlet weak var followerLabel: UILabel!
    @IBOutlet weak var otherItemCount: UILabel!
    @IBOutlet weak var otherItemView: UIStackView!
    @IBOutlet var itemImages: [UIImageView]!
    @IBOutlet var itemLabels: [UILabel]!
    
    @IBOutlet weak var reviewCount: UILabel!
    @IBOutlet weak var reviewTableView: UITableView!
    @IBOutlet weak var tableHeight: NSLayoutConstraint!
    
    @IBOutlet weak var outerViewHeight: NSLayoutConstraint!
    
    @IBOutlet weak var scrollView: UIScrollView!
    
    var postId = 0
    var reviewArray: [Review] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()

        DetailDataManager().getDetail(postId: postId, viewController: self)
        
        reviewTableView.delegate = self
        reviewTableView.dataSource = self
        reviewTableView.isScrollEnabled = false
        
        reviewTableView.register(UINib(nibName: Constant.reviewCellIdentifier, bundle: nil), forCellReuseIdentifier: Constant.reviewCellIdentifier)
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.navigationController?.navigationBar.isTransparent = true
        self.tabBarController?.tabBar.isHidden = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.navigationController?.navigationBar.isTransparent = false
        self.tabBarController?.tabBar.isHidden = false
    }
    
    func setUp(result: DetailResult) {
        if let detailInfo = result.detailInfo {
            let info = detailInfo[0]
            let postImages = info.postImages
            let postImageArr =  postImages.components(separatedBy: ",")
            let firstImage: String = postImageArr[0]
            self.imageView.setImage(with: firstImage)
            self.productNameLabel.text = info.productName
            self.priceLabel.text = "\(String(info.price).insertComma)원"
            self.timeLabel.text = info.time
            if let watched = info.watched {
                self.watchedLabel.text = String(watched)
            } else {
                self.watchedLabel.text = String(0)
            }
            
            if let content = info.content {
                self.contentTextView.text = content
            }
            
            if let place = info.place {
                self.placeLabel.text = place
            } else {
                self.placeLabel.text = "위치정보 없음"
            }
            
            if let category = info.category {
                self.categoryLabel.text = category
            } else {
                self.categoryLabel.text = "카테고리 없음"
            }
            
            if let tag = info.tags {
                let tags = tag
                let tagArr =  tags.components(separatedBy: ",")
                var tagLabel = ""
                for tag in tagArr {
                    tagLabel += "#\(tag.trim!) "
                }
                self.tagLabel.text = tagLabel
            } else {
                self.tagLabel.text = "# 태그 없음"
            }
            
            self.postQuestionLabel.text = String(info.postQuestion)
            
            self.userNameLabel.text = info.userName
            
            if let openDate = info.userOpenDate {
                self.openDateLabel.text = openDate
            } else {
                self.openDateLabel.text = "+0"
            }
            
            if let follower = info.follower {
                self.followerLabel.text = String(follower)
            } else {
                self.followerLabel.text = "0"
            }
        }
        
        self.otherItemCount.text = String(result.OtherProducts.count)
        
        let otherProducts = result.OtherProducts
        
        if otherProducts.count > 0 {
            for i in otherProducts.indices {
                if let image = otherProducts[i].postImg {
                    itemImages[i].setImage(with: image)
                }
                
                let price = otherProducts[i].price
                if price >= 10000 {
                    itemLabels[i].text = "\(String(price / 10000))만원"
                } else {
                    itemLabels[i].text = "\(String(price))원"
                }
            }
            
            if otherProducts.count == 1 {
                for i in 1 ..< 3 {
                    itemLabels[i].backgroundColor = .white
                }
            } else if otherProducts.count == 2 {
                itemLabels.last?.backgroundColor = .white
            }
        } else {
            
            for label in itemLabels {
                label.backgroundColor = .white
            }
        }
        
        let storeReview = result.StoreReview
        
        reviewCount.text = String(storeReview.count)
        
        if storeReview.count > 0 {
            for review in storeReview {
                reviewArray.append(Review(reviewer: review.reviewer, content: review.content, date: review.createAt))
            }
        }
        
        self.reviewTableView.reloadData()
        self.view.layoutIfNeeded()
        self.tableHeight.constant = CGFloat(self.reviewTableView.contentSize.height)
        
        self.outerViewHeight.constant = reviewTableView.frame.minY + tableHeight.constant
    }

    @IBAction func buttonToTopPressed(_ sender: UIButton) {
        self.scrollView.setContentOffset(CGPoint(x: 0, y: 0), animated: true)
    }
}

extension DetailViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return reviewArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: Constant.reviewCellIdentifier) as! ReviewCell
        
        let review = reviewArray[indexPath.row]
        
        cell.nickNameLabel.text = review.reviewer
        cell.contentTextView.text = review.content
        cell.timeLabel.text = review.date
        
        return cell
    }
    
    
}
