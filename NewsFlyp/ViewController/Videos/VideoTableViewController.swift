//
//  VideoTableViewController.swift
//  NewsFlyp
//
//  Created by Lohen Yumnam on 13/09/18.
//  Copyright © 2018 Lohen Yumnam. All rights reserved.
//

import UIKit

class VideoTableViewController: UITableViewController {
    var videoFeed =  [Feed]()
    fileprivate var currentPage = 1
    fileprivate var numPages = 0
    // Will tell if there is any current network request in progress
    var isFetchInProgress: Bool = false
    
    /// View which contains the loading text and the spinner
    let loadingView = UIView()
    /// Spinner shown during load the TableView
    let spinner = UIActivityIndicatorView()
    /// Text shown during load the TableView
    let loadingLabel = UILabel()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Removing the table Cell line while loading
        self.tableView.separatorStyle = .none
        
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
            self?.getVideoFeedData()
        }
        
        // load initial data
        DispatchQueue.main.async { self.tableView.beginInfiniteScroll(true) }
    }
    
    func getVideoFeedData(_ sender: UIRefreshControl? = nil) {
        // center loading screen when no data shows
        if videoFeed.count == 0 { setLoadingScreen() }
        
        // If there is any current request in progress the function will not progress any further
        guard !isFetchInProgress else { return }
        print(" Current Page: \(currentPage)")
        // telling the fetch is in progress now
        isFetchInProgress = true
        
        NetworkController.shared.fetchVideoFeed(withPage: currentPage) { (feed, fetchResultStatus) in
            switch fetchResultStatus {
            case .success :
                // create new index paths
                let currentVideoFeedCount = self.videoFeed.count
                let (start, end) = (currentVideoFeedCount, currentVideoFeedCount + feed!.count)
                let indexPaths = (start..<end).map { return IndexPath(row: $0, section: 0) }
                // update data source
                self.videoFeed.append(contentsOf: feed!)
                self.currentPage += 1
                // update table view
                DispatchQueue.main.async {
                    self.tableView.beginUpdates()
                    self.tableView.insertRows(at: indexPaths, with: .automatic)
                    self.tableView.endUpdates()
                    self.tableView.finishInfiniteScroll()
                    
                    self.removeLoadingScreen()
                }
                // telling the fetch is done, there is nolonger fetch in progress
                self.isFetchInProgress = false
            case .fail :
                print("No Data")
                self.isFetchInProgress = false
            case .noInternetOrServerError :
                print("Network failled")
                self.isFetchInProgress = false
            } // End Of switch fetchResultStatus
            DispatchQueue.main.async { sender?.endRefreshing() }
            
        }
    }

    // MARK: - Table view data source

//    override func numberOfSections(in tableView: UITableView) -> Int {
//        // #warning Incomplete implementation, return the number of sections
//        return 0
//    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return videoFeed.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "videoCell", for: indexPath) as! VideoCell
        cell.updateCellUI(with: videoFeed[indexPath.row], self)
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // This will clear the selection if user select the cell
        if let selectionIndexPath = self.tableView.indexPathForSelectedRow {
            self.tableView.deselectRow(at: selectionIndexPath, animated: true)
        }
    }
    

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
    // MARK:- Pull to refresh
    @IBAction func pullToRefresh(_ sender: UIRefreshControl) {
        // Restting Everything
        currentPage = 1
        videoFeed = [Feed]()
        
        getVideoFeedData(sender)
        DispatchQueue.main.async {
            self.tableView.reloadData()
         }
    }
    

} // End OF VideoTableViewController

// MARK: - TableView Loading
extension VideoTableViewController {
    
    
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
} // End of extension VideoTableViewController
