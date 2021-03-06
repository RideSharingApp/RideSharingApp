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
    @IBOutlet weak var carMakeAndModel: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.whiteColor()]
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
        desLbl.text = "\"\(ride!["description"] as! String)\""
        
    }

    func setUserDetails() {
        userNameLbl.text = user!["firstName"] as? String
        userAgeLbl.text = "\((user!["age"] as? String)!) years"
        userGenderLbl.text = user!["gender"] as? String
        user!.fetchInBackgroundWithBlock { (object, error) -> Void in
            self.user!.fetchIfNeededInBackgroundWithBlock { (result, error) -> Void in
                self.carMakeAndModel.text = "Car: \((self.user!.objectForKey("CarMakeAndModel") as? String)!)"
            }
        }
        //get profile image
        if let picturefile = user!["profilePicture"] {
            picturefile.getDataInBackgroundWithBlock { (data:NSData?, error:NSError?) -> Void in
                if let data = data {
                    self.userImage.image = UIImage(data: data)
                    print("success")
                }else{
                    print("\(error)")
                }
                
            }
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    @IBAction func onUserViewTap(sender: AnyObject) {
        performSegueWithIdentifier("driverDetailSegue", sender: self)
    }

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        if (segue.identifier == "driverDetailSegue") { //pass data to VC
            let svc = (segue.destinationViewController as! UINavigationController).topViewController as! ProfileViewController
            svc.isCurrentUser = false
            
            svc.firstName = self.user!["firstName"] as? String
            svc.lastName = self.user!["lastName"] as? String
            svc.age = self.user!["age"] as? String
            svc.gender = user!["gender"] as? String
            //svc.carMakeAndModel = user!["CarMakeAndModel"] as? String
            svc.profileImage = userImage.image
            user!.fetchInBackgroundWithBlock { (object, error) -> Void in
                self.user!.fetchIfNeededInBackgroundWithBlock { (result, error) -> Void in
                    svc.carMakeAndModel = self.user!.objectForKey("CarMakeAndModel") as? String
                }
            }
            svc.phoneNumber = user!["username"] as? String
        }
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
