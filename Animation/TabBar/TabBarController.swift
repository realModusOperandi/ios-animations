import UIKit

/*
Licensed Materials - Property of IBM
© Copyright IBM Corporation 2015. All Rights Reserved.
This licensed material is licensed under the Apache 2.0 license. http://www.apache.org/licenses/LICENSE-2.0.
*/

/**
    The following class presents the tab bar example. On display in this file
    are the following animations:

    1. There is a cross-dissolve animation when switching to the 1st & 2nd tabs
    2. The third tab content view animates up from the bottom of the screen
    3. The tab content views all have an exit animation
    4. The tab buttons all have a vertical fill animation
*/

class TabBarController: UITabBarController, UITabBarControllerDelegate {

    // MARK: - Constants, Properties
    
    var indicatorView1: UIView?
    var indicatorView2: UIView?
    var indicatorView3: UIView?
    
    let indicatorHeight: CGFloat = 6.0
    
    private var previousItem: UITabBarItem?
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // set colors of UITabBar elements
        UITabBar.appearance().backgroundColor = UIColor.clear
        UITabBar.appearance().shadowImage = UIImage()
        UITabBar.appearance().backgroundImage = UIImage()
        UITabBar.appearance().tintColor = UIColor.white
        
        // set tab bar height to custom height
        var rect = tabBar.frame
        rect.size.height = 55
        rect.origin.y = view.frame.size.height - rect.size.height
        tabBar.frame = rect
        
        // set the default and selected icon for each tab bar item
        (self.tabBar.items![0]).image = UIImage(named: "dashboard_green")!.withRenderingMode(UIImageRenderingMode.alwaysOriginal)
        (self.tabBar.items![0]).selectedImage = UIImage(named: "dashboard_white")!.withRenderingMode(UIImageRenderingMode.alwaysOriginal)
        (self.tabBar.items![1]).image = UIImage(named: "stats_green")!.withRenderingMode(UIImageRenderingMode.alwaysOriginal)
        (self.tabBar.items![1]).selectedImage = UIImage(named: "stats_white")!.withRenderingMode(UIImageRenderingMode.alwaysOriginal)
        (self.tabBar.items![2]).image = UIImage(named: "contacts_green")!.withRenderingMode(UIImageRenderingMode.alwaysOriginal)
        (self.tabBar.items![2]).selectedImage = UIImage(named: "contacts_white")!.withRenderingMode(UIImageRenderingMode.alwaysOriginal)
        
