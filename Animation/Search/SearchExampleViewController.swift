import UIKit

/*
Licensed Materials - Property of IBM
© Copyright IBM Corporation 2015. All Rights Reserved.
This licensed material is licensed under the Apache 2.0 license. http://www.apache.org/licenses/LICENSE-2.0.
*/

/**
    The following class presents the search & search results example. On display
    in this file are the following animations, which happen in sequence:

    1. Navigation bar compresses/expands when keyboard appears/hides
    2. Indeterminate loader while performing the search
    3. Search results animate in from center

    Note that this class does not perform any kind of asynchronous operation to
    get search results. There is a hard-coded delay to display a loader, and
    then a static search result is displayed.
*/

class SearchExampleViewController: ExampleNobelViewController, UITextFieldDelegate {

    // MARK: - Outlets
    
    // MARK: UI Elements
    @IBOutlet weak var searchFieldBackground: UIView!
    @IBOutlet weak var searchField: UITextField!
    @IBOutlet weak var searchIcon: UIButton!
    @IBOutlet weak var xButton: UIButton!
    @IBOutlet weak var itemsView: UIScrollView!
    @IBOutlet weak var loader: UIImageView!
    @IBOutlet weak var searchTitleLabel: UILabel!
    @IBOutlet weak var resultsView: UIView!
    @IBOutlet weak var resultsLabel: UILabel!
    @IBOutlet weak var disciplineLabel: UILabel!
    
    // MARK: Constraints
    @IBOutlet weak var searchFieldHeight: NSLayoutConstraint!
    @IBOutlet weak var searchIconTop: NSLayoutConstraint!
    @IBOutlet weak var searchTitleBottom: NSLayoutConstraint!
    @IBOutlet weak var resultsViewLeft: NSLayoutConstraint!
    @IBOutlet weak var resultsViewRight: NSLayoutConstraint!
    @IBOutlet weak var tableViewLeft: NSLayoutConstraint!
    @IBOutlet weak var tableViewRight: NSLayoutConstraint!
    
    // MARK: - Constants, Properties
    
    let animMultiplier: CGFloat = 2.0
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        searchFieldBackground.backgroundColor = UIColor(white: 0.957, alpha: 1)
        
        tableView.isHidden = true
        resultsView.isHidden = true
        xButton.isHidden = true
        
