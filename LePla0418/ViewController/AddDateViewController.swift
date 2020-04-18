//
//  AddDateViewController.swift
//  LePla0418
//
//  Created by 吉川椛 on 2020/04/18.
//  Copyright © 2020 com.litech. All rights reserved.
//

import UIKit

class AddDateViewController: UITableViewController {

    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var descriptionTextField: UITextField!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var top: UISwitch!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    @IBAction func topSwitchTapped(_ sender: UISwitch) {
        if sender.isOn {
            
        } else {
            
        }
    }
}

extension AddDateViewController {
    
    @objc func selectDate() {
        
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        switch indexPath.section {
        case 2:
            selectDate()
        default:
            break
        }
    }
    
}
