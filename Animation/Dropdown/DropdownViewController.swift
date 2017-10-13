import UIKit

protocol DropDownViewControllerDelegate {
    func dropDownViewControllerDidPressButton(viewController:DropdownViewController)
}

/*
Licensed Materials - Property of IBM
© Copyright IBM Corporation 2015. All Rights Reserved.
This licensed material is licensed under the Apache 2.0 license. http://www.apache.org/licenses/LICENSE-2.0.
*/

/**
    The following class presents the drop down example. It shows a static,
    inactive list of dummy data. Click the menu button in the upper-right
    corner of the screen to bring down the drop down menu. Virtually all of the
    animation in this example is being driven by the show & hide methods.

    On display in this file are the following animations, which happen
    simultaneously:

    1. The menu button animates into a close button
    2. The drop down menu animates down from navigation bar
*/

class DropdownViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    // MARK: - Outlets

    // MARK: UI Elements
    @IBOutlet weak var menuBackgroundView: UIView!
    @IBOutlet weak var separatorView: UIView!
    @IBOutlet weak var options: UITableView!
    
    // MARK: Constraints
    @IBOutlet weak var menuBackgroundTop: NSLayoutConstraint!
    @IBOutlet weak var menuBackgroundBottom: NSLayoutConstraint!
    @IBOutlet weak var menuBackgroundLeft: NSLayoutConstraint!
    @IBOutlet weak var menuBackgroundWidth: NSLayoutConstraint!
    @IBOutlet weak var optionsTop: NSLayoutConstraint!
    @IBOutlet weak var optionsBottom: NSLayoutConstraint!
    
    // MARK: - Constants, Properties
    
    let animationMultiplier : CGFloat = 1;
    let numberOfCells: Int = 6
    let cellHeight: Int = 60
    let animationImages: [UIImage] = [
        UIImage(named: "circle_x_00")!,
        UIImage(named: "circle_x_01")!,
        UIImage(named: "circle_x_02")!,
        UIImage(named: "circle_x_03")!,
        UIImage(named: "circle_x_04")!,
        UIImage(named: "circle_x_05")!,
        UIImage(named: "circle_x_06")!,
        UIImage(named: "circle_x_07")!
    ];
    
    var delegate:DropDownViewControllerDelegate?
    var reversedAnimationImages: [UIImage] { get { return animationImages.reversed() } }
    var tableHeight: CGFloat { get { return CGFloat(cellHeight * numberOfCells) } }
    var dropdownPressed: ((_ index: Int) -> Void)?
    var isOpen = false
    
    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        
        menuBackgroundWidth.constant = UIScreen.main.bounds.size.width
        optionsTop.constant = -UIScreen.main.bounds.size.height
        optionsBottom.constant = UIScreen.main.bounds.size.height
        
    }
    
    // MARK: - Transition Animations

    func show(completion: (() -> Void)?) {
        let animationDuration = Double(self.animationMultiplier) * 1 / 2.5
        var dropdownBottom: CGFloat
        
        if tableHeight < UIScreen.main.bounds.size.height {
            dropdownBottom =
                UIScreen.main.bounds.size.height - tableHeight - separatorView.bounds.height
        } else {
            dropdownBottom = 10
        }
        
        let easing = LayoutConstraintEasing.Bezier(x1: 0.5, y1: 0.08, x2: 0.0, y2: 1.0)
        _ = LayoutConstraintAnimator(constraint: self.optionsTop, delay: 0,
            duration: animationDuration, toConstant: CGFloat(0), easing: easing,
            completion: nil)
        _ = LayoutConstraintAnimator(constraint: self.optionsBottom, delay: 0,
            duration: animationDuration, toConstant: dropdownBottom,
            easing: easing, completion: nil)
    }
    
    func hide(completion: (() -> Void)?) {
        let animationDuration = Double(self.animationMultiplier) * 1 / 2.5
        let easing = LayoutConstraintEasing.Bezier(x1: 0.5, y1: 0.08, x2: 0.0, y2: 1.0)
        let constant = UIScreen.main.bounds.size.height
        
        _ = LayoutConstraintAnimator(constraint: self.optionsTop, delay: 0,
            duration: animationDuration, toConstant: -constant, easing: easing,
            completion: nil)
        _ = LayoutConstraintAnimator(constraint: self.optionsBottom, delay: 0,
            duration: animationDuration, toConstant: constant, easing: easing,
            completion: nil)
    }
    
    func toggle() {
        if (isOpen) {
            self.hide(completion: nil)
        } else {
            self.show(completion: nil)
        }
        
        isOpen = !isOpen
    }
    
    // MARK: - Table View

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return numberOfCells
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "DropdownOptionCell") as! DropdownOptionCell
        
        cell.label.text = "Option \(indexPath.row + 1)"
        
        switch indexPath.row {
            case 0: cell.icon.image = UIImage(named: "slider")!
            case 1: cell.icon.image = UIImage(named: "person")!
            case 2: cell.icon.image = UIImage(named: "save")!
            case 3: cell.icon.image = UIImage(named: "book")!
            case 4: cell.icon.image = UIImage(named: "chat")!
            case 5: cell.icon.image = UIImage(named: "drawer")!
            default: break
            
        }
        
        return cell;
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath as IndexPath, animated: true)
        self.toggle()
        self.delegate?.dropDownViewControllerDidPressButton(viewController: self)
    }
    
    // MARK: - Appearance
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
}

// MARK: - Table View Cells

internal class DropdownOptionCell: UITableViewCell {
    
    @IBOutlet weak var icon: UIImageView!
    @IBOutlet weak var label: UILabel!
    
}

