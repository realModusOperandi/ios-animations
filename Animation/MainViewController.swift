import UIKit

/*
Licensed Materials - Property of IBM
© Copyright IBM Corporation 2015. All Rights Reserved.
This licensed material is licensed under the Apache 2.0 license. http://www.apache.org/licenses/LICENSE-2.0.
*/

/**
    Main menu of the sampler, providing buttons to get to any of the sample
    scenarios. There is no code related to the motion samples in this view
    controller.
*/

class MainViewController: UIViewController, UIScrollViewDelegate, UITableViewDataSource, UITableViewDelegate {
    
    // MARK: - Outlets
    
    @IBOutlet weak var noteViewLabel: UILabel!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var noteViewHeightConstraint: NSLayoutConstraint!
    
    // MARK: - Constants, Properties
    
    var noteViewHeight: CGFloat?
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // only enable scrolling if there is enough content
        tableView.alwaysBounceVertical = false
    }
    
    // MARK: - Scroll View
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let scrollOffset = scrollView.contentOffset.y
        
        let _: CGFloat = 30
        _ = (150 - (scrollOffset * 10)) / 150 * 2
        
        if noteViewHeight == nil {
            noteViewHeight = noteViewHeightConstraint.constant
        }
        
        let _: CGFloat = -20
        let _: CGFloat = 15
    }
    
    // MARK: - Table View
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0:
            return 4
        default:
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TableViewCellID") as! TableViewCell
        cell.backgroundColor = UIColor.clear
        
        // Display text
        switch (indexPath.section, indexPath.row) {
            case (0, 0):
                cell.label.text = "Tab Bar"
            case (0, 1):
                cell.label.text = "Search"
            case (0, 2):
                cell.label.text = "Modal"
            case (0, 3):
                cell.label.text = "Dropdown"
            default:
                cell.label.text = ""
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // Row selected, view storyboard by ID
        switch (indexPath.section, indexPath.row) {
            case (0, 0):
                showView(storyboard: "TabBar", viewControllerID: "TabBarControllerID")
            case (0, 1):
                showView(storyboard: "Search", viewControllerID: "SearchNavigationControllerID")
            case (0, 2):
                showView(storyboard: "Modal", viewControllerID: "ModalNavigationControllerID")
            case (0, 3):
                showView(storyboard: "Dropdown", viewControllerID: "DropdownViewControllerID")
            default:break
        }
        tableView.deselectRow(at: indexPath as IndexPath, animated: false)
    }

    // MARK: - Flow
    
    // The view controller is pushed in a different way depending if it's inside a 
    // navigation controller.
    func showView(storyboard: String, viewControllerID: String) {
        let sb = UIStoryboard(name: storyboard, bundle: nil)
        let vc = sb.instantiateViewController(withIdentifier: viewControllerID)
        
        if vc is UINavigationController {
            let nav = vc as! UINavigationController
            let view = nav.viewControllers.first!
            self.navigationController?.pushViewController(view, animated: true)
        } else {
            self.navigationController?.pushViewController(vc, animated: true)
        }
        
    }
    
    // MARK: - Appearance
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return UIStatusBarStyle.lightContent
    }
    
}

