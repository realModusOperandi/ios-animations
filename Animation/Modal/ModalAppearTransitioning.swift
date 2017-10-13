import UIKit

/*
Licensed Materials - Property of IBM
© Copyright IBM Corporation 2015. All Rights Reserved.
This licensed material is licensed under the Apache 2.0 license. http://www.apache.org/licenses/LICENSE-2.0.
*/

class ModalAppearTransitioning: NSObject, UIViewControllerAnimatedTransitioning {
   
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return 0.8
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        
        let to = transitionContext.viewController(forKey: UITransitionContextViewControllerKey.to) as! ModalViewController
        
        let container = transitionContext.containerView
        let duration = transitionDuration(using: transitionContext)
        
        container.addSubview(to.view)
        
        to.show() {
            transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
        }
        
    }
    
}
