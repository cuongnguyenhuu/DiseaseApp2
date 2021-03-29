//
//  DiseaseViewCell.swift
//  DiseaseDict
//
//  Created by Currie on 11/26/20.
//  Copyright © 2020 Currie. All rights reserved.
//

import UIKit

class DiseaseViewCell: UITableViewCell {

    @IBOutlet weak var imageDisease: UIImageView!
    @IBOutlet weak var title: UILabel!
    @IBOutlet weak var subTitle: UILabel!
    @IBOutlet weak var bookmarkButton: UIButton!
    var disease: DiseaseModel? {
        didSet {
            updateIconBookmark()
        }
    }
    
    //Save
    
    private func updateIconBookmark(){
        if disease!.isBookmarked {
            bookmarkButton.setImage(UIImage(named: "star-filled"), for: .normal)
        } else {
            bookmarkButton.setImage(UIImage(named: "star"), for: .normal)
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
    
//    init() {
//
//    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        imageDisease.backgroundColor = .yellow
        imageDisease.layer.cornerRadius = 15.0
//        if disease!.isBookmarked {
//            if #available(iOS 13.0, *) {
//                bookmarkButton.setImage(UIImage(systemName: "star.fill"), for: .normal)
//            } else {
//                // Fallback on earlier versions
//            }
//        } else {
//            if #available(iOS 13.0, *) {
//                bookmarkButton.setImage(UIImage(systemName: "star"), for: .normal)
//            } else {
//                // Fallback on earlier versions
//            }
//        }
    }

//    override func layoutSubviews() {
//        super.layoutSubviews()
//        //set the values for top,left,bottom,right margins
//        let margins = UIEdgeInsets(top: 0, left: 0, bottom: 10, right: 0)
//        contentView.frame = contentView.frame.inset(by: margins)
//    }
//    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
