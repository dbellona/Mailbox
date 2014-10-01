//
//  MailboxViewController.swift
//  Mailbox
//
//  Created by David Bellona on 9/27/14.
//  Copyright (c) 2014 David Bellona. All rights reserved.
//

import UIKit

class MailboxViewController: UIViewController, UIScrollViewDelegate {
    
    @IBOutlet weak var listMenuImageView: UIImageView!
    @IBOutlet weak var rescheduleImageView: UIImageView!
    @IBOutlet weak var contentView: UIView!
    @IBOutlet weak var menuButton: UIButton!
    @IBOutlet weak var navBarView: UIImageView!
    @IBOutlet weak var helpLabelView: UIImageView!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var searchBarView: UIImageView!
    @IBOutlet weak var feedView: UIImageView!
    @IBOutlet weak var messageView: UIView!
    @IBOutlet weak var messageImageView: UIImageView!
    @IBOutlet weak var laterImageView: UIImageView!
    @IBOutlet weak var listImageView: UIImageView!
    @IBOutlet weak var archiveImageView: UIImageView!
    @IBOutlet weak var deleteImageView: UIImageView!
    
    var contentCenter: CGPoint!
    var messageCenter: CGPoint!
    var laterIconCenter: CGPoint!
    var archiveIconCenter: CGPoint!
    var messageSlideDuration: Double = 0.1
    var messageRangeOne: Float = 60
    var messageRangeTwo: Float = 220
    var menuOpen: Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        rescheduleImageView.alpha = 0
        listMenuImageView.alpha = 0
        menuOpen = false
        
        // set the scroll and scroll height
        scrollView.delegate = self
        scrollView.contentSize =
            CGSize(width: 320, height: helpLabelView.frame.height + searchBarView.frame.height + feedView.frame.height + messageView.frame.height + navBarView.frame.height)

        iconAlpha(listImageView, firstAlpha: 0, secondIcon: deleteImageView, secondAlpha: 0)
        
