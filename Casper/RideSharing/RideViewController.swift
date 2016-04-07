//
//  RideViewController.swift
//  RideSharing
//
//  Created by Tarang khanna on 3/7/16.
//  Copyright © 2016 Tarang khanna. All rights reserved.
//

import UIKit
import Parse
import DGElasticPullToRefresh
import DGActivityIndicatorView
import ElasticTransition

class RideViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate, UITextFieldDelegate {
    
    var searchActive : Bool = false
    
    @IBOutlet weak var menuButton: UIBarButtonItem!
    var info:[PFObject]!
    var filteredInfo:[PFObject]!
    
    var shouldShowSearchResults = false
    var customSearchController: CustomSearchController!
    //    var searchBar:UISearchBar = UISearchBar(frame: CGRectMake(0, 200, 200, 20))
    //    lazy var searchBar2:UISearchBar = UISearchBar(frame: CGRectMake(0, 200, 200, 20))
    var searchBar = UISearchBar()
    @IBOutlet weak var tableView: UITableView!
    
    let activityIndicatorView = DGActivityIndicatorView(type: DGActivityIndicatorAnimationType.RotatingSquares, tintColor: UIColor(red: 78/255.0, green: 221/255.0, blue: 200/255.0, alpha: 1.0), size: 70.0)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        searchActive = false
        
        if self.revealViewController() != nil {
            menuButton.target = self.revealViewController()
            menuButton.action = "revealToggle:"
            self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
        }
        
        self.tableView.separatorStyle = UITableViewCellSeparatorStyle.None
        
        searchBar.delegate = self
        //configureCustomSearchController()
        searchBar.sizeToFit()
        navigationItem.titleView = searchBar
        
        
        tableView.delegate = self
        tableView.dataSource = self
        
        retrieve();
        
        // Pull to refresh
        let loadingView = DGElasticPullToRefreshLoadingViewCircle()
        loadingView.tintColor = UIColor.whiteColor()
        tableView.dg_addPullToRefreshWithActionHandler({ [weak self] () -> Void in
            self!.retrieve()
            self?.tableView.dg_stopLoading()
            }, loadingView: loadingView)
        tableView.dg_setPullToRefreshFillColor(UIColor.redColor())
        tableView.dg_setPullToRefreshBackgroundColor(tableView.backgroundColor!)
        
