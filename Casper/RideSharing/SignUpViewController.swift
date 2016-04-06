//
//  SignUpViewController.swift
//  RideSharing
//
//  Created by Karlygash Zhuginissova on 3/8/16.
//  Copyright © 2016 Tarang khanna. All rights reserved.
//

import UIKit
import Parse
import AVFoundation

class SignUpViewController: UIViewController {

    var player1: AVPlayer?
    var playerLayer1: AVPlayerLayer?
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    func loopVideo() {
        player1?.seekToTime(kCMTimeZero)
        player1?.play()
    }
    
    override func viewWillAppear(animated: Bool) {
        let videoURL: NSURL = NSBundle.mainBundle().URLForResource("LoginVideo", withExtension: "mov")!
        
        player1 = AVPlayer(URL: videoURL)
        player1?.actionAtItemEnd = .None
        player1?.muted = true
        
        playerLayer1 = AVPlayerLayer(player: player1)
        playerLayer1!.videoGravity = AVLayerVideoGravityResizeAspectFill
        playerLayer1!.zPosition = -1
        
        playerLayer1!.frame = view.frame
        
        view.layer.addSublayer(playerLayer1!)
        
        player1?.play()
        
        //loop video
        NSNotificationCenter.defaultCenter().addObserver(self,
                                                         selector: "loopVideo",
                                                         name: AVPlayerItemDidPlayToEndTimeNotification,
                                                         object: nil)
    
        navigationController?.navigationBar.hidden = true
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewDidDisappear(animated: Bool) {
        player1?.pause()
        playerLayer1?.removeFromSuperlayer()
        player1 = nil
        navigationController?.navigationBar.hidden = false
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
