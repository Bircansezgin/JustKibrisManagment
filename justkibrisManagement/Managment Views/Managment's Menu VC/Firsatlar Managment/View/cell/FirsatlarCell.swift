//
//  FirsatlarCell.swift
//  justkibrisManagement
//
//  Created by Bircan Sezgin on 3/1/24.
//

import UIKit
import SDWebImage

class FirsatlarCell: UITableViewCell {
    
    @IBOutlet weak var firsatImageView: UIImageView!
    @IBOutlet weak var firsatHeader: UILabel!
    @IBOutlet weak var firsatDecrip: UILabel!
    @IBOutlet weak var firsatDateLabel: UILabel!
    
    func configure(with firsat: Firsatlar) {
           firsatImageView.sd_setImage(with: URL(string: firsat.imageUrl), placeholderImage: UIImage(named: "placeholder"))
           firsatHeader.text = firsat.firsatBasligi
           firsatDecrip.text = firsat.firsatAciklamasi
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd-MM-yyyy HH:mm"
        firsatDateLabel.text = dateFormatter.string(from: firsat.firsatEklenmeTarihi)
        
        
        firsatImageView.layer.cornerRadius = 15
        firsatImageView.layer.masksToBounds = true
        firsatImageView.contentMode = .scaleAspectFill
        
       }
    

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
