//
//  PartnesControllVC.swift
//  justkibrisManagement
//
//  Created by Bircan Sezgin on 2/24/24.
//

import UIKit

class PartnesControllVC: UIViewController {
    @IBOutlet weak var addButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupButton()
    }


    

}


extension PartnesControllVC{
    private func setupUI(){
        
    }
    
    private func setupButton(){
        addButton.addTarget(self, action: #selector(clickADDbutton), for: .touchUpInside)
    }
    
    @objc func clickADDbutton(){
        let addPartnersPage = AddPartnersVC()
        self.present(addPartnersPage, animated: true)
    }
}