        var edgeGesture = UIScreenEdgePanGestureRecognizer(target: self, action: "onEdgePan:")
        edgeGesture.edges = UIRectEdge.Left
        contentView.addGestureRecognizer(edgeGesture)
        
        }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    // check position of message
    func checkMessage(newMessageView: UIImageView) {
        if Float(newMessageView.frame.origin.x) > messageRangeOne && Float(newMessageView.frame.origin.x) <= messageRangeTwo {
            changeMessageBgColor("green")
            iconAlpha(deleteImageView, firstAlpha: 0, secondIcon: archiveImageView, secondAlpha: 1)
            archiveImageView.frame.origin.x = messageImageView.frame.origin.x - 40
        } else if Float(newMessageView.frame.origin.x) > messageRangeTwo {
            changeMessageBgColor("red")
            iconAlpha(deleteImageView, firstAlpha: 1, secondIcon: archiveImageView, secondAlpha: 0)
            deleteImageView.frame.origin.x = messageImageView.frame.origin.x - 40
        } else if Float(newMessageView.frame.origin.x) < -1 * messageRangeOne && Float(newMessageView.frame.origin.x) >= -1 * messageRangeTwo {
            changeMessageBgColor("yellow")
            iconAlpha(laterImageView, firstAlpha: 1, secondIcon: listImageView, secondAlpha: 0)
            laterImageView.frame.origin.x = messageImageView.frame.origin.x + 340
        } else if Float(newMessageView.frame.origin.x) < -1 * messageRangeTwo {
            changeMessageBgColor("brown")
            iconAlpha(laterImageView, firstAlpha: 0, secondIcon: listImageView, secondAlpha: 1)
            listImageView.frame.origin.x = messageImageView.frame.origin.x + 340
        } else {
            changeMessageBgColor("")
            archiveImageView.frame.origin.x = 20
            laterImageView.frame.origin.x = 280
            deleteImageView.frame.origin.x = 20
            listImageView.frame.origin.x = 280
            
        }
    }
    
    // check position of message
    func setMessage(newMessageView: UIView) {
        if Float(newMessageView.frame.origin.x) > messageRangeOne && Float(newMessageView.frame.origin.x) <= messageRangeTwo {
            // mark as read
            moveMessage(520, messageMovedBool:true, currentIcon: archiveImageView, iconSlideTo: -40)
            iconAlpha(laterImageView, firstAlpha: 0, secondIcon: listImageView, secondAlpha: 0)
        } else if Float(newMessageView.frame.origin.x) > messageRangeTwo {
            // mark as delete
            moveMessage(520, messageMovedBool:true, currentIcon: deleteImageView, iconSlideTo: -40)
            iconAlpha(laterImageView, firstAlpha: 0, secondIcon: listImageView, secondAlpha: 0)
        } else if Float(newMessageView.frame.origin.x) < -1 * messageRangeOne && Float(newMessageView.frame.origin.x) >= -1 * messageRangeTwo {
            // mark as later
            moveMessageToLater(-200, messageMovedBool:true, currentIcon: laterImageView, iconSlideTo: 340)
            iconAlpha(archiveImageView, firstAlpha: 0, secondIcon: deleteImageView, secondAlpha: 0)
        } else if Float(newMessageView.frame.origin.x) < -1 * messageRangeTwo {
            // mark as list
            moveMessageToList(-200, messageMovedBool:true, currentIcon: listImageView, iconSlideTo: 340)
            iconAlpha(archiveImageView, firstAlpha: 0, secondIcon: deleteImageView, secondAlpha: 0)
        } else {
            UIView.animateWithDuration(messageSlideDuration, delay: 0.0, options: UIViewAnimationOptions.CurveEaseInOut, animations: { () -> Void in
                newMessageView.frame.origin.x = 0
                self.archiveImageView.frame.origin.x = 20
                self.laterImageView.frame.origin.x = 280
            }, completion: nil)
        }
    }
    
    // set color of the message bg
    func changeMessageBgColor(bgColorName: String) {
        var greyColor: UIColor = UIColor(red: 227/255, green: 227/255, blue: 227/255, alpha: 1)
        var yellowColor: UIColor = UIColor(red: 250/255, green: 210/255, blue: 50/255, alpha: 1)
        var brownColor: UIColor = UIColor(red: 216/255, green: 166/255, blue: 117/255, alpha: 1)
        var greenColor: UIColor = UIColor(red: 112/255, green: 217/255, blue: 98/255, alpha: 1)
        var redColor: UIColor = UIColor(red: 235/255, green: 84/255, blue: 51/255, alpha: 1)
        switch bgColorName {
        case "yellow":
            messageView.backgroundColor = yellowColor
        case "brown":
            messageView.backgroundColor = brownColor
        case "green":
            messageView.backgroundColor = greenColor
        case "red":
            messageView.backgroundColor = redColor
        default:
            messageView.backgroundColor = greyColor
        }
    }
    
    // set icon alpha
    func iconAlpha(firstIcon: UIImageView, firstAlpha: CGFloat, secondIcon: UIImageView, secondAlpha: CGFloat){
        firstIcon.alpha = firstAlpha
        secondIcon.alpha = secondAlpha
    }
    
    // toggle menu
    func toggleMenu(menuReturn: CGFloat, menuOpenBool:Bool) {
        UIView.animateWithDuration(messageSlideDuration * 2, delay: 0.0, options: UIViewAnimationOptions.CurveEaseInOut, animations: { () -> Void in
            self.contentView.center.x = menuReturn
            }) { (checkIt: Bool) -> Void in
                self.menuOpen = menuOpenBool
                println("menuOpenBool \(menuOpenBool)")
        }
    }
    
    // show reschedule
    func showModalMenu(newMenu: UIImageView, newAlpha: CGFloat, completion: () -> Void) {
        UIView.animateWithDuration(messageSlideDuration * 2, delay: 0.0, options: UIViewAnimationOptions.CurveEaseInOut, animations: { () -> Void in
            newMenu.alpha = newAlpha
            }) { (checkIt: Bool) -> Void in
                println("done")
                completion()
        }
    }
    
    // move message
    func moveMessage(messageSlideTo: CGFloat, messageMovedBool:Bool, currentIcon:UIImageView, iconSlideTo: CGFloat) {
        UIView.animateWithDuration(messageSlideDuration * 2, delay: 0.0, options: UIViewAnimationOptions.CurveEaseInOut, animations: { () -> Void in
            self.messageImageView.center.x = messageSlideTo
            currentIcon.frame.origin.x = self.messageImageView.frame.origin.x + iconSlideTo
            }) { (checkIt: Bool) -> Void in
                self.menuOpen = messageMovedBool
                currentIcon.alpha = 0
                self.moveFeedUp(78) { () -> Void in
                    self.moveFeedDown(164)
                }
        }
    }
    
    // move message to later
    func moveMessageToLater(messageSlideTo: CGFloat, messageMovedBool:Bool, currentIcon:UIImageView, iconSlideTo: CGFloat) {
        UIView.animateWithDuration(messageSlideDuration * 2, delay: 0.0, options: UIViewAnimationOptions.CurveEaseInOut, animations: { () -> Void in
            self.messageImageView.center.x = messageSlideTo
            currentIcon.frame.origin.x = self.messageImageView.frame.origin.x + iconSlideTo
            }) { (checkIt: Bool) -> Void in
                self.menuOpen = messageMovedBool
                currentIcon.alpha = 0
                self.showModalMenu(self.rescheduleImageView, newAlpha: 1) {
                }
        }
    }
    
    // move message to list
    func moveMessageToList(messageSlideTo: CGFloat, messageMovedBool:Bool, currentIcon:UIImageView, iconSlideTo: CGFloat) {
        UIView.animateWithDuration(messageSlideDuration * 2, delay: 0.0, options: UIViewAnimationOptions.CurveEaseInOut, animations: { () -> Void in
            self.messageImageView.center.x = messageSlideTo
            currentIcon.frame.origin.x = self.messageImageView.frame.origin.x + iconSlideTo
            }) { (checkIt: Bool) -> Void in
                self.menuOpen = messageMovedBool
                currentIcon.alpha = 0
                self.showModalMenu(self.listMenuImageView, newAlpha: 1) {
                }
        }
    }
    
    
    // move feed up
    func moveFeedUp(feedSlideTo: CGFloat, completion: () -> Void) {
        UIView.animateWithDuration(messageSlideDuration * 2, delay: 0.0, options: UIViewAnimationOptions.CurveEaseInOut, animations: { () -> Void in
            self.feedView.frame.origin.y = feedSlideTo
            }) { (checkIt: Bool) -> Void in
                println("message moved")
                completion()
        }
        
    }
    
    // move feed down
    func moveFeedDown(feedSlideTo: CGFloat) {
        messageImageView.frame.origin.y = -86
        messageImageView.frame.origin.x = 0
        iconAlpha(laterImageView, firstAlpha: 1, secondIcon: archiveImageView, secondAlpha: 1)
        UIView.animateWithDuration(messageSlideDuration * 2, delay: 1.0, options: UIViewAnimationOptions.CurveEaseInOut, animations: { () -> Void in
            self.feedView.frame.origin.y = feedSlideTo
            self.messageImageView.frame.origin.y = 0
            }, completion: { (messageLoaded: Bool) -> Void in
                println("message loaded")
        })
    }
    
    // pan message
    @IBAction func onPanMessage(gestureRecognizer: UIPanGestureRecognizer) {
        var location = gestureRecognizer.locationInView(view)
        var translation = gestureRecognizer.translationInView(view)
        var velocity = gestureRecognizer.translationInView(view)
        //if menuOpen == false {
            if gestureRecognizer.state == UIGestureRecognizerState.Began {
                messageCenter = messageImageView.center
                laterIconCenter = laterImageView.center
                archiveIconCenter = archiveImageView.center
            } else if gestureRecognizer.state == UIGestureRecognizerState.Changed {
                messageImageView.center.x = translation.x + messageCenter.x
                checkMessage(messageImageView)
            } else if gestureRecognizer.state == UIGestureRecognizerState.Ended {
                setMessage(messageImageView)
            }
        //}
    }
    
    // tap menu
    @IBAction func onTapMenu(sender: UIButton) {
        if menuOpen && contentView.frame.origin.x != 0 {
            toggleMenu(160, menuOpenBool: false)
        } else {
            toggleMenu(445, menuOpenBool: true)
        }
    }
    
    // tap to close menu
    @IBAction func onTapContent(sender: UITapGestureRecognizer) {
        if menuOpen && contentView.frame.origin.x != 0 {
            toggleMenu(160, menuOpenBool: false)
        }
    }
    
    // tap reschedule
    @IBAction func onTapReschedule(sender: UITapGestureRecognizer) {
        showModalMenu(self.rescheduleImageView, newAlpha: 0) {
            self.moveFeedUp(78) { () -> Void in
                self.moveFeedDown(164)
            }
        }
    }
    
    // tap list
    @IBAction func onTapList(sender: UITapGestureRecognizer) {
        showModalMenu(self.listMenuImageView, newAlpha: 0) {
            self.moveFeedUp(78) { () -> Void in
                self.moveFeedDown(164)
            }
        }
    }
    
    
    
    // edge pan left menu
    @IBAction func onEdgePan(gestureRecognizer: UIScreenEdgePanGestureRecognizer) {
        var location = gestureRecognizer.locationInView(view)
        var translation = gestureRecognizer.translationInView(view)
        var velocity = gestureRecognizer.translationInView(view)
            if gestureRecognizer.state == UIGestureRecognizerState.Began {
                contentCenter = contentView.center
                println("pan began")
            } else if gestureRecognizer.state == UIGestureRecognizerState.Changed {
                contentView.center.x = translation.x + contentCenter.x
            } else if gestureRecognizer.state == UIGestureRecognizerState.Ended {
                if contentView.center.x <= 300 {
                    toggleMenu(160, menuOpenBool: false)
                } else {
                    toggleMenu(445, menuOpenBool: true)
                }
                println("pan end")
            }
    }
    
}
