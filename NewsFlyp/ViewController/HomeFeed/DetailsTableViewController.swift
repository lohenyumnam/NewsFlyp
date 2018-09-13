//
//  DetailsTableViewController.swift
//  NewsFlyp
//
//  Created by Lohen Yumnam on 09/09/18.
//  Copyright © 2018 Lohen Yumnam. All rights reserved.
//

import UIKit
import Kingfisher
import SafariServices

class DetailsTableViewController: UITableViewController {
    @IBOutlet weak var coverImage: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var categoriesLabel: EdgeInsetLabel!
    @IBOutlet weak var createdOnLabel: UILabel!
    @IBOutlet weak var likesLabel: UILabel!
    @IBOutlet weak var favButton: UIButton!
    @IBOutlet weak var likesButton: UIButton!
    @IBOutlet weak var shareBarButton: UIBarButtonItem!
    @IBOutlet weak var readMoreButton: UIButton!
    
    var feed: Feed?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if let newsID = feed?.id { fetchData(by: newsID) } // Fetch Data by ID to get the url
        if let feed = feed { self.displayData(with: feed) } // Display the old data
        
        self.tableView.separatorStyle = .none
        
        // will disable share and read more if no news url found
        shareBarButton.isEnabled = false
        readMoreButton.isEnabled = false
    }
    
    func fetchData(by id : String) {
        NetworkController.shared.fetchFeed(withID: id) { (feed, fetchResultStatus) in
            switch fetchResultStatus {
            case .success :
                if let feed = feed?.first {
                    self.displayData(with: feed) // Displaying new data
                    self.feed = feed
                }
            case .fail :
                print("No Data")
            case .noInternetOrServerError :
                print("Network failled")
             }
        }
    }
    
    func displayData(with feed : Feed) {
        
        DispatchQueue.main.async {
            if let url = URL(string: feed.mURL) {
                let resource = ImageResource(downloadURL: url)
                self.coverImage.kf.setImage(with: resource)
            }
            self.navigationItem.title = feed.source
            
            self.titleLabel.text = feed.title
            self.descriptionLabel.text = feed.description
            self.categoriesLabel.text = feed.category
            
            
            self.createdOnLabel.text = feed.createdOn
            self.likesLabel.text = "\(feed.likes) likes"
            
            if feed.lk == "YES" {
                self.favButton.setImage(UIImage(named: "Fav"), for: .normal)
            }
            
            if feed.fav == "YES" {
                self.likesButton.setImage(UIImage(named: "Liked"), for: .normal)
            }
            
            if let _ = feed.xUrl {
                //will enable share button as soon as news url found
                self.shareBarButton.isEnabled = true
                self.readMoreButton.isEnabled = true
                
                print("Button Enable")
            }
        }
    }

    @IBAction func likeButtonTapped(_ sender: UIButton) {
        print("likes Button Tapped")
    }
    
    @IBAction func favButtonTapped(_ sender: UIButton) {
        print("Fav Button Tapped")
    }
    
    @IBAction func readMoreButtonTapped(_ sender: UIButton) {
        if let id = feed?.id {
          openSafariWebView(with: id)
        }
        
    }
    
    @IBAction func shareBarButtonTapped(_ sender: UIBarButtonItem) {
        guard let urlString = feed?.xUrl else { return }
        if let shareURL = URL(string: urlString) {
            let vc = UIActivityViewController(activityItems: [shareURL], applicationActivities: [])
            present(vc, animated: true)
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // This will clear the selection if user select the cell
        if let selectionIndexPath = self.tableView.indexPathForSelectedRow {
            self.tableView.deselectRow(at: selectionIndexPath, animated: true)
        }
    }
}

extension DetailsTableViewController: SFSafariViewControllerDelegate {
    
    // Open The news in safariViewController
    func openSafariWebView(with id : String){
        
        if let urlString = feed?.xUrl, let url = URL(string: urlString) {
            if #available(iOS 11.0, *) {
                let config = SFSafariViewController.Configuration()
                config.entersReaderIfAvailable = true
                let safariVC = SFSafariViewController(url: url, configuration: config)
                present(safariVC, animated: true, completion: nil)
            } else {
                // Fallback on earlier versions
                let vc = SFSafariViewController(url: url, entersReaderIfAvailable: true)
                vc.delegate = self
                
                present(vc, animated: true)
            }
        }
        
        
    }
    
    func safariViewControllerDidFinish(_ controller: SFSafariViewController) {
        dismiss(animated: true)
    }
}
