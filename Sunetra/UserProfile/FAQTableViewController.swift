//
//  FAQTableViewController.swift
//  FAQs
//
//  Created by Rohit Singh on 05/06/24.
//

import UIKit

class FAQTableViewController: UITableViewController {
    
    var tableViewData : [cellData] = DataController.shared.faqData // Array to store cell data
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return tableViewData.count
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableViewData[section].opened {
            // Include the title row plus section data rows if section is opened
            return tableViewData[section].sectionData.count + 1
        } else {
            return 1 // Only the title row if section is closed
        }
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row == 0 {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "cell") else { return UITableViewCell() }
            cell.textLabel?.text = tableViewData[indexPath.section].title
            cell.accessoryType = .disclosureIndicator
//            cell.textLabel?.font = UIFont.systemFont(ofSize: 17)
            return cell
        } else {
            // Configure and return cell for section data row
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "cell") else { return UITableViewCell() }
            cell.textLabel?.text = tableViewData[indexPath.section].sectionData[indexPath.row - 1]
            cell.accessoryType = .none
            cell.textLabel?.font = UIFont.systemFont(ofSize: 14)
            cell.textLabel?.textColor = .black
            return cell
        }
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // Toggle the opened flag for the selected section and reload the section
        if tableViewData[indexPath.section].opened == true {
            tableViewData[indexPath.section].opened = false
            let sections = IndexSet.init(integer: indexPath.section)
            tableView.reloadSections(sections, with: .fade)
        } else {
            tableViewData[indexPath.section].opened = true
            let sections = IndexSet.init(integer: indexPath.section)
            tableView.reloadSections(sections, with: .fade)
        }
    }
}
