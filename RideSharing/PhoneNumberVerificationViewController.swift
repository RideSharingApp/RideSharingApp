//
//  PhoneNumberVerificationViewController.swift
//  RideSharing
//
//  Created by Karlygash Zhuginissova on 3/8/16.
//  Copyright © 2016 Tarang khanna. All rights reserved.
//

import UIKit
import Parse


class PhoneNumberVerificationViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var phoneNumbertextField: UITextField!
    @IBOutlet weak var sendVerificationButton: UIButton!
    
    @IBOutlet weak var enterVerificationCodeLabel: UILabel!
    @IBOutlet weak var verificationCodeTextField: UITextField!
    
    @IBOutlet weak var confirmButton: UIButton!
    
    
    var phoneNumber: String?
    var verificationCode: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
       
        chooseKeyboardType()
        phoneNumbertextField.delegate = self
        phoneNumbertextField.addTarget(self, action: "phoneTextFieldDidChange:", forControlEvents: UIControlEvents.EditingChanged)
        phoneNumbertextField.addTarget(self, action: "textFieldDidEndEditing:", forControlEvents: UIControlEvents.EditingDidEnd)
        verificationCodeTextField.addTarget(self, action: "codeTextFieldDidChange:", forControlEvents: UIControlEvents.EditingChanged)
        if ((phoneNumbertextField.text?.isEmpty)!) {
            print("textfield.text = \(phoneNumbertextField.text)")
            self.enterVerificationCodeLabel.alpha = 0.5
            self.verificationCodeTextField.alpha = 0.5
            self.confirmButton.alpha = 0.5
            self.confirmButton.enabled = false
        }
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: "dismissKeyboard")
        view.addGestureRecognizer(tap)
    }
    
    func dismissKeyboard() {
        view.endEditing(true)
    }
    func chooseKeyboardType(){
        phoneNumbertextField.keyboardType = UIKeyboardType.DecimalPad
        verificationCodeTextField.keyboardType = UIKeyboardType.DecimalPad
    }
    
    func textFieldDidEndEditing(textField: UITextField) {
            self.phoneNumber = phoneNumbertextField.text
    }
    
    func textField(textField: UITextField, shouldChangeCharactersInRange range: NSRange, replacementString string: String) -> Bool {
        if textField.tag == 0 {
            let length = Int(self.getLength(phoneNumbertextField.text!))
            
            if length == 10 {
                if range.length == 0 {
                    return false
                }
            }
            if length == 3 {
                let number = self.formatNumber(phoneNumbertextField.text!)
                phoneNumbertextField.text = "(\(number))"
                if range.length > 0 {
                    phoneNumbertextField.text = number.substringToIndex(number.startIndex.advancedBy(3))
                }
            }
            else if (length == 6) {
                print("here")
                let number = self.formatNumber(phoneNumbertextField.text!)
                phoneNumbertextField.text = "(\(number.substringToIndex(number.startIndex.advancedBy(3))))\(number.substringFromIndex(number.startIndex.advancedBy(3)))-"
                if range.length > 0 {
                    phoneNumbertextField.text = "(\(number.substringToIndex(number.startIndex.advancedBy(3))))\(number.substringFromIndex(number.startIndex.advancedBy(3)))"
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
    
    
    func phoneTextFieldDidChange(textField: UITextField) {

            if ((phoneNumbertextField.text?.isEmpty)!) {
                print("textfield.text = \(phoneNumbertextField.text)")
                self.enterVerificationCodeLabel.alpha = 0.5
                self.verificationCodeTextField.alpha = 0.5
                self.confirmButton.alpha = 0.5
                self.confirmButton.enabled = false
            } else
                if (phoneNumbertextField.text != "") {
                    print("I am here")
                    //            self.confirmButton.enabled = true
                    UIView.animateWithDuration(0.3, animations: { () -> Void in
                        self.enterVerificationCodeLabel.alpha = 1.0
                        self.verificationCodeTextField.alpha = 1.0
                        self.confirmButton.alpha = 1.0
                    })
            }
    }
    
    func codeTextFieldDidChange(textField: UITextField) {
        if ((verificationCodeTextField.text?.isEmpty)!) {
            self.confirmButton.enabled = false
        } else if (verificationCodeTextField.text != "")  {
            self.confirmButton.enabled = true
        }
    }
    
    
    
    @IBAction func onSendVerification(sender: AnyObject) {
        
    }

    @IBAction func onConfirm(sender: AnyObject) {
        print("Confirm clicked")
        verificationCode = "1234"
        if (verificationCodeTextField.text == verificationCode) {
           performSegueWithIdentifier("toCreateAUserVC", sender: nil)
        }
    }
        
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    
    // MARK: - Navigation

        override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
            if segue.identifier == "toCreateAUserVC" {
                let destinationVC = segue.destinationViewController as! CreateAUserViewController
                destinationVC.phoneNumberPassed = self.phoneNumber
            }
    }
    
}