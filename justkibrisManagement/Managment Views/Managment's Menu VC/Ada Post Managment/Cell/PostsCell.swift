//
//  PostsCell.swift
//  justkibrisManagement
//
//  Created by Bircan Sezgin on 2/29/24.
//

import UIKit

class PostsCell: UITableViewCell {
    @IBOutlet weak var postImageCEll: UIImageView!
    @IBOutlet weak var postOwnerLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
