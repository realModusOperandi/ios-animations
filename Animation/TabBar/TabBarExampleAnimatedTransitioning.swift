import UIKit

/*
Licensed Materials - Property of IBM
© Copyright IBM Corporation 2015. All Rights Reserved.
This licensed material is licensed under the Apache 2.0 license. http://www.apache.org/licenses/LICENSE-2.0.
*/

class TabBarExampleAnimatedTransitioning: NSObject, UIViewControllerAnimatedTransitioning {
 
    var isPresenting = false
    
    let fromIndex: Int
    let toIndex: Int
    
    let animMultiplier: Double = 1.0
    
    init(fromIndex: Int, toIndex: Int) {
        self.fromIndex = fromIndex
        self.toIndex = toIndex
        super.init()
    }
    
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return 0.4
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        
        let to = transitionContext.viewController(forKey: UITransitionContextViewControllerKey.to)! as UIViewController
        let from = transitionContext.viewController(forKey: UITransitionContextViewControllerKey.from)! as UIViewController
        
        let container = transitionContext.containerView
        _ = transitionDuration(using: transitionContext)
        
        container.addSubview(to.view)
        
        _ = toIndex > fromIndex ? CGFloat(-1) : CGFloat(1)

        if to is TabBarPeopleViewController {
            to.view.transform = CGAffineTransform(translationX: 0, y: to.view.bounds.height)
        } else if from is TabBarPeopleViewController {
            to.view.alpha = 1.0
            container.addSubview(from.view)
        } else {
            from.view.alpha = 1.0
            to.view.alpha = 0.0
        }
        
        UIView.animate(withDuration: animMultiplier * transitionDuration(using: transitionContext), delay: animMultiplier * 0.0, options: [], animations: { () -> Void in
            
            to.view.alpha = 1.0
            to.view.transform = CGAffineTransform.identity
            
            if let fromPeople = from as? TabBarPeopleViewController {
                fromPeople.view.transform = CGAffineTransform(translationX: 0, y: from.view.bounds.height)
            }
            
        }) { finished in
            
            to.view.transform = CGAffineTransform.identity
            from.view.transform = CGAffineTransform.identity
            transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
            
        }
    }
    
}