        let indicatorContainerView = UIView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 60))
        indicatorContainerView.backgroundColor = MotionStyleKit.motion_Color
        indicatorContainerView.translatesAutoresizingMaskIntoConstraints = false
        
        view.sendSubview(toBack: indicatorContainerView)
        view.addSubview(indicatorContainerView)
        
        let constraint1 = NSLayoutConstraint(item: indicatorContainerView, attribute: NSLayoutAttribute.bottom, relatedBy: NSLayoutRelation.equal, toItem: view, attribute: NSLayoutAttribute.bottom, multiplier: 1.0, constant: 0.0)
        
        let constraint2 = NSLayoutConstraint(item: indicatorContainerView, attribute: NSLayoutAttribute.left, relatedBy: NSLayoutRelation.equal, toItem: view, attribute: NSLayoutAttribute.left, multiplier: 1.0, constant: 0.0)
    
        let constraint3 = NSLayoutConstraint(item: indicatorContainerView, attribute: NSLayoutAttribute.right, relatedBy: NSLayoutRelation.equal, toItem: view, attribute: NSLayoutAttribute.right, multiplier: 1.0, constant: 0.0)
        
        let constraint4 = NSLayoutConstraint(item: indicatorContainerView, attribute: NSLayoutAttribute.height, relatedBy: NSLayoutRelation.equal, toItem: tabBar, attribute: NSLayoutAttribute.height, multiplier: 1.0, constant: 10.0)
        
        view.addConstraints([constraint1, constraint2, constraint3, constraint4])
        
        indicatorView1 = UIView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width / 3, height: 60))
        indicatorView1?.backgroundColor = MotionStyleKit.motion_DarkColor
        
        indicatorView2 = UIView(frame: CGRect(x: UIScreen.main.bounds.width / 3, y: 0, width: UIScreen.main.bounds.width / 3, height: 60))
        indicatorView2?.backgroundColor = MotionStyleKit.motion_DarkColor
        indicatorView2?.layer.transform = CATransform3DMakeTranslation(0, 60, 0)
        
        indicatorView3 = UIView(frame: CGRect(x: 2 * UIScreen.main.bounds.width / 3, y: 0, width: UIScreen.main.bounds.width / 3, height: 60))
        indicatorView3?.backgroundColor = MotionStyleKit.motion_DarkColor
        indicatorView3?.layer.transform = CATransform3DMakeTranslation(0, 60, 0)
        
        previousItem = tabBar.items![0] as UITabBarItem
        
        indicatorContainerView.addSubview(indicatorView1!)
        indicatorContainerView.addSubview(indicatorView2!)
        indicatorContainerView.addSubview(indicatorView3!)
        
        view.bringSubview(toFront: tabBar)
        
        delegate = self
    }
    
    // MARK: - Tab Bar
    
    override func tabBar(_ tabBar: UITabBar, didSelect item: UITabBarItem) {
        
        if item == previousItem {
            return
        }
        
        if let iv1 = self.indicatorView1 {
            if item == tabBar.items![0] as UITabBarItem || previousItem == tabBar.items![0] as UITabBarItem {
                let translation: CGFloat = item == tabBar.items![0] as UITabBarItem ? 0 : 60.0
                iv1.layer.transform = CATransform3DMakeTranslation(0, 60.0 - translation, 0)
                ViewAnimator.animateView(view: iv1, withDuration: 0.4, andEasingFunction: LayoutConstraintEasing.EaseInMTF, toTransform: CATransform3DMakeTranslation(0.0, translation, 0.0))
            }
        }
        
        if let iv2 = self.indicatorView2 {
            if item == tabBar.items![1] as UITabBarItem || previousItem == tabBar.items![1] as UITabBarItem {
                let translation: CGFloat = item == tabBar.items![1] as UITabBarItem ? 0 : 60.0
                iv2.layer.transform = CATransform3DMakeTranslation(0, 60.0 - translation, 0)
                ViewAnimator.animateView(view: iv2, withDuration: 0.4, andEasingFunction: LayoutConstraintEasing.EaseInMTF, toTransform: CATransform3DMakeTranslation(0.0, translation, 0.0))
            }
            
        }
        
        if let iv3 = self.indicatorView3 {
            if item == tabBar.items![2] as UITabBarItem || previousItem == tabBar.items![2] as UITabBarItem {
                let translation: CGFloat = item == tabBar.items![2] as UITabBarItem ? 0 : 60.0
                iv3.layer.transform = CATransform3DMakeTranslation(0, 60.0 - translation, 0)
                ViewAnimator.animateView(view: iv3, withDuration: 0.4, andEasingFunction: LayoutConstraintEasing.EaseInMTF, toTransform: CATransform3DMakeTranslation(0.0, translation, 0.0))
            }
        }

        previousItem = item
    }
    
    func tabBarController(_ tabBarController: UITabBarController, animationControllerForTransitionFrom fromVC: UIViewController, to toVC: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        
        var fromIndex = 0
        var toIndex = 0
        
        for index in 0...viewControllers!.count - 1 {
            
            if viewControllers![index] as UIViewController == fromVC {
                fromIndex = index
            }
            if viewControllers![index] as UIViewController == toVC {
                toIndex = index
            }
        }
        
        return TabBarExampleAnimatedTransitioning(fromIndex: fromIndex, toIndex: toIndex)
        
    }
    
}
