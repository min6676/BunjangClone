//
//  FollowingViewController.swift
//  BunjangClone
//
//  Created by 김민순 on 2021/03/14.
//

import UIKit
import Segmentio

class FollowingViewController: BaseViewController {
    @IBOutlet weak var contentView: UIView!
    var segmentioView: Segmentio!
    var content = [SegmentioItem]()
    var followingArray = [FollowingData]()
    var recommendArray = [FollowingData]()
    var postArray = [PostData]()
    var recommendTableView = UITableView()
    var followingTableView = UITableView()
    var collectionView: UICollectionView?
    var tempView = UIView()
    var countOfCollectionView = 2
    @IBOutlet weak var emptyView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        if !isLogin() {
            goToLogin()
        }
        
        tempView = emptyView

    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.navigationController?.navigationBar.isTransparent = true
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        setUp()
        
        self.contentView.frame = CGRect(x: 0, y: segmentioView.bounds.maxY, width: Device.width, height: contentView.frame.height)
        
        recommendTableView = UITableView(frame: CGRect(x: 10, y: self.contentView.bounds.minY, width: Device.width - 20, height: self.contentView.frame.height))
        followingTableView = UITableView(frame: CGRect(x: 10, y: self.contentView.bounds.minY, width: Device.width - 20, height: self.contentView.frame.height))
        let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        collectionView = UICollectionView(frame: CGRect(x: 0, y: self.contentView.bounds.minY, width: Device.width, height: self.contentView.frame.height), collectionViewLayout: layout)
        