        self.prepareLoader()
        self.searchField.addTarget(self, action: #selector(SearchExampleViewController.textChanged), for: .editingChanged)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        let tapRecognizer = UITapGestureRecognizer(target: self, action: #selector(SearchExampleViewController.handleSingleTap(_:)))
        tapRecognizer.numberOfTapsRequired = 1
        self.view.addGestureRecognizer(tapRecognizer)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        searchField.resignFirstResponder()
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UIKeyboardWillShow, object: nil)
    }
    
    func prepareLoader() -> Void {
        loader.animationImages = [UIImage]()
        
        // grabs the animation frames from the bundle
        for index in 100..<147 {
            let frameName = String(format: "Loader_00%03d", index)
            loader.animationImages?.append(UIImage(named:frameName)!)
        }
        
        loader.animationDuration = 1.5
        loader.stopAnimating()
        loader.isHidden = true
    }
    
    // MARK: - Actions
    
    @IBAction func xPressed(_ sender: AnyObject) {
        self.searchField.text = ""
        self.xButton.isHidden = true
        textFieldDidBeginEditing(searchField)
    }
    
    // MARK: - Flow
    
    /**
     * Starts the animation after the enter/submit button has been pressed
     */
    func search(text: String) {
        showResults(results: text)
    }
    
    /**
     * Gesture recognizer which will hide the keyboard when the user clicks
     * outside of the search textfield.
     */
    @objc func handleSingleTap(_ recognizer: UITapGestureRecognizer) {
        expandHeader()
        hideResults()
    }
    
    /**
     * Performs all of the animations necessary to display the search results
     * 
     * :param: results The string to display as the search result
     */
    func showResults(results: String) {
        resultsLabel.text = results
        disciplineLabel.text = ""
        resultsView.isHidden = false
        
        // 1. set animation to initial state
        self.resultsViewLeft.constant = 0
        self.resultsViewRight.constant = 0
        
        resultsView.alpha = 0
        resultsView.layer.transform = CATransform3DMakeScale(0.75, 0.75, 1.0)
        
        loader.alpha = 0
        loader.startAnimating()
        loader.isHidden = false
        
        // 2. show indeterminate loader
        UIView.animate(withDuration: 0.25, animations: { () -> Void in
            self.loader.alpha = 1
        }, completion: nil)
        
        // 3. hide loader
        let animationDuration = TimeInterval(animMultiplier) * 0.15
        let options: UIViewAnimationOptions = []
        UIView.animate(withDuration: animationDuration, delay: 1.5,
            options: options, animations: {
            self.loader.alpha = 0
        }, completion: { finished in
                
            // 4a. cleanup loader
            self.loader.stopAnimating()
            self.loader.isHidden = true
            
            // 4b. zoom in the results view
            ViewAnimator.animateView(view: self.resultsView,
                withDuration: 0.25,
                andEasingFunction: LayoutConstraintEasing.EaseInOutMTF,
                toTransform: CATransform3DIdentity)
            
            // 4c. fade in the results view
            UIView.animate(withDuration: 0.25, animations: { () -> Void in
                self.resultsView.alpha = 1
                self.resultsView.transform = CGAffineTransform.identity
            }, completion: nil)
        })
        
        expandHeader()
    }
    
    /**
     * Hides the results and displays the initial set of data
     */
    func hideResults() -> Void {
        let animationDuration: Double = Double(animMultiplier * 0.3)
        let animationDelay: TimeInterval = 0

        UIView.animate(withDuration: animationDuration, delay: animationDelay,
            options: [], animations: { () -> Void in
            self.itemsView.alpha = 1.0
            self.tableView.alpha = 1.0
        }, completion: nil)
    }
    
    func collapseHeader() -> Void {
        self.resultsView.alpha = 0
        
        let constraintsToAnimate: [NSLayoutConstraint] = [
            searchIconTop, searchFieldHeight, searchTitleBottom
        ]
        let toValues: [CGFloat] = [30, 40, 0]
        let animationDuration: TimeInterval = Double(animMultiplier * 0.2)
        
        _ = LayoutConstraintAnimator(constraints: constraintsToAnimate, delay: 0,
            duration: animationDuration, toConstants: toValues,
            easing: LayoutConstraintEasing.EaseInOut, completion: nil)
        
        UIView.animate(withDuration: Double(animMultiplier) * 0.2, animations: { () -> Void in
            self.searchTitleLabel.transform = CGAffineTransform(scaleX: 0.75, y: 0.75)
        })
        
        UIView.animate(withDuration: Double(animMultiplier) * 0.3, animations: { () -> Void in
            self.tableView.alpha = 0.2
            self.itemsView.alpha = 0.2
        })
    }
    
    func expandHeader() -> Void {
        let constraintsToAnimate: [NSLayoutConstraint] = [
            searchIconTop, searchFieldHeight, searchTitleBottom
        ]
        let toValues: [CGFloat] = [70, 80, 18]
        let animationDuration: Double = Double(animMultiplier * 0.3)
        
        _ = LayoutConstraintAnimator(constraints: constraintsToAnimate,
            delay: 0, duration: animationDuration, toConstants: toValues,
            easing: LayoutConstraintEasing.EaseInOut, completion: nil)
        
        UIView.animate(withDuration: Double(self.animMultiplier) * 0.3, animations: { () -> Void in
            self.searchTitleLabel.transform = CGAffineTransform.identity
        })
        
        xButton.isHidden = true
        
        let delay = Double(animMultiplier) * 0.1 * Double(NSEC_PER_SEC)
        let time = DispatchTime.now() + delay
        //let time = dispatch_time(dispatch_time_t(DISPATCH_TIME_NOW), Int64(delay))
        
        DispatchQueue.main.asyncAfter(deadline: time, execute: { () -> Void in
            self.searchField.resignFirstResponder()
        })
    }
    
    // MARK: - Appearance
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return UIStatusBarStyle.lightContent
    }
    
    // MARK: - Text Field
    
    @objc func textChanged() -> Void {
        self.xButton.isHidden = self.searchField.text?.characters.count == 0
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        self.collapseHeader()
        
        self.xButton.isHidden = textField.text?.count == 0
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        guard let text = textField.text, text.count >= 2 else {
            return false
        }
        
        search(text: text)
        
        return true
    }
    
    func textFieldShouldClear(_ textField: UITextField) -> Bool {
        return true
    }
}
