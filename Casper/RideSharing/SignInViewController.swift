//
//  SignInViewController.swift
//  RideSharing
//
//  Created by Karlygash Zhuginissova on 3/8/16.
//  Copyright © 2016 Tarang khanna. All rights reserved.
//

import UIKit
import Parse
import AVFoundation


class SignInViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var phoneNumberTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var loginButton: UIButton!
    var currentTextField: UITextField?
    
    var phoneNumber: String?
    var password: String?
    
    var player : AVPlayer?
    var playerLayer: AVPlayerLayer?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        phoneNumberTextField.delegate = self
        passwordTextField.delegate = self

        chooseKeyboardType()
        
        
        // Do any additional setup after loading the view.
        
    }
    
    override func viewWillAppear(animated: Bool) {
        let videoURL: NSURL = NSBundle.mainBundle().URLForResource("LoginVideo", withExtension: "mp4")!
        
        player = AVPlayer(URL: videoURL)
        player?.actionAtItemEnd = .None
        player?.muted = true
        
        playerLayer = AVPlayerLayer(player: player)
        playerLayer!.videoGravity = AVLayerVideoGravityResizeAspectFill
        playerLayer!.zPosition = -1
        
        playerLayer!.frame = view.frame
        
        view.layer.addSublayer(playerLayer!)
        
        player?.play()
        
        //loop video
        NSNotificationCenter.defaultCenter().addObserver(self,
                                                         selector: "loopVideo",
                                                         name: AVPlayerItemDidPlayToEndTimeNotification,
                                                         object: nil)
    }
    
    func loopVideo() {
        player?.seekToTime(kCMTimeZero)
        player?.play()
    }
    
    func chooseKeyboardType(){
        phoneNumberTextField.keyboardType = UIKeyboardType.DecimalPad
        
    }
    
    func textFieldDidBeginEditing(textField: UITextField) {
        currentTextField = textField
    }
    
    
    func textFieldDidEndEditing(textField: UITextField) {
        switch textField.tag {
        case 0:
            phoneNumber = phoneNumberTextField.text
        case 1:
            password = passwordTextField.text
        default: break
        }
        
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    @IBAction func onLogin(sender: AnyObject) {
        if let currentTextField = currentTextField {
            currentTextField.resignFirstResponder()
        }
        PFUser.logInWithUsernameInBackground(phoneNumber!, password: password!) { (user: PFUser?, error: NSError?) -> Void in
            if let error = error {
                print("User login failed")
                print(error.localizedDescription)
            } else {
                print("User logged in")
                self.performSegueWithIdentifier("toMainMenu", sender: nil)
            }
        }
    }
    
    func textField(textField: UITextField, shouldChangeCharactersInRange range: NSRange, replacementString string: String) -> Bool {
        if textField.tag == 0 {
            let length = Int(self.getLength(phoneNumberTextField.text!))
            
            if length == 10 {
                if range.length == 0 {
                    return false
                }
            }
            if length == 3 {
                let number = self.formatNumber(phoneNumberTextField.text!)
                phoneNumberTextField.text = "(\(number))"
                if range.length > 0 {
                    phoneNumberTextField.text = number.substringToIndex(number.startIndex.advancedBy(3))
                }
            }
            else if (length == 6) {
                print("here")
                let number = self.formatNumber(phoneNumberTextField.text!)
                phoneNumberTextField.text = "(\(number.substringToIndex(number.startIndex.advancedBy(3))))\(number.substringFromIndex(number.startIndex.advancedBy(3)))-"
                if range.length > 0 {
                    phoneNumberTextField.text = "(\(number.substringToIndex(number.startIndex.advancedBy(3))))\(number.substringFromIndex(number.startIndex.advancedBy(3)))"
                }
            }
        }
        return true
    }
    
    func formatNumber(var mobileNumber: String) -> String {
        mobileNumber = mobileNumber.stringByReplacingOccurrencesOfString("(", withString: "")
        mobileNumber = mobileNumber.stringByReplacingOccurrencesOfString(")", withString: "")
        mobileNumber = mobileNumber.stringByReplacingOccurrencesOfString(" ", withString: "")
        mobileNumber = mobileNumber.stringByReplacingOccurrencesOfString("-", withString: "")
        mobileNumber = mobileNumber.stringByReplacingOccurrencesOfString("+", withString: "")
        NSLog("%@", mobileNumber)
        let length: Int = Int(mobileNumber.characters.count)
        if length > 10 {
            mobileNumber = mobileNumber.substringFromIndex(mobileNumber.startIndex.advancedBy(length - 10))
            NSLog("%@", mobileNumber)
        }
        return mobileNumber
    }
    
    func getLength(var mobileNumber: String) -> Int {
        mobileNumber = mobileNumber.stringByReplacingOccurrencesOfString("(", withString: "")
        mobileNumber = mobileNumber.stringByReplacingOccurrencesOfString(")", withString: "")
        mobileNumber = mobileNumber.stringByReplacingOccurrencesOfString(" ", withString: "")
        mobileNumber = mobileNumber.stringByReplacingOccurrencesOfString("-", withString: "")
        mobileNumber = mobileNumber.stringByReplacingOccurrencesOfString("+", withString: "")
        let length: Int = Int(mobileNumber.characters.count)
        return length
    }

    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewDidDisappear(animated: Bool) {
        player?.pause()
        playerLayer?.removeFromSuperlayer()
        player = nil
    }
    
    
    @IBAction func onSignUp(sender: AnyObject) {
        self.dismissViewControllerAnimated(true, completion: nil)
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
