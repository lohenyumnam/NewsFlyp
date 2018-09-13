//
//  VideoCell.swift
//  NewsFlyp
//
//  Created by Lohen Yumnam on 13/09/18.
//  Copyright © 2018 Lohen Yumnam. All rights reserved.
//

import UIKit

class VideoCell: UITableViewCell {
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var coverImage: UIImageView!
    @IBOutlet weak var sourceLabel: EdgeInsetLabel!
    @IBOutlet weak var newsTypeLabel: EdgeInsetLabel!
    @IBOutlet weak var createdOnLabel: UILabel!
    @IBOutlet weak var likesLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    

}