        segmentioView.valueDidChange = { segmentio, segmentIndex in
            if segmentIndex == 2 {
                if self.followingTableView.superview != nil {
                    self.followingTableView.removeFromSuperview()
                }
                if self.collectionView?.superview != nil {
                    self.collectionView?.removeFromSuperview()
                }
                self.contentView.addSubview(self.recommendTableView)
                self.showIndicator()
                RecommendDataManager().getRecommend(viewController: self)
                self.recommendTableView.separatorStyle = .none
                self.recommendTableView.delegate = self
                self.recommendTableView.dataSource = self
                self.recommendTableView.register(UINib(nibName: Constant.recommendCell, bundle: nil), forCellReuseIdentifier: Constant.recommendCell)
            } else if segmentIndex == 1 {
                print(self.followingArray.count)
//                self.showIndicator()
//                FollowingDataManager().getFollowing(viewController: self)
                if self.recommendTableView.superview != nil {
                    self.recommendTableView.removeFromSuperview()
                }
                if self.collectionView?.superview != nil {
                    self.collectionView?.removeFromSuperview()
                }
                if self.followingArray.count < 1 {
                    if self.followingTableView.superview != nil {
                        self.followingTableView.removeFromSuperview()
                    }
                } else {
                    if let emptyView = self.emptyView {
                        if emptyView.superview != nil {
                            emptyView.removeFromSuperview()
                        }
                    }
                    self.contentView.addSubview(self.followingTableView)
                    self.followingTableView.separatorStyle = .none
                    self.followingTableView.delegate = self
                    self.followingTableView.dataSource = self
                    self.followingTableView.register(UINib(nibName: Constant.followingCell, bundle: nil), forCellReuseIdentifier: Constant.followingCell)
                    self.followingTableView.reloadData()
                }
                    
            } else {
                if self.followingTableView.superview != nil {
                    self.followingTableView.removeFromSuperview()
                }
                if self.recommendTableView.superview != nil {
                    self.recommendTableView.removeFromSuperview()
                }
                if self.followingArray.count > 0 {
                    if self.emptyView.superview != nil {
                        self.emptyView.removeFromSuperview()
                    }
                    

                    self.contentView.addSubview(self.collectionView!)
                    self.collectionView?.backgroundColor = .white
                    self.collectionView!.delegate = self
                    self.collectionView!.dataSource = self
                    self.collectionView!.isUserInteractionEnabled = true
                    self.collectionView!.isScrollEnabled = true
                    self.collectionView!.register(UINib(nibName: Constant.homeCollectionViewCell, bundle: nil), forCellWithReuseIdentifier: Constant.homeCollectionViewCell)
                    self.collectionView!.register(UINib(nibName: Constant.feedHeaderView, bundle: nil), forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: Constant.feedHeaderView)
                    self.postArray.removeAll()
                    for result in self.followingArray {
                        for post in result.postData {
                            self.postArray.append(post)
                        }
                    }
                    
                    self.collectionView!.reloadData()
                } else {
                    if self.collectionView?.superview != nil {
                        self.collectionView?.removeFromSuperview()
                    }
                    self.emptyView = self.tempView
                    self.contentView.addSubview(self.emptyView)
                }
            }
            
        }
    }
    
    override func setFollowing(_ result: [FollowingData]) {
        dismissIndicator()
        followingArray = result
        
        followingTableView.reloadData()
    }
    
    func setRecommend(_ result: [FollowingData]) {
        dismissIndicator()
        self.recommendArray = result
        
        self.recommendTableView.reloadData()
    }
    
    func setUp() {
        let segmentioViewRect = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 135)
        segmentioView = Segmentio(frame: segmentioViewRect)
        view.addSubview(segmentioView)
        
        let myFeedItem = SegmentioItem(
            title: "내피드",
            image: UIImage()
        )
        let followingItem = SegmentioItem(
            title: "팔로잉",
            image: UIImage()
        )
        let recommendItem = SegmentioItem(
            title: "추천",
            image: UIImage()
        )
        content.append(myFeedItem)
        content.append(followingItem)
        content.append(recommendItem)
        
        let verticalSepratorOptions = SegmentioVerticalSeparatorOptions(
            ratio: 1, // from 0.1 to 1
            color: .white
        )
        
        let horizontalSeparatorOptions = SegmentioHorizontalSeparatorOptions(
            type: SegmentioHorizontalSeparatorType.topAndBottom, // Top, Bottom, TopAndBottom
            height: 1,
            color: #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
        )
        
        let indicatorOptions = SegmentioIndicatorOptions(
            type: .bottom,
            ratio: 1,
            height: 1.2,
            color: .black
        )
        
        let segmentPosition = SegmentioPosition.fixed(maxVisibleItems: 3)
        
        let segmentStates = SegmentioStates(
            defaultState: SegmentioState(
                backgroundColor: .white,
                titleFont: UIFont.NotoSans(.regular, size: 17),
                titleTextColor: #colorLiteral(red: 0.6000000238, green: 0.6000000238, blue: 0.6000000238, alpha: 1)
            ),
            selectedState: SegmentioState(
                backgroundColor: .white,
                titleFont: UIFont.NotoSans(.regular, size: 17),
                titleTextColor: .black
            ),
            highlightedState: SegmentioState(
                backgroundColor: UIColor.lightGray.withAlphaComponent(0.6),
                titleFont: UIFont.boldSystemFont(ofSize: UIFont.smallSystemFontSize),
                titleTextColor: .black
            )
        )
        
        let options = SegmentioOptions(backgroundColor: .white, segmentPosition: segmentPosition, indicatorOptions: indicatorOptions, horizontalSeparatorOptions: horizontalSeparatorOptions, verticalSeparatorOptions: verticalSepratorOptions, segmentStates: segmentStates)
        
        segmentioView.setup(content: content, style: .onlyLabel, options: options)
        
        segmentioView.selectedSegmentioIndex = 1
        
    }
    
    @IBAction func recommendButtonPressed(_ sender: UIButton) {
        segmentioView.selectedSegmentioIndex = 2
    }
}

