//
//  CasperView.swift
//  RideSharing
//
//  Created by Karlygash Zhuginissova on 3/31/16.
//  Copyright © 2016 Tarang khanna. All rights reserved.
//

import UIKit

extension UIColor {
    class func setPrimaryRedColor() -> UIColor {
        return UIColor(red: 207.0/255.0, green: 16.0/255.0, blue: 45.0/255.0, alpha: 1.0)
    }
    
    class func setPrimaryWhiteColor() -> UIColor {
        return UIColor.whiteColor()
    }
    
    class func setLightGrayForBackgroundColor() -> UIColor {
        return UIColor(red: 244.0/255.0, green: 244.0/255.0, blue: 244.0/255.0, alpha: 1.0)
    }
    
    class func setDarkGrayColor() -> UIColor {
        return UIColor(red: 164.0/255.0, green: 64.0/255.0, blue: 64.0/255.0, alpha: 1.0)
    }
    
    class func setInactiveButtonColor() -> UIColor {
        return UIColor(red: 164.0/255.0, green: 64.0/255.0, blue: 64.0/255.0, alpha: 1.0)
    }
    
    class func setActiveButtonColor() -> UIColor {
        return UIColor(red: 207.0/255.0, green: 16.0/255.0, blue: 45.0/255.0, alpha: 1.0)
    }
}

extension UIFont {
    class func setRegularFontSize20() -> UIFontDescriptor {
        return UIFontDescriptor(name: "Gill Sans", size: 20.0)
    }
    
    class func setRegularFontSize18() -> UIFontDescriptor {
        return UIFontDescriptor(name: "Gill Sans", size: 18.0)
    }
    
    class func setREgularFontSize16() -> UIFontDescriptor {
        return UIFontDescriptor(name: "Gill Sans", size: 16.0)
    }
    
    class func setSemiBoldFontSize20() -> UIFontDescriptor {
        return UIFontDescriptor(name: "Gill Sans - SemiBold", size: 20.0)
    }
    
    class func setSemiBoldFontSize18() -> UIFontDescriptor {
        return UIFontDescriptor(name: "Gill Sans - SemiBold", size: 18.0)
    }
    
    class func setSemiBoldFontSize16() -> UIFontDescriptor {
        return UIFontDescriptor(name: "Gill Sans - SemiBold", size: 16.0)
    }
    
    class func setLightFontSize20() -> UIFontDescriptor {
        return UIFontDescriptor(name: "Gill Sans", size: 20.0)
    }
    
    class func setLightFontSize18() -> UIFontDescriptor {
        return UIFontDescriptor(name: "Gill Sans", size: 18.0)
    }
    
    class func setLightFontSize16() -> UIFontDescriptor {
        return UIFontDescriptor(name: "Gill Sans", size: 16.0)
    }
}

class CasperView: UIView {

    
    /*
    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func drawRect(rect: CGRect) {
        // Drawing code
    }
    */
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    
   

}
