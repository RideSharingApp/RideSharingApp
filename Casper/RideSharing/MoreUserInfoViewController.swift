//
//  MoreUserInfoViewController.swift
//  RideSharing
//
//  Created by Karlygash Zhuginissova on 4/7/16.
//  Copyright © 2016 Tarang khanna. All rights reserved.
//

import UIKit
import Parse

class MoreUserInfoViewController: UIViewController {
    
    @IBOutlet weak var addToProfileInfoButton: UIButton!
    @IBOutlet weak var ageTextField: UITextField!
    @IBOutlet weak var genderTextField: UITextField!
    @IBOutlet weak var carMakeAndModel: UITextField!

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    

    @IBAction func onAddToProfileInfo(sender: AnyObject) {
        let createdUser = PFUser.currentUser()
        createdUser!["age"] = ageTextField.text
        createdUser!["gender"] = genderTextField.text
        createdUser!["CarMakeAndModel"] = carMakeAndModel.text
        createdUser!.saveInBackgroundWithBlock {
            (success: Bool, error: NSError?) -> Void in
            if (success) {
                // The object has been saved.
                self.performSegueWithIdentifier("toMainMenu", sender: nil)
            } else {
                // There was a problem, check error.description
            }
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