extension FollowingViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView == recommendTableView {
            return recommendArray.count
        } else {
            return followingArray.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if tableView == recommendTableView {
            let cell = tableView.dequeueReusableCell(withIdentifier: Constant.recommendCell) as! RecommendCell
            
            let data = recommendArray[indexPath.row]
            
            let user = data.userData[0]
            
            if let isFollowing = data.isFollowing {
                if isFollowing {
                    cell.followingButton.setImage(UIImage(named: "FollowingImage"), for: .normal)
                } else {
                    cell.followingButton.setImage(UIImage(named: "FollowImage"), for: .normal)
                }
            } else {
                cell.followingButton.setImage(UIImage(named: "FollowImage"), for: .normal)
            }
            
            if followingArray.count > 0 {
                for i in followingArray.indices {
                    let userId = followingArray[i].userData[0].userId
                    if user.userId == userId {
                        cell.followingButton.setImage(UIImage(named: "FollowingImage"), for: .normal)
                    }
                    
                }
            }
            
            
            
            cell.followerLabel.text = String(user.follower!)
            cell.itemCountLabel.text = String(user.product!)
            cell.userNameLabel.text = String(user.userName)
            cell.followingButton.tag = indexPath.row
            cell.followingButton.addTarget(self, action: #selector(followingButtonPressed), for: .touchUpInside)
            
            let post = data.postData
            for i in cell.imageViews.indices {
                cell.imageViews[i].setImage(with: post[i].postImgURL)
                cell.priceLabels[i].text = "\(String(post[i].price))원"
            }
            
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: Constant.followingCell) as! FollowingCell
            let data = followingArray[indexPath.row]
            
            let user = data.userData[0]
            
            cell.followerLabel.text = String(user.follower!)
            cell.itemCountLabel.text = String(user.product!)
            cell.userNameLabel.text = String(user.userName)
            
            let post = data.postData
            for i in cell.imageViews.indices {
                cell.imageViews[i].setImage(with: post[i].postImgURL)
                cell.priceLabels[i].text = "\(String(post[i].price))원"
            }
            cell.followingButton.tag = indexPath.row
            cell.followingButton.addTarget(self, action: #selector(unFollowingButtonPressed), for: .touchUpInside)
            
            return cell
        }
        
    }
    
    @objc func unFollowingButtonPressed(_ sender: UIButton) {
        let row = sender.tag
        followingArray.remove(at: row)
        
        followingTableView.reloadData()
        if followingArray.count == 0 {
            self.followingTableView.removeFromSuperview()
            self.emptyView = tempView
            self.contentView.addSubview(emptyView)
            
        }
    }
    
    @objc func followingButtonPressed(_ sender: UIButton) {
        let row = sender.tag
        if let isFollowing = recommendArray[row].isFollowing {
            for i in followingArray.indices {
                if followingArray[i].userData[0].userId == recommendArray[row].userData[0].userId {
                    followingArray.remove(at: i)
                    break
                }
            }
            recommendArray[row].isFollowing = !isFollowing
        } else {
            recommendArray[row].isFollowing = true
            followingArray.append(recommendArray[row])
        }

        recommendTableView.reloadData()
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return Device.width * 0.55
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
}

extension FollowingViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return postArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: Constant.homeCollectionViewCell, for: indexPath) as! HomeCollectionViewCell
        
        

        cell.timeLabel.text = ""
        
        
        let post = postArray[indexPath.row]
        
        cell.imageView.setImage(with: post.postImgURL)
        cell.priceLabel.text = "\(String(post.price))원"
        cell.productNameLabel.text = ""
        if let likeButton = cell.likeButton {
            likeButton.removeFromSuperview()
        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let header = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: Constant.feedHeaderView, for: indexPath) as! FeedHeaderView

        header.headerButton.addTarget(self, action: #selector(headerButtonPressed), for: .touchUpInside)
        return header
    }
    
    @objc func headerButtonPressed(sender: UIButton) {
        if self.countOfCollectionView == 2 {
            sender.setImage(UIImage(named: "threebythree"), for: .normal)
            self.countOfCollectionView = 3
            self.collectionView?.reloadData()
        } else {
            sender.setImage(UIImage(named: "twobytwo"), for: .normal)
            self.countOfCollectionView = 2
            self.collectionView?.reloadData()
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize(width: view.frame.size.width, height: 80)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        var width: CGFloat?
        if countOfCollectionView == 2 {
            width = (self.contentView.frame.width - 10) / 2
        } else {
            width = (self.contentView.frame.width - 20) / 3
        }
        
        let height = width! * 1.3
        return CGSize(width: width!, height: height)
    }
 
}
