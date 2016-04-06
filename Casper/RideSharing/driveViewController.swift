//
//  driveViewController.swift
//  RideSharing
//
//  Created by Tarang khanna on 3/7/16.
//  Copyright © 2016 Tarang khanna. All rights reserved.
//

import UIKit
import MaterialKit
import SCLAlertView

class driveViewController: UIViewController {
    
    
    @IBOutlet weak var menuButton: UIBarButtonItem!
    
    
    
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
    @IBOutlet weak var desTxt: MKTextField!
    @IBOutlet weak var priceTxt: MKTextField!
    @IBOutlet weak var dateView: UIDatePicker!
    @IBOutlet weak var toTxt: MKTextField!
    @IBOutlet weak var fronTxt: MKTextField!
    @IBOutlet weak var seats: MKTextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.whiteColor()]
        
        desTxt.layer.borderColor = UIColor.clearColor().CGColor
        desTxt.floatingPlaceholderEnabled = true
        desTxt.cornerRadius = 0
        desTxt.bottomBorderEnabled = true
        
        //        desTxt.tintColor = UIColor.MKColor.Blue
        
        //        desTxt.rippleLocation = .Right
        
        priceTxt.layer.borderColor = UIColor.clearColor().CGColor
        priceTxt.floatingPlaceholderEnabled = true
        priceTxt.cornerRadius = 0
        priceTxt.bottomBorderEnabled = true
        
        fronTxt.layer.borderColor = UIColor.clearColor().CGColor
        fronTxt.floatingPlaceholderEnabled = true
        fronTxt.cornerRadius = 0
        fronTxt.bottomBorderEnabled = true
        
        toTxt.layer.borderColor = UIColor.clearColor().CGColor
        toTxt.floatingPlaceholderEnabled = true
        toTxt.cornerRadius = 0
        toTxt.bottomBorderEnabled = true
        
        seats.layer.borderColor = UIColor.clearColor().CGColor
        seats.floatingPlaceholderEnabled = true
        seats.cornerRadius = 0
        seats.bottomBorderEnabled = true
        
        
        
        if self.revealViewController() != nil {
            menuButton.target = self.revealViewController()
            menuButton.action = "revealToggle:"
            self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
        }
        
        // Do any additional setup after loading the view.
    }
    
    
    @IBAction func onPost(sender: AnyObject) {
        let formatter = NSDateFormatter()
        formatter.dateFormat = "MMM d, yyyy, HH:mm"
        let createdString = "\(dateView.date)"
//        print(createdString)
        let date = formatter.dateFromString(createdString)
//        print(date)
        
        if(fronTxt.text == "" || toTxt.text == "" || priceTxt.text == "" || desTxt.text == "") {
            print("empty text field")
            SCLAlertView().showError("Empty textfield(s)", subTitle: "One of the textfields is empty") // Error
            
        } else {
            Ride.postRide(fronTxt.text, arrivalPoint: toTxt.text, dateAndTime: dateView.date, price: priceTxt.text, description: desTxt.text, availability: true, seats: Int(seats.text!)) { (success: Bool, error: NSError?) -> Void in
                if (success) {
                    print("success")
                    // segue
                    self.performSegueWithIdentifier("posted", sender: self)
                }
                if error != nil {
                    // popup error
                    print(error)
                }
            }
        }
    }
}
