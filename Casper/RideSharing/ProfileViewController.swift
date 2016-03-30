//
//  ProfileViewController.swift
//  RideSharing
//
//  Created by Tarang khanna on 3/7/16.
//  Copyright © 2016 Tarang khanna. All rights reserved.
//

import UIKit

class ProfileViewController: UIViewController {
    
    
    
    
    @IBOutlet weak var menuButton: UIBarButtonItem!
   
    @IBOutlet weak var firstNameLabel: UILabel!
    
    
    @IBOutlet var profileImageView: AvatarImageView!
    @IBOutlet weak var lastNameLabel: UILabel!
    
    
    @IBOutlet weak var carLabel: UILabel!
    
    @IBOutlet weak var genderLabel: UILabel!
    
    @IBOutlet weak var ageLabel: UILabel!
    
    @IBOutlet weak var callBtn: UIButton!
    @IBOutlet weak var phoneNumberLbl: UILabel!
    
    var firstName : String?
    var lastName : String?
    var age : String?
    var phoneNumber: String?
    var gender: String?
    var profileImage:UIImage?
    var carMakeAndModel: String?
    
    var isCurrentUser = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if self.revealViewController() != nil {
            menuButton.target = self.revealViewController()
            menuButton.action = "revealToggle:"
            self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
        }
        // Do any additional setup after loading the view.
        
        loadData()
    }
    
    func loadData() {
        firstNameLabel.text = firstName
        lastNameLabel.text = lastName
        genderLabel.text = gender
        ageLabel.text = age
        print(carMakeAndModel)
        if (carMakeAndModel == nil) {
            carLabel.text = "No car added!"
        } else {
            carLabel.text = carMakeAndModel
        }
        if(isCurrentUser) {
            callBtn.hidden = true
        }
        self.profileImageView.image = profileImage
        self.phoneNumberLbl.text = phoneNumber
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    @IBAction func callClicked(sender: AnyObject) {
        
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
