//
//  MenuTableViewController.swift
//  RideSharing
//
//  Created by Tarang khanna on 3/25/16.
//  Copyright © 2016 Tarang khanna. All rights reserved.
//

import UIKit
import Parse

class MenuTableViewController: UITableViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    @IBOutlet weak var logOutBtn: UIButton!
    
    @IBOutlet weak var firstNameLabel: UILabel!
    
    @IBOutlet weak var lastNameLabel: UILabel!
    
    let user = PFUser.currentUser()
    
    @IBOutlet var profileImageView: AvatarImageView!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        firstNameLabel.text = user!["firstName"] as? String
        lastNameLabel.text = user!["lastName"] as? String
        
        //get profile image
        if let picturefile = user!["profilePicture"] {
            picturefile.getDataInBackgroundWithBlock { (data:NSData?, error:NSError?) -> Void in
                if let data = data {
                    self.profileImageView.image = UIImage(data: data)
                    print("success")
                }else{
                    print("\(error)")
                }
                
            }
        }
        
        addGestureForProfileImage()
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }
    
    func addGestureForProfileImage(){
        let gestureRecognizer = UITapGestureRecognizer(target: self, action: "onTapImage:")
        profileImageView.userInteractionEnabled = true
        profileImageView.addGestureRecognizer(gestureRecognizer)
    }
//
    //MARK: - Image Picker
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        //        let originalImage = info[UIImagePickerControllerOriginalImage] as? UIImage
        let editedImage = info[UIImagePickerControllerEditedImage] as? UIImage
        profileImageView.image = editedImage
        if (profileImageView.image != nil) {
            let imageData = UIImagePNGRepresentation(profileImageView.image!)
            let imageFile = PFFile(name:"image.png", data:imageData!)
            
            user!["profilePicture"] = imageFile
            user!.saveInBackground()
        } else {
            print("No picture")
        }
        
        self.dismissViewControllerAnimated(true, completion: nil)
        
    }
//
//    
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
    
    
    @IBAction func logOut(sender: AnyObject) {
        print("LOG OUT")
        self.logOutBtn.backgroundColor = UIColor.grayColor()
        UIView.animateWithDuration(1, animations: { () -> Void in
            self.logOutBtn.backgroundColor = UIColor.grayColor()
            }) { (success) -> Void in
                self.logOutBtn.backgroundColor = UIColor.clearColor()
        }
        
        PFUser.logOut()
        performSegueWithIdentifier("signInAgain", sender: self)
    }

    // MARK: - Table view data source

    /*
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("reuseIdentifier", forIndexPath: indexPath)

        // Configure the cell...

        return cell
    }
    */

    /*
    // Override to support conditional editing of the table view.
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            // Delete the row from the data source
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        } else if editingStyle == .Insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(tableView: UITableView, moveRowAtIndexPath fromIndexPath: NSIndexPath, toIndexPath: NSIndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    // In a storyboard-based application, you will often want to do a little preparation before navigation

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        if (segue.identifier == "toProfile") { //pass data to VC
            let svc = (segue.destinationViewController as! UINavigationController).topViewController as! ProfileViewController
            svc.isCurrentUser = true
            let user = PFUser.currentUser()
            print(user)
            svc.firstName = user!["firstName"] as? String
            svc.lastName = user!["lastName"] as? String
            svc.age = user!["age"] as? String
            svc.gender = user!["gender"] as? String
            //svc.carMakeAndModel = user!["CarMakeAndModel"] as? String
            svc.profileImage = profileImageView.image
            user!.fetchInBackgroundWithBlock { (object, error) -> Void in
                user!.fetchIfNeededInBackgroundWithBlock { (result, error) -> Void in
                    svc.carMakeAndModel = user!.objectForKey("CarMakeAndModel") as? String
                }
            }
            svc.phoneNumber = user!["username"] as? String
        }
    }

}
