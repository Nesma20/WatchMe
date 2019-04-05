//
//  ReviewTableViewCell.swift
//  WatchMe
//
//  Created by ashraf on 4/5/19.
//  Copyright © 2019 nesma. All rights reserved.
//

import UIKit

class ReviewTableViewCell: UITableViewCell {

    @IBOutlet weak var contentTxt: UITextView!
    @IBOutlet weak var authorLbl: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
