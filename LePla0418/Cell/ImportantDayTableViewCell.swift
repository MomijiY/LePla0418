//
//  ImportantDayTableViewCell.swift
//  LePla0418
//
//  Created by 吉川椛 on 2020/04/18.
//  Copyright © 2020 com.litech. All rights reserved.
//

import UIKit

class ImportantDayTableViewCell: UITableViewCell {
    
    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var descriptionLabel: UILabel!
    @IBOutlet private weak var dateLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
