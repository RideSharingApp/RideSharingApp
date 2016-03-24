//
//  DetailRideViewController.swift
//  RideSharing
//
//  Created by Akshat Goyal on 3/23/16.
//  Copyright © 2016 Tarang khanna. All rights reserved.
//

import UIKit
import Parse

class DetailRideViewController: UIViewController {

    var ride : PFObject?
    var user: PFUser?
    
    @IBOutlet weak var fromLbl: UILabel!
    @IBOutlet weak var toLbl: UILabel!
    @IBOutlet weak var timeDateLbl: UILabel!
    @IBOutlet weak var seatLbl: UILabel!
    @IBOutlet weak var priceLbl: UILabel!
    @IBOutlet weak var desLbl: UILabel!
    @IBOutlet weak var userImage: UIImageView!
    @IBOutlet weak var userNameLbl: UILabel!
    @IBOutlet weak var userAgeLbl: UILabel!
    @IBOutlet weak var userGenderLbl: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        print(ride)
        setRideDetails()
        let query = PFUser.query()
        let driver = ride!["driver"] as? PFUser
        let driverID = driver!.objectId
        print(driverID!)
        query!.getObjectInBackgroundWithId(driverID!) {
            (user: PFObject?, error: NSError?) -> Void in
            if error == nil {
                self.user = user as? PFUser
                self.setUserDetails()
            } else {
                print(error)
            }
        }
        // Do any additional setup after loading the view.
    }
    
    func setRideDetails() {
        fromLbl.text = ride!["departurePoint"] as? String
        toLbl.text = ride!["arrivalPoint"] as? String
        let date = ride!["dateAndTime"] as! NSDate
        let formatter = NSDateFormatter()
        formatter.dateFormat = "yyyy-MM-dd HH:mm"
        let dateString = formatter.stringFromDate(date)
        timeDateLbl.text = dateString
        seatLbl.text = "\(ride!["seats"] as! Int) Seat(s) available"
        priceLbl.text = "\(ride!["price"])/seat"
        desLbl.text = "\" \(ride!["description"] as! String)\""
        
    }

    func setUserDetails() {
        userNameLbl.text = user!["firstName"] as? String
        userAgeLbl.text = "\((user!["age"] as? String)!) years"
        userGenderLbl.text = user!["gender"] as? String
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
