//
//  Ride.swift
//  RideSharing
//
//  Created by Akshat Goyal on 3/20/16.
//  Copyright © 2016 Tarang khanna. All rights reserved.
//

import UIKit
import Parse


class Ride : NSObject {
    
    class func postRide (departurePoint: String?, arrivalPoint: String?, dateAndTime: NSDate?, price: String?, description: String?, availability: Bool?, seats:Int?, withCompletion completion: PFBooleanResultBlock? ) {
        let ride = PFObject(className: "Ride")
        
        ride["departurePoint"] = departurePoint
        ride["arrivalPoint"] = arrivalPoint
        ride["dateAndTime"] = dateAndTime
        ride["price"] = price
        ride["description"] = description
        ride["availability"] = availability
        print(PFUser.currentUser())
        ride["driver"] = PFUser.currentUser()
        ride["seats"] = seats
        
        ride.saveInBackgroundWithBlock(completion)
    }
    
    
    
}
