//
//  HomeTableViewController.swift
//  NewsFlyp
//
//  Created by Lohen Yumnam on 05/09/18.
//  Copyright © 2018 Lohen Yumnam. All rights reserved.
//

import UIKit

class HomeTableViewController: UITableViewController {
    
    var test = ["1", "2", "1", "2" , "1", "2", "1", "2" , "2", "1", "2" , "1", "2", "1", "2" , "2", "1", "2" , "1", "2", "1", "2"]
    
    var descriptionData = "Cras commodo auctor efficitur. Donec eget gravida quam, a faucibus eros. Fusce bibendum finibus eros et fringilla. Aliquam vitae quam sed leo laoreet aliquam ultrices nec nunc. Ut venenatis fermentum dolor quis commodo. Praesent non blandit dui. Nam efficitur ligula ut pellentesque tempor. Nulla id vulputate sapien. Maecenas condimentum molestie pretium Cras commodo auctor efficitur. Donec eget gravida quam, a faucibus eros. Fusce bibendum finibus eros et fringilla. Aliquam vitae quam sed leo laoreet aliquam ultrices nec nunc. Ut venenatis fermentum dolor quis commodo. Praesent non blandit dui. Nam efficitur ligula ut pellentesque tempor. Nulla id vulputate sapien. Maecenas condimentum molestie pretium Cras commodo auctor efficitur. Donec eget gravida quam, a faucibus eros. Fusce bibendum finibus eros et fringilla. Aliquam vitae quam sed leo laoreet aliquam ultrices nec nunc. Ut venenatis fermentum dolor quis commodo. Praesent non blandit dui. Nam efficitur ligula ut pellentesque tempor. Nulla id vulputate sapien. Maecenas condimentum molestie pretium"
    var titleLabelData = "Curabitur non orci non nibh aliquam porta tempus vel turpis Curabitur non orci non nibh aliquam porta tempus vel turpis"
    
    var newsFeed: [Feed]?

    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
        
        NetworkController.shared.fetchHomeFeed { (feed) in
            self.newsFeed = feed
            
            
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

//    override func numberOfSections(in tableView: UITableView) -> Int {
//        // #warning Incomplete implementation, return the number of sections
//        return 1
//    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        print(newsFeed?.count)
        guard let feeds = newsFeed else {return 0}
        return feeds.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "newCell", for: indexPath)
        
        //cell.textLabel?.text = test[indexPath.row]
//        case source = 102
//        case category = 103
        let titleLabel = cell.viewWithTag(TagForView.titleLabel.rawValue) as? UILabel
        let descriptionLabel =  cell.viewWithTag(TagForView.description.rawValue) as? UILabel
        let sourceLabel = cell.viewWithTag(TagForView.source.rawValue) as? UILabel
        let categoryLabel = cell.viewWithTag(TagForView.category.rawValue) as? UILabel
        let created_onLabel = cell.viewWithTag(TagForView.created_on.rawValue) as? UILabel
        let likes = cell.viewWithTag(TagForView.likes.rawValue) as? UILabel
        
        if let feed = newsFeed {
            titleLabel?.text = feed[indexPath.row].title
            descriptionLabel?.text = feed[indexPath.row].description
            sourceLabel?.text = feed[indexPath.row].source
            categoryLabel?.text = feed[indexPath.row].category
            created_onLabel?.text = feed[indexPath.row].createdOn
            likes?.text = feed[indexPath.row].likes
            
        }
        

        return cell
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

}
