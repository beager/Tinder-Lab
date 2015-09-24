//
//  DraggableImageView.swift
//  Tinder Lab
//
//  Created by Bill Eager on 9/23/15.
//  Copyright © 2015 Bill Eager. All rights reserved.
//

import UIKit

class DraggableImageView: UIView {
    
    var cardInitialCenter: CGPoint!
    var cardRotateIsInverted: Bool = false
    @IBOutlet var contentView: DraggableImageView!
    @IBOutlet weak var imageView: UIImageView!
    /*
    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func drawRect(rect: CGRect) {
        // Drawing code
    }
    */

    var image: UIImage? {
        get { return imageView.image }
        set {
            imageView.image = newValue
            // Probably terrible to do it here
            imageView.layer.cornerRadius = 5
        }
    }

    @IBAction func onPan(sender: UIPanGestureRecognizer) {
        let imageView = sender.view as! UIImageView
        if sender.state == UIGestureRecognizerState.Began {
            let touchPoint = sender.locationInView(contentView)
            if touchPoint.y > 150 {
                cardRotateIsInverted = true
            } else {
                cardRotateIsInverted = false
            }
            cardInitialCenter = imageView.center
        } else if sender.state == UIGestureRecognizerState.Changed {
            let translation = sender.translationInView(contentView)
            imageView.center = CGPoint(x: cardInitialCenter.x + translation.x, y: cardInitialCenter.y)
            imageView.transform = getTransformForCardOffset(translation)
        } else if sender.state == UIGestureRecognizerState.Ended {
            let translation = sender.translationInView(contentView)
            
            if translation.x > 50 || translation.x < -50 {
                var offscreenX: CGFloat!
                if (translation.x > 50) {
                    offscreenX = 540
                } else {
                    offscreenX = -220
                }
                UIView.animateWithDuration(01.0,
                    delay: 0,
                    usingSpringWithDamping: 0.6,
                    initialSpringVelocity: 10.0,
                    options: UIViewAnimationOptions.AllowUserInteraction,
                    animations: {
                        sender.view?.center = CGPoint(x: offscreenX, y: self.cardInitialCenter.y)
                        sender.view?.transform = self.getTransformForCardOffset(CGPoint(x: offscreenX, y: self.cardInitialCenter.y))
                    }, completion: { (value: Bool) in
                        sender.view?.center = self.cardInitialCenter
                        sender.view?.transform = CGAffineTransformIdentity
                })
            } else {
                UIView.animateWithDuration(0.5,
                    delay: 0,
                    usingSpringWithDamping: 0.6,
                    initialSpringVelocity: 10.0,
                    options: UIViewAnimationOptions.AllowUserInteraction,
                    animations: {
                        sender.view?.center = self.cardInitialCenter
                        sender.view?.transform = CGAffineTransformIdentity
                    }, completion: nil)
            }
        }
    }
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
        initSubviews()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        initSubviews()
    }
    
    func getTransformForCardOffset(translation: CGPoint) -> CGAffineTransform {
        var radTransform: CGFloat = translation.x / 500
        
        if cardRotateIsInverted {
            radTransform *= -1
        }
        
        return CGAffineTransformMakeRotation(radTransform)
    }
    
    func initSubviews() {
        // standard initialization logic
        print("hi")
        let nib = UINib(nibName: "DraggableImageView", bundle: nil)
        nib.instantiateWithOwner(self, options: nil)
        contentView.frame = bounds
        addSubview(contentView)
    }
}
