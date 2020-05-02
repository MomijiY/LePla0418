//
//  ImportantDayTableViewCell.swift
//  LePla0418
//
//  Created by 吉川椛 on 2020/04/18.
//  Copyright © 2020 com.litech. All rights reserved.
//

import UIKit

class ImportantDayTableViewCell: UITableViewCell {
    
    // MARK: IBOutlet
    
    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var descriptionLabel: UILabel!
    @IBOutlet private weak var dateLabel: UILabel!
    @IBOutlet weak var pinImage: UIImageView!
    // MARK: Static properties
    
    static let reuseIdentifier = "ImportantDayTableViewCell"
    static let rowHeight: CGFloat = 100
    static var nib: UINib {
        return UINib(nibName: "ImportantDayTableViewCell", bundle: nil)
    }

    // MARK: Overrides
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    // MARK: Setup
    
    func setupCell(title: String, content: String, date: String) {
        titleLabel.text = title
        descriptionLabel.text = content
        dateLabel.text = date
    }
    
    func setUpPin(pin: String) {
        if pin == "true" {
            pinImage.isHidden = false
        } else {
            pinImage.isHidden = true
        }
    }
}