        // Do any additional setup after loading the view.
    }
    
    func retrieve() {
        let query = PFQuery(className: "Ride")
        query.orderByDescending("createdAt")
        query.includeKey("author")
        query.limit = 20
        
        // fetch data asynchronously
        query.findObjectsInBackgroundWithBlock { (info: [PFObject]?, error: NSError?) -> Void in
            if let info = info {
                // do something with the data fetched
                self.info = info
                self.filteredInfo = info
                //print(info)
            } else {
                // handle error
                print("\(error)")
            }
            self.tableView.reloadData()
        }
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = self.tableView.dequeueReusableCellWithIdentifier("RideCell", forIndexPath: indexPath) as! RideTableViewCell
        var info = self.info[indexPath.row]
        //        if(filteredInfo.count != 0) {
        //            info = self.filteredInfo[indexPath.row]
        //        } else {
        //            info = self.info[indexPath.row]
        //        }
        
        cell.fromLabel.text = "\(info["departurePoint"] as! String) - \(info["arrivalPoint"] as! String)"

//        cell.tolabel.text = info["arrivalPoint"] as! String
        
        let olddate = info["dateAndTime"] as! NSDate
        let formatter = NSDateFormatter()
        formatter.dateFormat = "yyyy-MM-dd HH:mm"
        let date = formatter.stringFromDate(olddate)
        cell.timeLabel.text = "\(date)"
        cell.priceLabel.text = (info["price"] as! String)+"$"
        cell.seatLabel.text = String(info["seats"] as! Int)
        cell.timeLabel.sizeToFit()
        let query = PFUser.query()
        let driver = info["driver"] as? PFUser
        let driverID = driver!.objectId
        print(driverID!)
        query!.getObjectInBackgroundWithId(driverID!) {
            (user: PFObject?, error: NSError?) -> Void in
            //get profile image
            if user != nil{
                if let picturefile = user!["profilePicture"] {
                    picturefile.getDataInBackgroundWithBlock { (data:NSData?, error:NSError?) -> Void in
                        if let data = data {
                            cell.profileImage.image = UIImage(data: data)
                            print("success")
                        }else{
                            print("\(error)")
                        }
                        
                    }
                }else{
                    cell.profileImage.image = UIImage(named: "user-icon-placeholder")
                }
            }
            
        }
        return cell
    }
    
    func searchBar(searchBar: UISearchBar, textDidChange searchText: String) {
        //        print("Searching!!!")
        if searchText.isEmpty {
            filteredInfo = info
        } else {
            let query = PFQuery(className: "Ride")
            query.orderByDescending("createdAt")
            query.includeKey("author")
            print("Searching for \(searchText)")
            query.whereKey("departurePoint", containsString: searchText)
            query.limit = 20
            
            // fetch data asynchronously
            query.findObjectsInBackgroundWithBlock { (info: [PFObject]?, error: NSError?) -> Void in
                if let info = info {
                    // do something with the data fetched
                    self.info = info
                    
                    //print(info)
                } else {
                    // handle error
                    print("\(error)")
                }
                self.tableView.reloadData()
            }
        }
        if searchText.characters.count > 0 {
            searchActive = true
        } else {
            searchActive = false
            retrieve()
            //            searchBar.resignFirstResponder()
        }
        
    }
    
    func searchBarSearchButtonClicked(searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
    }
    
    func searchBarCancelButtonClicked(searchBar: UISearchBar) {
        //        self.filteredInfo = []
        //        self.tableView.reloadData()
        retrieve()
        self.searchBar.resignFirstResponder()
        self.searchBar.text = ""
        searchBar.showsCancelButton = false
        searchActive = false
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        self.tableView.deselectRowAtIndexPath(indexPath, animated: true)
        self.performSegueWithIdentifier("detailRideSegue", sender: indexPath)
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let info = self.info{
            return info.count
        }else{
            return 0
        }
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "detailRideSegue" {
            let vc = segue.destinationViewController as! DetailRideViewController
            let indexPath = sender as! NSIndexPath
            let ride = self.info[indexPath.row]
            vc.ride = ride
        }
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //    func configureCustomSearchController() {
    //        customSearchController = CustomSearchController(searchResultsController: self, searchBarFrame: CGRectMake(0.0, 0.0, tableView.frame.size.width, 50.0), searchBarFont: UIFont(name: "Futura", size: 16.0)!, searchBarTextColor: UIColor.orangeColor(), searchBarTintColor: UIColor.blackColor())
    //
    //        customSearchController.customSearchBar.placeholder = "Custom Search..."
    //        navigationItem.titleView = customSearchController.customSearchBar
    //        //tableView.tableHeaderView = customSearchController.customSearchBar
    //
    ////        customSearchController.customDelegate = self
    //    }
    
    
    deinit {
        tableView.dg_removePullToRefresh()
    }
    
    // MARK: UISearchResultsUpdating delegate function
    
    func updateSearchResultsForSearchController(searchController: UISearchController) {
        guard let searchString = searchController.searchBar.text else {
            return
        }
        
        // Note: Filter the data array and get only those that match the search text.
        
        
        // Reload the tableview.
        tableView.reloadData()
    }
    
    
    // MARK: CustomSearchControllerDelegate functions
    //
    //    func didStartSearching() {
    //        shouldShowSearchResults = true
    //        tableView.reloadData()
    //    }
    //
    //
    //    func didTapOnSearchButton() {
    //        if !shouldShowSearchResults {
    //            shouldShowSearchResults = true
    //            tableView.reloadData()
    //        }
    //    }
    //
    //
    //    func didTapOnCancelButton() {
    //        shouldShowSearchResults = false
    //        tableView.reloadData()
    //    }
    //
    //
    //    func didChangeSearchText(searchText: String) {
    //        // Filter the data array and get only those that match the search text.
    //        // Note: Add code to filter
    //
    //        // Reload the tableview.
    //        tableView.reloadData()
    //    }
    
}

extension UIScrollView {
    // to fix a problem where all the constraints of the tableview
    // are deleted
    func dg_stopScrollingAnimation() {}
}

