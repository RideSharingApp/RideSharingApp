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
    var purePhoneNumber: String?
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
        purePhoneNumber = textField.text
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
    
    func step1() {
        phoneNumber = ""
        
        sendVerificationButton.enabled = true
    }
    
    func step2() {
        phoneNumber = phoneNumbertextField.text!
        phoneNumbertextField.text = ""
        verificationCodeTextField.placeholder = "1234"
        
        sendVerificationButton.enabled = true
    }
    

    
    @IBAction func onSendVerification(sender: AnyObject) {
        print("Verify clicked")
        let preferredLanguage = NSBundle.mainBundle().preferredLocalizations[0]
        
        let textFieldText = phoneNumbertextField.text ?? ""
        
        if phoneNumber == "" {
            if (preferredLanguage == "en" && textFieldText.characters.count != 10)
            {
                showAlert("Phone Login", message: NSLocalizedString("warningPhone", comment: "You must enter a 10-digit US phone number including area code."))
                return step1()
            }
            
            
        }
        self.editing = false
        let params = ["phoneNumber" : textFieldText, "language" : preferredLanguage]
        purePhoneNumber = textFieldText
        print("phone received: \(purePhoneNumber)")
        PFCloud.callFunctionInBackground("sendCode", withParameters: params) { response, error in
            self.editing = true
            if let error = error {
                var description = error.description
                if description.characters.count == 0 {
                    description = NSLocalizedString("warningGeneral", comment: "Something went wrong. Please try again.") // "There was a problem with the service.\nTry again later."
                } else if let message = error.userInfo["error"] as? String {
                    description = message
                }
                self.showAlert("Login Error", message: description)
                return self.step1()
            }
            print("No error")
            return self.step2()
        }/*else {
        //            if verificationCodeTextField.text!.characters.count == 4, let code = Int(verificationCodeTextField.text!) {
        //                return doLogin(phoneNumber!, code: code)
        //            }
        //
        //            showAlert("Code Entry", message: NSLocalizedString("warningCodeLength", comment: "You must enter the 4 digit code texted to your phone number."))
        }*/
    }
    
    func doLogin(phoneNumber: String, code: Int) {
        self.editing = false
        
        let params = ["phoneNumber": phoneNumber, "codeEntry": code] as [NSObject:AnyObject]
        print("params: \(params)")
        print("phone: \(purePhoneNumber)")
        PFCloud.callFunctionInBackground("logIn", withParameters: params) { response, error in
            if let description = error?.description {
                self.editing = true
                return self.showAlert("Login Error", message: description)
            }
            if let token = response as? String {
                PFUser.becomeInBackground(token) { user, error in
                    if let _ = error {
                        self.showAlert("Login Error", message: NSLocalizedString("warningGeneral", comment: "Something happened while trying to log in.\nPlease try again."))
                        self.editing = true
                        return self.step1()
                    }
                    self.performSegueWithIdentifier("toCreateAUserVC", sender: nil)
                    //                    return self.dismissViewControllerAnimated(true, completion: nil)
                }
            } else {
                self.editing = true
                self.showAlert("Login Error", message: NSLocalizedString("warningGeneral", comment: "Something went wrong.  Please try again."))
                return self.step1()
            }
        }
    }


    @IBAction func onConfirm(sender: AnyObject) {
        print("Confirm clicked")
       
        if verificationCodeTextField.text!.characters.count == 4, let code = Int(verificationCodeTextField.text!) {
            print("phone sent: \(purePhoneNumber)")
            return doLogin(purePhoneNumber!, code: code)
        }
        
        showAlert("Code Entry", message: NSLocalizedString("warningCodeLength", comment: "You must enter the 4 digit code texted to your phone number."))
        
    }
        
    func showAlert(title: String, message: String) {
        return UIAlertView(title: title, message: message, delegate: nil, cancelButtonTitle: NSLocalizedString("alertOK", comment: "OK")).show()
    }
    
    
    // MARK: - Navigation
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "toCreateAUserVC" {
            let destinationVC = segue.destinationViewController as! CreateAUserViewController
            destinationVC.phoneNumberPassed = self.purePhoneNumber
        }
    }
    
}