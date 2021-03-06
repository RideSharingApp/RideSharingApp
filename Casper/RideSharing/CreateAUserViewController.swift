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
    
    @IBOutlet weak var userNameAsPhoneNumberLabel: UILabel!
    
    //@IBOutlet weak var usernameTextField: UITextField!
    
    @IBOutlet weak var firstnameTextField: UITextField!
    @IBOutlet weak var lastnameTextField: UITextField!

    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var passwordAgainTextField: UITextField!
    

    @IBOutlet weak var profilePictureImageView: UIImageView!
    @IBOutlet weak var createUserButton: UIButton!
    @IBOutlet weak var errorDescriptionLabel: UILabel!
    
    let newUser = PFUser()
    var phoneNumberPassed: String?
    
    var originalImage: UIImage?
    var editedImage: UIImage?

    override func viewDidLoad() {
        super.viewDidLoad()
        userNameAsPhoneNumberLabel.text = phoneNumberPassed
        print(phoneNumberPassed)
        addGestureForProfileImage()
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: "dismissKeyboard")
        view.addGestureRecognizer(tap)
        errorDescriptionLabel.hidden = true
        
        passwordTextField.secureTextEntry = true
        passwordAgainTextField.secureTextEntry = true
        
    }
    
    func dismissKeyboard() {
        view.endEditing(true)
    }

    func addGestureForProfileImage(){
        let gestureRecognizer = UITapGestureRecognizer(target: self, action: "onTapImage:")
        profilePictureImageView.userInteractionEnabled = true
        profilePictureImageView.addGestureRecognizer(gestureRecognizer)

    }
    
    func getPFFileFromImage(image: UIImage?) -> PFFile? {
        // check if image is not nil
        if let image = image {
            // get image data and check if that is not nil
            if let imageData = UIImagePNGRepresentation(image) {
                return PFFile(name: "image.png", data: imageData)
            }
        }
        return nil
    }

    @IBAction func onCreate(sender: AnyObject) {
        let anim = CAKeyframeAnimation( keyPath:"transform" )
        anim.values = [
            NSValue( CATransform3D:CATransform3DMakeTranslation(-5, 0, 0 ) ),
            NSValue( CATransform3D:CATransform3DMakeTranslation( 5, 0, 0 ) )
        ]
        anim.autoreverses = true
        anim.repeatCount = 2
        anim.duration = 7/100

        newUser.username = userNameAsPhoneNumberLabel.text
        newUser["firstName"] = firstnameTextField.text
        newUser["lastName"] = lastnameTextField.text

        newUser["profilePicture"] = getPFFileFromImage(self.profilePictureImageView.image)
        if passwordTextField.text == passwordAgainTextField.text {
            if (passwordAgainTextField.text?.characters.count) > 5 {
                let digits = NSCharacterSet.decimalDigitCharacterSet()
                let passw = passwordAgainTextField.text
                if (passw!.rangeOfCharacterFromSet(digits) != nil) {
                    
                    self.newUser.password = self.passwordTextField.text
                    
                } else {
                    errorDescriptionLabel.hidden = false
                    errorDescriptionLabel.text = "Your password doesn't contain a digit, please try again"
                    passwordTextField.textColor = UIColor.setPrimaryRedColor()
                    passwordAgainTextField.textColor = UIColor.setPrimaryRedColor()
                    passwordTextField.layer.addAnimation( anim, forKey:nil)
                    passwordAgainTextField.layer.addAnimation( anim, forKey:nil)
                    
                    print("Passsword doesn't contain a digit")
                }
            } else {
                errorDescriptionLabel.hidden = false
                errorDescriptionLabel.text = "Your password is less than 6 characters, please try again"
                passwordTextField.textColor = UIColor.setPrimaryRedColor()
                passwordAgainTextField.textColor = UIColor.setPrimaryRedColor()
                passwordTextField.layer.addAnimation( anim, forKey:nil)
                passwordAgainTextField.layer.addAnimation( anim, forKey:nil)
                print("Password is less than 6 characters")
            }
        } else {
            errorDescriptionLabel.hidden = false
            errorDescriptionLabel.text = "Your passwords are not the same, please try again"
            passwordTextField.textColor = UIColor.setPrimaryRedColor()
            passwordAgainTextField.textColor = UIColor.setPrimaryRedColor()
            passwordTextField.layer.addAnimation( anim, forKey:nil)
            passwordAgainTextField.layer.addAnimation( anim, forKey:nil)
            print("Passwords don't match")
        }
        
        newUser.signUpInBackgroundWithBlock { (success: Bool, error: NSError?) -> Void in
            if let error = error {
                print(error.localizedDescription)
                if (error.code == 202) {
                    self.errorDescriptionLabel.hidden = false
                    self.errorDescriptionLabel.text = "This phone number is already used by another user, please try login"
                    print("This phone number is already used by another user")
                }
            } else {
                self.errorDescriptionLabel.hidden = true
                self.passwordTextField.textColor = UIColor.blackColor()
                self.passwordAgainTextField.textColor = UIColor.blackColor()

                print("Created a new user")
                self.performSegueWithIdentifier("toMoreInfo", sender: nil)
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
    
    @IBAction func onTap(sender: AnyObject) {
        self.view.endEditing(true)
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
