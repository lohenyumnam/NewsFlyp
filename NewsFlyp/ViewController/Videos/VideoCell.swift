//
//  VideoCell.swift
//  NewsFlyp
//
//  Created by Lohen Yumnam on 13/09/18.
//  Copyright © 2018 Lohen Yumnam. All rights reserved.
//

import UIKit
import Kingfisher

class VideoCell: UITableViewCell {
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var coverImage: UIImageView!
    @IBOutlet weak var sourceLabel: EdgeInsetLabel!
    @IBOutlet weak var categoriesLabel: EdgeInsetLabel!
    @IBOutlet weak var createdOnLabel: UILabel!
    @IBOutlet weak var likesLabel: UILabel!
    
    @IBOutlet weak var favButton: UIButton!
    @IBOutlet weak var likeButton: UIButton!
    
    
    var videoFeed: Feed?
    weak var videoViewController: VideoTableViewController?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func updateCellUI(with feed: Feed?,_ videoViewController: VideoTableViewController?) -> () {
        
        if let vc = videoViewController {
            self.videoViewController = vc
        }
        
        if let feed = feed {
            self.videoFeed = feed
            // Downloading and setting image for cover Image
            let urlString = "https://img.youtube.com/vi/\(feed.mURL)/mqdefault.jpg"
            if let url = URL(string: urlString) {
                let resource = ImageResource(downloadURL: url)
                coverImage.kf.setImage(with: resource)
            }
            
            titleLabel.text = feed.title
            //descriptionLabel.text = feed.description
            sourceLabel.text = feed.source
            categoriesLabel.text = feed.category
            createdOnLabel.text = feed.createdOn
            likesLabel.text = Int(feed.likes)! > 1 ? "\(feed.likes) likes" : "\(feed.likes) like"
            
            if feed.lk == "YES" {
                favButton.setImage(UIImage(named: "Fav"), for: .normal)
            }
            
            if feed.fav == "YES" {
                likeButton.setImage(UIImage(named: "Liked"), for: .normal)
            }
            
            
        }
    } // End OF updateCellUI
    
    @IBAction func shareButtonTapped(_ sender: UIButton) {
        print("share Button tapped")
        
        guard let newsID = videoFeed?.id else { return }
        //        print("share")
        guard let homeVC = videoViewController else { return }
        if let url = URL(string: ApiURL.getFeedByIDForWeb.rawValue)?.withQueries(["id": newsID]) {
            let vc = UIActivityViewController(activityItems: [url], applicationActivities: [])
            homeVC.present(vc, animated: true)
        }
        //        if let shareURL = URL(string: url) {
        //            let vc = UIActivityViewController(activityItems: [shareURL], applicationActivities: [])
        //            homeViewController.present(vc, animated: true)
        //        }
    }

}
