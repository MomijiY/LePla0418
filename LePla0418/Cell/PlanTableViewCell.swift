//
//  PlanTableViewCell.swift
//  LePla0418
//
//  Created by 吉川椛 on 2020/04/19.
//  Copyright © 2020 com.litech. All rights reserved.
//

import UIKit

class PlanTableViewCell: UITableViewCell {

    @IBOutlet private weak var timeOneLabel: UILabel!
    @IBOutlet private weak var timeTwoLabel: UILabel!
    @IBOutlet private weak var subjectLabel: UILabel!
    @IBOutlet private weak var contentLabel: UILabel!
    @IBOutlet private weak var pinImage: UIImageView!
    
    // MARK: Static properties
    
    static let reuseIdentifier = "PlanTableViewCell"
    static let rowHeight: CGFloat = 100
    
    static var nib: UINib {
        return UINib(nibName: "PlanTableViewCell", bundle: nil)
    }
    
    func setUpPlanCell(timeOne: String, timeTwo: String, subject: String, content: String) {
        timeOneLabel.text = timeOne
        timeTwoLabel.text = timeTwo
        subjectLabel.text = subject
        contentLabel.text = content
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
}
