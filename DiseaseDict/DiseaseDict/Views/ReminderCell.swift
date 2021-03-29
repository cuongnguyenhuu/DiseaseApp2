//
//  ReminderCell.swift
//  DiseaseDict
//
//  Created by Currie on 1/20/21.
//  Copyright © 2021 Currie. All rights reserved.
//

import UIKit

class ReminderCell: UITableViewCell {

    @IBOutlet weak var day: UILabel!
    @IBOutlet weak var monthAndYear: UILabel!
    @IBOutlet weak var title: UILabel!
    @IBOutlet weak var time: UILabel!
    @IBOutlet weak var repeats: UILabel!
    @IBOutlet weak var notes: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
