//
//  CreateAUserViewController.swift
//  RideSharing
//
//  Created by Karlygash Zhuginissova on 3/8/16.
//  Copyright © 2016 Tarang khanna. All rights reserved.
//

import UIKit
import Parse


class CreateAUserViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    
    @IBOutlet weak var usernameTextField: UITextField!
    
    @IBOutlet weak var firstnameTextField: UITextField!
    @IBOutlet weak var lastnameTextField: UITextField!
    @IBOutlet weak var ageTextField: UITextField!
    @IBOutlet weak var genderTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var passwordAgainTextField: UITextField!
    
    @IBOutlet weak var profilePictureImageView: UIImageView!
    @IBOutlet weak var createUserButton: UIButton!
    
    let newUser = PFUser()
    var phoneNumberPassed: String?
    
    var originalImage: UIImage?
    var editedImage: UIImage?

    override func viewDidLoad() {
        super.viewDidLoad()
        usernameTextField.text = phoneNumberPassed
        print(phoneNumberPassed)
        addGestureForProfileImage()
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: "dismissKeyboard")
        view.addGestureRecognizer(tap)
    }
    
    func dismissKeyboard() {
        view.endEditing(true)
    }

    func addGestureForProfileImage(){
        let gestureRecognizer = UITapGestureRecognizer(target: self, action: "onTapImage:")
        profilePictureImageView.userInteractionEnabled = true
        profilePictureImageView.addGestureRecognizer(gestureRecognizer)

    }

    @IBAction func onCreate(sender: AnyObject) {
        
        
        newUser.username = usernameTextField.text
        newUser["firstName"] = firstnameTextField.text
        newUser["lastName"] = lastnameTextField.text
        newUser["age"] = ageTextField.text
        newUser["gender"] = genderTextField.text
        if passwordTextField.text == passwordAgainTextField.text {
            newUser.password = passwordTextField.text
        } else {
            print("Passwords don't match")
        }
        
        newUser.signUpInBackgroundWithBlock { (success: Bool, error: NSError?) -> Void in
            if let error = error {
                print(error.localizedDescription)
                if (error.code == 202) {
                    print("This phone number is already used by another user")
                }
            } else {
                print("Created a new user")
                self.performSegueWithIdentifier("toMainMenu", sender: nil)
            }
        }
    }
    
    //MARK: - Image Picker
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        originalImage = info[UIImagePickerControllerOriginalImage] as? UIImage
        editedImage = info[UIImagePickerControllerEditedImage] as? UIImage
        profilePictureImageView.image = editedImage
        if (profilePictureImageView.image != nil) {
            let imageData = UIImagePNGRepresentation(profilePictureImageView.image!)
            let imageFile = PFFile(name:"image.png", data:imageData!)
            
            
            newUser["profilePicture"] = imageFile
            newUser.saveInBackground()
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
