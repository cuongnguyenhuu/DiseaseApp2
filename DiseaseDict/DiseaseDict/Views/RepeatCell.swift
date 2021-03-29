//
//  RepeatCell.swift
//  DiseaseDict
//
//  Created by Currie on 1/18/21.
//  Copyright © 2021 Currie. All rights reserved.
//

import UIKit

class RepeatCell: UITableViewCell {

    @IBOutlet weak var repeatLabel: UILabel!
    @IBOutlet weak var imgCheck: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
