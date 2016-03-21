//
//  driveViewController.swift
//  RideSharing
//
//  Created by Tarang khanna on 3/7/16.
//  Copyright © 2016 Tarang khanna. All rights reserved.
//

import UIKit

class driveViewController: UIViewController {
    
    
    @IBOutlet weak var menuButton: UIBarButtonItem!

    override func viewDidLoad() {
        super.viewDidLoad()
        if self.revealViewController() != nil {
            menuButton.target = self.revealViewController()
            menuButton.action = "revealToggle:"
            self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
        }

        // Do any additional setup after loading the view.
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
    @IBOutlet weak var availSwitch: UISwitch!
    @IBOutlet weak var desTxt: UITextField!
    @IBOutlet weak var priceTxt: UITextField!
    @IBOutlet weak var dateView: UIDatePicker!
    @IBOutlet weak var toTxt: UITextField!
    @IBOutlet weak var fronTxt: UITextField!

    @IBAction func onPost(sender: AnyObject) {
        let formatter = NSDateFormatter()
        formatter.dateFormat = "MMM d, yyyy, HH:mm"
        let createdString = "\(dateView.date)"
        print(createdString)
        let date = formatter.dateFromString(createdString)
        print(date)
        
        Ride.postRide(fromTxt.text, arrivalPoint: toTxt.text, dateAndTime: dateView.date, price: priceTxt.text, description: desTxt.text, availability: true) { (success: Bool, error: NSError?) -> Void in
            if (success) {
                print("success")
            }
            if error != nil {
                print(error)
            }
        }
    }
}
