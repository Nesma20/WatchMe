//
//  FavoriteTableViewCell.swift
//  WatchMe
//
//  Created by ashraf on 4/13/19.
//  Copyright © 2019 nesma. All rights reserved.
//

import UIKit

class FavoriteTableViewCell: UITableViewCell {

    
    @IBOutlet weak var favoriteMovieImg: UIImageView!
    
    @IBOutlet weak var favoriteMovieTitle: UILabel!
    
    @IBOutlet weak var favoriteMovieRate: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
 

}
