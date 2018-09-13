//
//  HomeTableViewController.swift
//  NewsFlyp
//
//  Created by Lohen Yumnam on 05/09/18.
//  Copyright © 2018 Lohen Yumnam. All rights reserved.
//

import UIKit
import Kingfisher

private let useAutosizingCells = true

class HomeTableViewController: UITableViewController {
    
    
    var newsFeed =  [Feed]()
    fileprivate var currentPage = 1
    fileprivate var numPages = 0
    
    var isFetchInProgress: Bool = false // Will tell if there is any current network request in progress
    
    /// View which contains the loading text and the spinner
    let loadingView = UIView()
    
    /// Spinner shown during load the TableView
    let spinner = UIActivityIndicatorView()
    
    /// Text shown during load the TableView
    let loadingLabel = UILabel()


    override func viewDidLoad() {
        super.viewDidLoad()
//        getHomeFeedData()
        
        // Removing the table Cell line while loading
        self.tableView.separatorStyle = .none

        
//        if useAutosizingCells && tableView.responds(to: #selector(getter: UIView.layoutMargins)) {
//            tableView.estimatedRowHeight = 88
//            tableView.rowHeight = UITableViewAutomaticDimension
//        }
        // Setting Up Infinity Scroll
        DispatchQueue.main.async {
            // Set custom indicator
            self.tableView.infiniteScrollIndicatorView = CustomInfiniteIndicator(frame: CGRect(x: 0, y: 0, width: 24, height: 24))
            // Set custom indicator margin
            self.tableView.infiniteScrollIndicatorMargin = 10
            // Set custom trigger offset
            self.tableView.infiniteScrollTriggerOffset = 0 //500
        }
        
        // Add infinite scroll handler (fetch the data here for next pages)
        tableView.addInfiniteScroll { [weak self] (tableView) -> Void in
            self?.getHomeFeedData()
        }

        // load initial data
        DispatchQueue.main.async { self.tableView.beginInfiniteScroll(true) }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func getHomeFeedData(_ sender: UIRefreshControl? = nil) {
        
        // center loading screen when no data shows
        if newsFeed.count == 0 {
            setLoadingScreen()
        }
        
        // If there is any current request in progress the function will not progress any further
        guard !isFetchInProgress else { return }
        print(" Current Page: \(currentPage)")
        
        isFetchInProgress = true // telling the fetch is in progress now
        
        NetworkController.shared.fetchHomeFeed(withPage: currentPage) { (feed, fetchResultStatus) in

            switch fetchResultStatus {
                
            case .success :
                // create new index paths
                let currentNewsFeedCount = self.newsFeed.count
                let (start, end) = (currentNewsFeedCount, currentNewsFeedCount + feed!.count)
                let indexPaths = (start..<end).map { return IndexPath(row: $0, section: 0) }
                
                // update data source
                self.newsFeed.append(contentsOf: feed!)
                self.currentPage += 1
                
                // update table view
                DispatchQueue.main.async {
                    self.tableView.beginUpdates()
                    self.tableView.insertRows(at: indexPaths, with: .automatic)
                    self.tableView.endUpdates()
                    self.tableView.finishInfiniteScroll()
                    
                    self.removeLoadingScreen()
                }
                
                self.isFetchInProgress = false // telling the fetch is done, there is nolonger fetch in progress
                //self.currentPage += 1
            case .fail :
                print("No Data")
                self.isFetchInProgress = false
            case .noInternetOrServerError :
                print("Network failled")
                self.isFetchInProgress = false
            }
            DispatchQueue.main.async {
                sender?.endRefreshing()
            }
            
        }
    }
    
    

    // MARK: - Table view data source
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return newsFeed.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "newCell", for: indexPath) as! HomeFeedTableViewCell
        cell.updateCellUI(with: newsFeed[indexPath.row], self)
       return cell
    }
  
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        
        if segue.identifier == "goToDetails" {
            let destination = segue.destination as! DetailsTableViewController
            guard let indexPath = self.tableView.indexPathForSelectedRow else {return}
            
            //destination.newsID = newsFeed[indexPath.row].id
            destination.feed = newsFeed[indexPath.row]
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // This will clear the selection if user select the cell
        if let selectionIndexPath = self.tableView.indexPathForSelectedRow {
            self.tableView.deselectRow(at: selectionIndexPath, animated: true)
        }
    }

    
    // MARK:- Pull to refresh
    @IBAction func pullToRefresh(_ sender: UIRefreshControl) {
        
        // Restting Everything
        currentPage = 1
        newsFeed = [Feed]()
        
        getHomeFeedData(sender)
        DispatchQueue.main.async {
            self.tableView.reloadData()
            
        }
    }
    
}


// MARK: - TableView Loading
extension HomeTableViewController {
    
    
    private func setLoadingScreen() {
        
        // Sets the view which contains the loading text and the spinner
        let width: CGFloat = 120
        let height: CGFloat = 30
        let x = (tableView.frame.width / 2) - (width / 2)
        let y = (tableView.frame.height / 2) - (height / 2) - (navigationController?.navigationBar.frame.height)!
        loadingView.frame = CGRect(x: x, y: y, width: width, height: height)
        
        
        
        
        // Sets loading text
        loadingLabel.textColor = .gray
        loadingLabel.textAlignment = .center
        loadingLabel.text = "Loading..."
        loadingLabel.frame = CGRect(x: 0, y: 0, width: 140, height: 30)
        
        // Sets spinner
        spinner.activityIndicatorViewStyle = .gray
        spinner.frame = CGRect(x: 0, y: 0, width: 30, height: 30)
        spinner.startAnimating()
        
        // Adds text and spinner to the view
        loadingView.addSubview(spinner)
        loadingView.addSubview(loadingLabel)
        
        tableView.addSubview(loadingView)
        
    }
    
    // Remove the activity indicator from the main view
    private func removeLoadingScreen() {
        
        // Hides and stops the text and the spinner
        spinner.stopAnimating()
        spinner.isHidden = true
        loadingLabel.isHidden = true
        
        // Adding table cell line while loading
        self.tableView.separatorStyle = .singleLine

        
    }
}
