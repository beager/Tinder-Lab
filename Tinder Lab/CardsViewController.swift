//
//  CardsViewController.swift
//  Tinder Lab
//
//  Created by Bill Eager on 9/23/15.
//  Copyright © 2015 Bill Eager. All rights reserved.
//

import UIKit

class CardsViewController: UIViewController, UIViewControllerTransitioningDelegate, UIViewControllerAnimatedTransitioning {

    var isPresenting: Bool = true
    var cardInitialCenter: CGPoint!
    var cardOriginalCenter: CGPoint!
    var draggableImageView: DraggableImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        draggableImageView = DraggableImageView(frame: CGRectMake(10, 110, view.bounds.width - 20, 300))
        draggableImageView.image = UIImage(named: "ryan")
        
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: "onTap:")
        draggableImageView.addGestureRecognizer(tapGestureRecognizer)
        
        view.addSubview(draggableImageView)
        // Do any additional setup after loading the view.
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func onTap(sender: UITapGestureRecognizer) {
        performSegueWithIdentifier("profileSegue", sender: self)
    }
    

    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        let destinationViewController = segue.destinationViewController as! ProfileViewController
        destinationViewController.modalPresentationStyle = UIModalPresentationStyle.Custom
        destinationViewController.transitioningDelegate = self

        destinationViewController.image = draggableImageView.image
    }

    // MARK: UIViewControllerTransitioningDelegate
    func animationControllerForPresentedController(presented: UIViewController, presentingController presenting: UIViewController, sourceController source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        isPresenting = true
        return self
    }
    
    func animationControllerForDismissedController(dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        isPresenting = false
        return self
    }
    
    func transitionDuration(transitionContext: UIViewControllerContextTransitioning?) -> NSTimeInterval {
        // The value here should be the duration of the animations scheduled in the animationTransition method
        return 0.4
    }
    
    func animateTransition(transitionContext: UIViewControllerContextTransitioning) {
        print("animating transition")
        let containerView = transitionContext.containerView()
        let toViewController = transitionContext.viewControllerForKey(UITransitionContextToViewControllerKey)!
        let fromViewController = transitionContext.viewControllerForKey(UITransitionContextFromViewControllerKey)!
        
        if (isPresenting) {
            let transitionImageView = UIImageView(frame: CGRectMake(10, 110, view.bounds.width - 20, 300))
            transitionImageView.contentMode = UIViewContentMode.ScaleAspectFill
            transitionImageView.clipsToBounds = true
            transitionImageView.layer.cornerRadius = 5
            transitionImageView.image = draggableImageView.image
            view.addSubview(transitionImageView)
            
            
            containerView!.addSubview(toViewController.view)
            toViewController.view.alpha = 0
            UIView.animateWithDuration(0.4, animations: { () -> Void in
                transitionImageView.frame = CGRectMake(0, 100, self.view.bounds.width, 320);
                toViewController.view.alpha = 1
                }) { (finished: Bool) -> Void in
                    transitionContext.completeTransition(true)
                    transitionImageView.removeFromSuperview()
            }
        } else {
            let transitionImageView = UIImageView(frame: CGRectMake(0, 100, view.bounds.width, 320))
            transitionImageView.contentMode = UIViewContentMode.ScaleAspectFill
            transitionImageView.clipsToBounds = true
            transitionImageView.image = draggableImageView.image
            UIView.animateWithDuration(0.4, animations: { () -> Void in
                transitionImageView.frame = CGRectMake(10, 110, self.view.bounds.width - 20, 300);
                fromViewController.view.alpha = 0
                }) { (finished: Bool) -> Void in
                    transitionContext.completeTransition(true)
                    fromViewController.view.removeFromSuperview()
                    transitionImageView.removeFromSuperview()
            }
        }
    } 

}
