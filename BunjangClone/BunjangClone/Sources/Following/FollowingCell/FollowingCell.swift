//
//  FollowingCell.swift
//  BunjangClone
//
//  Created by 김민순 on 2021/03/26.
//

import UIKit

class FollowingCell: UITableViewCell {
    @IBOutlet var imageViews: [UIImageView]!
    @IBOutlet var priceLabels: [UILabel]!
    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var itemCountLabel: UILabel!
    @IBOutlet weak var followerLabel: UILabel!
    @IBOutlet weak var followingButton: UIButton!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
