//
//  HomeFeedTableViewCell.swift
//  NewsFlyp
//
//  Created by Lohen Yumnam on 05/09/18.
//  Copyright © 2018 Lohen Yumnam. All rights reserved.
//

import UIKit
import Kingfisher

class HomeFeedTableViewCell: UITableViewCell {
    @IBOutlet weak var coverImage: UIImageView!
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var sourceLabel: UILabel!
    @IBOutlet weak var categoriesLabel: UILabel!
    @IBOutlet weak var createdOn: UILabel!
    @IBOutlet weak var likes: UILabel!
    
    @IBOutlet weak var favButton: UIButton!
    @IBOutlet weak var shareButton: UIButton!
    @IBOutlet weak var likeButton: UIButton!
    
    var newFeed: Feed?
    weak var homeViewController: HomeTableViewController?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        favButton.imageView?.contentMode = UIViewContentMode.scaleAspectFit
        shareButton.imageView?.contentMode = UIViewContentMode.scaleAspectFit
        likeButton.imageView?.contentMode = UIViewContentMode.scaleAspectFit
        
        //let playButton  = UIButton(type: .custom)
        favButton.setImage(UIImage(named: "noFav"), for: .normal)
        shareButton.setImage(UIImage(named: "share"), for: .normal)
        likeButton.setImage(UIImage(named: "noLike"), for: .normal)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func updateCellUI(with feed: Feed?,_ homeViewController: HomeTableViewController?) -> () {
        
        if let vc = homeViewController {
            self.homeViewController = vc
        }
        
        if let feed = feed {
            self.newFeed = feed
            // Downloading and setting image for cover Image
            if let url = URL(string: feed.mURL) {
                let resource = ImageResource(downloadURL: url)
                coverImage.kf.setImage(with: resource)
            }
            
            titleLabel.text = feed.title
            descriptionLabel.text = feed.description
            sourceLabel.text = feed.source
            categoriesLabel.text = feed.category
            createdOn.text = feed.createdOn
            likes.text = "\(feed.likes) likes"
            
            if feed.lk == "YES" {
                favButton.setImage(UIImage(named: "Fav"), for: .normal)
            }
            
            if feed.fav == "YES" {
                likeButton.setImage(UIImage(named: "Liked"), for: .normal)
            }
            
            
        }
    }
    
    @IBAction func favButtonTapped(_ sender: UIButton) {
        print("Fav button Tapped")
        
    }
    
    @IBAction func shareButtonTapped(_ sender: UIButton) {
        print("share Button tapped")
        
        guard let newsID = newFeed?.id else { return }
//        print("share")
        guard let homeVC = homeViewController else { return }
        if let url = URL(string: ApiURL.getFeedByIDForWeb.rawValue)?.withQueries(["id": newsID]) {
            let vc = UIActivityViewController(activityItems: [url], applicationActivities: [])
            homeVC.present(vc, animated: true)
        }
//        if let shareURL = URL(string: url) {
//            let vc = UIActivityViewController(activityItems: [shareURL], applicationActivities: [])
//            homeViewController.present(vc, animated: true)
//        }
    }
    @IBAction func likeButtonTapped(_ sender: UIButton) {
        print("Likes Button tapped")
    }
    
}
