import UIKit

/*
Licensed Materials - Property of IBM
© Copyright IBM Corporation 2015. All Rights Reserved.
This licensed material is licensed under the Apache 2.0 license. http://www.apache.org/licenses/LICENSE-2.0.
*/

/**
    This class exists to serve as a base view controller for some of the
    samples. It does not contain any animation sample code, but provides a
    UITableView populated with placeholder data for visual effect.
*/

class ExampleNobelViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    // MARK: - Outlets
    
    @IBOutlet weak var tableView: UITableView!
    
    // MARK: - Constants, Properties
    
    var nobelsAlphabetically: [Any]?
    var nobelsByDiscipline: [Any]?
    var nobels: [Any]?
    var filteredNobels: [Any]?
    var filters: [Bool] = []
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadData()
    }
    
    func loadData() {
        let bundle = Bundle.main
        
        let path1 = bundle.path(forResource: "nobels_alphabetically", ofType: "json")
        let data1:NSData = NSData(contentsOfFile: path1!)!
        var json1: Any = []
        do {
            json1 = try JSONSerialization.jsonObject(with: data1 as Data, options: JSONSerialization.ReadingOptions.allowFragments)
        } catch {
            print("nobels_alphabetically.json could not be read")
        }
        
        nobelsAlphabetically = json1 as? [Any]
      
        let path2 = bundle.path(forResource: "nobels_by_discipline", ofType: "json")
        let data2:NSData = NSData(contentsOfFile: path2!)!
        var json2: Any = []
        do {
            json2 = try JSONSerialization.jsonObject(with: data2 as Data, options: JSONSerialization.ReadingOptions.allowFragments)
        } catch {
            print("nobels_by_discipline could not be read")
        }
        
        nobelsByDiscipline = json2 as? [Any]
        
        filters = [true, true, true, true]
        
        sortAlphabetically()
    }
    
    // MARK: - Data Manipulation
    
    func sortAlphabetically() {
        nobels = nobelsAlphabetically
        updateFilters()
    }
    
    func sortByDiscipline() {
        nobels = nobelsByDiscipline
        updateFilters()
    }
    
    func updateFilters() {
        
        filteredNobels = []
        
        if let nobels = nobels {
            for index in 0...nobels.count - 1 {
                if let section = nobels[index] as? [String: Any] {
                    let array = section["Data"] as? [Any]
                    var nobel_dict: [String: Any] = [:]
                    
                    nobel_dict["Section"] = section["Section"]
                    
                    var nobel_array: [Any] = []
                    if let array = array {
                        for nobel_index in 0...array.count - 1 {
                            let person_dict = array[nobel_index] as? NSDictionary
                            if let person_dict = person_dict {
                                let discipline = person_dict["Discipline"] as? String
                                
                                if let discipline = discipline {
                                    if filters[0] && discipline == "Chemistry" {
                                        nobel_array.append(array[nobel_index])
                                    }
                                    else if filters[1] && discipline == "Economics" {
                                        nobel_array.append(array[nobel_index])
                                    }
                                    else if filters[2] && discipline == "Literature" {
                                        nobel_array.append(array[nobel_index])
                                    }
                                    else if filters[3] && discipline == "Medicine" {
                                        nobel_array.append(array[nobel_index])
                                    }
                                }
                            }
                        }
                    }
                    
                    nobel_dict["Data"] = nobel_array
                    
                    filteredNobels?.append(nobel_dict)

                }
            }
        }
        
        tableView.reloadData()
    }
    
    // MARK: - Table View
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        if let nobels = filteredNobels {
            return nobels.count
        } else {
            return 0
        }
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let nobels = filteredNobels {
            let nobelsInSection = nobels[section] as! [String: Any]
            let nobelData = nobelsInSection["Data"] as! [Any]
            return nobelData.count
        } else {
            return 0
        }
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let table = tableView as! TableView
        let cell = tableView.dequeueReusableCell(withIdentifier: table.cellID, for: indexPath as IndexPath) as! TableViewCell
        
        if let nobels = filteredNobels {
            //let person = (nobels[indexPath.section]["Data"][indexPath.row] as? NSDictionary
            let nobelsInSection = nobels[indexPath.section] as! [String: Any]
            let nobelData = nobelsInSection["Data"] as! [Any]
            if let person = nobelData[indexPath.row] as? [String: Any] {
                
                let lastName = person["Last name"] as! String
                let firstName = person["First name"] as! String
                
                cell.label.text = "\(lastName), \(firstName)"
                
                cell.smallLabel.text = person["Discipline"] as? String
                
            }
        }
    
        cell.selectionStyle = UITableViewCellSelectionStyle.none
        
        return cell
    }

    func tableView(_ tableView: UITableView, sectionForSectionIndexTitle title: String, at index: Int) -> Int {
        return index
    }

    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "TableViewHeaderCellID") as! TableViewHeaderCell
        if let nobels = filteredNobels {
            let nobelsInSection = nobels[section] as! [String: Any]
            cell.label.text = nobelsInSection["Section"] as? String
        }
        return cell
        
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }

    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 80
    }
}
