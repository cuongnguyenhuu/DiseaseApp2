//
//  BoolmarkViewCell.swift
//  DiseaseDict
//
//  Created by Currie on 11/25/20.
//  Copyright © 2020 Currie. All rights reserved.
//

import UIKit

class BoolmarkViewCell: UITableViewCell {
    
    @IBOutlet weak var imageDisease: UIImageView!
    @IBOutlet weak var title: UILabel!
    @IBOutlet weak var subTitle: UILabel!
    @IBOutlet weak var bookmarkButton: UIButton!
    var disease: DiseaseModel? {
        didSet {
            updateIconBookmark()
        }
    }
    @IBAction func bookmarkButtonDidTap(_ sender: UIButton) {
        if let d = disease {
            DiseaseRealmService.shared.saveOrRemoveBookmark(diseaseModel: d) {
                print("Updated")
                updateIconBookmark()
            }
        }
    }
    
    private func updateIconBookmark(){
        if disease!.isBookmarked {
            bookmarkButton.setImage(UIImage(named: "star-filled"), for: .normal)
        } else {
            bookmarkButton.setImage(UIImage(named: "star"), for: .normal)
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        imageDisease.backgroundColor = .yellow
        imageDisease.layer.cornerRadius = 15.0
    }
    //
    //    override func setSelected(_ selected: Bool, animated: Bool) {
    //        super.setSelected(selected, animated: animated)
    //
    //        // Configure the view for the selected state
    //    }
    
}
