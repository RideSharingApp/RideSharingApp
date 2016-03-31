//
//  ProfileViewController.swift
//  RideSharing
//
//  Created by Tarang khanna on 3/7/16.
//  Copyright © 2016 Tarang khanna. All rights reserved.
//

import UIKit
import Parse

class ProfileViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
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
        
        addGestureForProfileImage()
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: "dismissKeyboard")
        view.addGestureRecognizer(tap)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    @IBAction func onBack(sender: AnyObject) {
        
    }
    
    @IBAction func callClicked(sender: AnyObject) {
        
    }
    
    func addGestureForProfileImage(){
        let gestureRecognizer = UITapGestureRecognizer(target: self, action: "onTapImage:")
        profileImageView.userInteractionEnabled = true
        profileImageView.addGestureRecognizer(gestureRecognizer)
    }
    
    //MARK: - Image Picker
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
//        let originalImage = info[UIImagePickerControllerOriginalImage] as? UIImage
        let editedImage = info[UIImagePickerControllerEditedImage] as? UIImage
        profileImageView.image = editedImage
        if (profileImageView.image != nil) {
            let imageData = UIImagePNGRepresentation(profileImageView.image!)
            let imageFile = PFFile(name:"image.png", data:imageData!)
            
            let user = PFUser.currentUser()
            user!["profilePicture"] = imageFile
            user!.saveInBackground()
        } else {
            print("No picture")
        }
        
        self.dismissViewControllerAnimated(true, completion: nil)
        
    }

    
    func onTapImage(sender: UITapGestureRecognizer) {
        //let imageView = sender.view as! UIImageView
        print("TAPPED")
        let alert = UIAlertController(title: "Post a photo", message: "Upload from library or take a picture", preferredStyle: .ActionSheet)
        let actionOne = UIAlertAction(title: "Upload from library", style: .Default) { (action: UIAlertAction) -> Void in
            if UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.PhotoLibrary) {
                let vc = UIImagePickerController()
                vc.delegate = self
                vc.allowsEditing = true
                vc.sourceType = UIImagePickerControllerSourceType.PhotoLibrary
                
                self.presentViewController(vc, animated: true, completion: nil)
            }
            
        }
        
        let actionTwo = UIAlertAction(title: "Take a picture", style: .Default) { (action: UIAlertAction) -> Void in
            if UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.Camera) {
                
                let vc = UIImagePickerController()
                vc.delegate = self
                vc.allowsEditing = true
                vc.sourceType = UIImagePickerControllerSourceType.Camera
                
                self.presentViewController(vc, animated: true, completion: nil)
                
            }
            print("Unavailable")
        }
        let actionCancel = UIAlertAction(title: "Cancel", style: .Cancel) { (action: UIAlertAction) -> Void in
            
        }
        alert.addAction(actionOne)
        alert.addAction(actionTwo)
        alert.addAction(actionCancel)
        self.presentViewController(alert, animated: true, completion: nil)
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
