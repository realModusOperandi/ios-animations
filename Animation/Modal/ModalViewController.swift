import UIKit

/*
Licensed Materials - Property of IBM
© Copyright IBM Corporation 2015. All Rights Reserved.
This licensed material is licensed under the Apache 2.0 license. http://www.apache.org/licenses/LICENSE-2.0.
*/

/**
    The following class presents the modal example. It shows a grid view of
    buttons that, when clicked, will present a modal popup over the main view.

    On display in this file are the following animations, which happen
    in sequence:

    1. The modal slides up from the bottom of the screen with custom easing
    2. The indeterminate loader appears while the content loads
    3. The content fades in and zooms in from the center of the screen
*/

class ModalViewController: UIViewController, UITableViewDelegate {

    // MARK: - Outlets
    
    @IBOutlet weak var backgroundView: UIView!
    @IBOutlet weak var closeButton: UIButton!
    @IBOutlet weak var buttonImageView: UIImageView!
    @IBOutlet weak var menuBackgroundView: UIView!
    @IBOutlet weak var modalBackgroundTop: NSLayoutConstraint!
    @IBOutlet weak var modalHeadHeight: NSLayoutConstraint!
    @IBOutlet weak var menuLabel: UILabel!
    @IBOutlet weak var modalHead: UIView!
    @IBOutlet weak var loaderBG: UIView!
    @IBOutlet weak var loader: UIImageView!
    @IBOutlet weak var pdfView: UIWebView!
    
    // MARK: - Constants, Properties
    
    var modalPressed: ((_ index: Int) -> Void)?
    
    let animationMultiplier : CGFloat = 1
    let maxModalHeadHeight: CGFloat = 80
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        modalHeadHeight.constant = modalHead.bounds.size.height
        modalBackgroundTop.constant = UIScreen.main.bounds.size.height - 50
        
        self.pdfView.alpha = 0
        
        loader.animationImages = [UIImage]()
        
        for index in 100..<147 {
            let frameName = String(format: "Loader_00%03d", index)
            loader.animationImages?.append(UIImage(named:frameName)!)
        }
        
        pdfView.scrollView.delegate = self
        
        loader.animationDuration = 1.5
        loader.startAnimating()
    }
    
    // MARK: - Scroll View
    
    // header shrinks and its elements resize based on scroll position
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        // update views based on scroll offset
        
        let scrollOffset = scrollView.contentOffset.y
        let maxScrollOffset: CGFloat = 40
        
        // scalePerfect :       1 when modalHead at full size (at top of scroll), 0 when hodalHead is at it's smallest
        // labelEndPercent :    percentage of height of label at it's smallest
        let scalePercent = (self.modalHead.bounds.height - 40) / maxModalHeadHeight * 2
        let labelEndPercent = (self.modalHead.bounds.height / maxModalHeadHeight) + (0.15 * (1 - scalePercent))
        
        self.view.layoutIfNeeded()
        
        if (scrollOffset < 0) {
            // at top
            // set to max position
            self.menuLabel.transform = CGAffineTransform.identity
            self.buttonImageView.alpha = 1
            self.closeButton.isEnabled = true
            
            UIView.animate(withDuration: 0.1, animations: {
                self.modalHeadHeight.constant = 80
                self.view.layoutIfNeeded()
            })
        } else {
            // between max and min scale
            // proportionally adjust the header and it's children
            if scrollOffset < maxScrollOffset {
                self.buttonImageView.alpha = scalePercent
                self.closeButton.isEnabled = true
                self.menuLabel.transform = CGAffineTransform(scaleX: labelEndPercent, y: labelEndPercent)
                self.buttonImageView.transform = CGAffineTransform(scaleX: labelEndPercent, y: labelEndPercent)
                
                UIView.animate(withDuration: 0.1, animations: {
                    self.modalHeadHeight.constant = (80 - scrollOffset)
                    self.view.layoutIfNeeded()
                })
            } else {
                // scrolled beyond minimun
                // set to min position
                self.buttonImageView.alpha = 0
                self.closeButton.isEnabled = false
                self.menuLabel.transform = CGAffineTransform(scaleX: (self.modalHead.bounds.height / maxModalHeadHeight) + 0.15, y: (self.modalHead.bounds.height / maxModalHeadHeight) + 0.2)
                
                UIView.animate(withDuration: 0.1, animations: {
                    self.modalHeadHeight.constant = 40
                    self.view.layoutIfNeeded()
                })
            }
        }
    }
    
    // MARK: - Transition Animations
    
    func show(completion: @escaping () -> Void ) {
    
        let animationDuration = Double(self.animationMultiplier) * 1 / 3.0;
        
        backgroundView.alpha = 0
        loaderBG.alpha = 1
        loader.alpha = 1
        
        UIView.animate(withDuration: animationDuration, animations: { () -> Void in
            
            self.backgroundView.alpha = 1
        }, completion: { finished in
            // display PDF
            // first string value is pdf file name
            let pdfLoc = NSURL(fileURLWithPath:Bundle.main.path(forResource: "Bee", ofType:"pdf")!)
            let request = NSURLRequest(url: pdfLoc as URL);
            self.pdfView.loadRequest(request as URLRequest);
            self.pdfView.alpha = 0
            self.pdfView.transform = CGAffineTransform(scaleX: 0.75, y: 0.75)
            
            // show PDF
            UIView.animate(withDuration: animationDuration, delay: 1.5, options: [], animations: { () -> Void in
                    self.loader.alpha = 0 // fade out loader
                }, completion: { finished in
                    UIView.animate(withDuration: 0.25, delay: 0, options: [], animations: { () -> Void in
                            // fade in PDF
                            self.loaderBG.alpha = 0
                            self.pdfView.alpha = 1
                            self.pdfView.transform = CGAffineTransform.identity
                        }, completion: { finished in
                            
                    })
            })
            
        })
        
        _ = LayoutConstraintAnimator(constraint: self.modalBackgroundTop, delay: 0, duration: animationDuration, toConstant: CGFloat(0), easing: LayoutConstraintEasing.Bezier(x1: 0.5, y1: 0.08, x2: 0.0, y2: 1.0), completion: completion)
    }
    
    func hide(completion: @escaping () -> Void ) {
        
        let animationDuration = Double(self.animationMultiplier) * 1 / 4.0;
        
        self.view.layoutIfNeeded()
        
        UIView.animate(withDuration: animationDuration, animations: { () -> Void in
            self.backgroundView.alpha = 0
        })
        
        _ = LayoutConstraintAnimator(constraint: self.modalBackgroundTop, delay: 0, duration: animationDuration, toConstant: (UIScreen.main.bounds.size.height + 100), easing: LayoutConstraintEasing.Bezier(x1: 0.5, y1: 0.08, x2: 0.0, y2: 1.0)) {
            
            self.modalPressed?(0)
            completion()
        }
    }
    
    // MARK: - Actions
    
    @IBAction func hideAction(_ sender: AnyObject) {
        closeButton.isHidden = true
        dismiss(animated: true, completion: nil)
    }
    
    // MARK: - Appearance
    
    override var prefersStatusBarHidden: Bool {
        return false
    }

    override var preferredStatusBarStyle: UIStatusBarStyle {
        return UIStatusBarStyle.lightContent
    }
    
}
