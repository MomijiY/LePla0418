//
//  PlanDetailViewController.swift
//  LePla0418
//
//  Created by 吉川椛 on 2020/04/20.
//  Copyright © 2020 com.litech. All rights reserved.
//

import UIKit

class PlanDetailViewController: UITableViewController {

    @IBOutlet weak var timeOneLabel: UILabel!
    @IBOutlet weak var timeTwoLabel: UILabel!
    @IBOutlet weak var subjectLabel: UILabel!
    @IBOutlet weak var contentLabel: UILabel!
    
    private var addPlan: AddPlan!
    
    static func instance(_ addplan: AddPlan) -> PlanDetailViewController {
        let vc = UIStoryboard(name: "PlanDetailViewController", bundle: nil).instantiateInitialViewController() as! PlanDetailViewController
        vc.addPlan = addplan
        return vc
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpLabels()
    }

}

extension PlanDetailViewController {
    func setUpLabels() {
        timeOneLabel.text = addPlan.timeOne
        timeTwoLabel.text = addPlan.timeTwo
        subjectLabel.text = addPlan.subject
        contentLabel.text = addPlan.content
    }
}
