//
//  FirsatDetailVC.swift
//  justkibrisManagement
//
//  Created by Bircan Sezgin on 3/1/24.
//

import UIKit

class FirsatDetailVC: UIViewController {
    
    @IBOutlet weak var firsatImageView: UIImageView!
    @IBOutlet weak var mainView: UIView!
    @IBOutlet weak var firsatBasligiLabel: UILabel!
    @IBOutlet weak var firsatAciklamasiLabel: UITextView!
    @IBOutlet weak var tarihView: UIView!
    @IBOutlet weak var firsatTarihiLabel: UILabel!
    @IBOutlet weak var indirimDurumuView: UIView!
    @IBOutlet weak var oldPriceView: UIView!
    @IBOutlet weak var oldPriceLabel: UILabel!
    @IBOutlet weak var newPriceView: UIView!
    @IBOutlet weak var newPriceLabel: UILabel!
    @IBOutlet weak var firsatDurumuView: UIView!
    @IBOutlet weak var firsatEklenisView: UIView!
    @IBOutlet weak var firsatEklenisTarihiLabel: UILabel!
    @IBOutlet weak var yayinlaButton: UIButton!
    @IBOutlet weak var kaldirButton: UIButton!
    
    
    var sendFirsat : Firsatlar?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        DispatchQueue.main.async {
            self.setupUI()
            self.setupUICompanent()
        }
        
        setupButton()
    }
    
    
}

extension FirsatDetailVC{
    private func setupUI(){
        firsatImageView.applyCornerRadius(radius: 20)
        mainView.applyCornerRadius(radius: 20)
        tarihView.applyCornerRadius(radius: 20)
        indirimDurumuView.applyCornerRadius(radius: 20)
        oldPriceView.applyCornerRadius(radius: 20)
        newPriceView.applyCornerRadius(radius: 20)
        firsatDurumuView.applyCornerRadius(radius: 20)
        firsatEklenisView.applyCornerRadius(radius: 20)
        firsatImageView.applyCornerRadius(radius: 20)
        //firsatAciklamasiLabel.applyCornerRadius(radius: 20)
        firsatAciklamasiLabel.applyCornerRadius(radius: 20)
    }
    
    
    private func setupUICompanent(){
        guard let firsat = sendFirsat else { return }
        
        firsatImageView.sd_setImage(with: URL(string: firsat.imageUrl))
        
        firsatBasligiLabel.text = firsat.firsatBasligi
        firsatAciklamasiLabel.text = firsat.firsatAciklamasi
        firsatTarihiLabel.text = firsat.firsatSonTarih
        oldPriceLabel.text = "\(firsat.firsatEskiTutar) TL"
        newPriceLabel.text = "\(firsat.firsatYeniTutar) TL"
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd-MM-yyyy HH:mm"
        firsatEklenisTarihiLabel.text =  dateFormatter.string(from: firsat.firsatEklenmeTarihi )

    }
    
    private func setupButton(){
        
        yayinlaButton.addTarget(self, action: #selector(yayinlaButtonTapped), for: .touchUpInside)
        kaldirButton.addTarget(self, action: #selector(kaldirButtonTapped), for: .touchUpInside)
        
        guard let firsat = sendFirsat else { return }
        
//        // Set initial button states based on firsatSistemiDurumu
//        yayinlaButton.isHidden = !firsat.isActive
//        kaldirButton.isHidden = !firsat.isActive
    }
    
    @objc private func yayinlaButtonTapped() {
        
    }
    
    @objc private func kaldirButtonTapped() {
        
    }
    
}
