//
//  EtkinliklerCell.swift
//  JustCyprus
//
//  Created by Bircan Sezgin on 5.01.2024.
//

import UIKit

class CompanyTCell: UITableViewCell {
    
    @IBOutlet weak var activityImageView: UIImageView!
    @IBOutlet weak var mekanOwnerLabel: UILabel!
    @IBOutlet weak var activityNameLabel: UILabel!
    @IBOutlet weak var activityDateLabel: UILabel!
    @IBOutlet weak var durumLabel: UILabel!
    @IBOutlet weak var activityPriceLabel: UILabel!
    
    

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

     
    }

}
