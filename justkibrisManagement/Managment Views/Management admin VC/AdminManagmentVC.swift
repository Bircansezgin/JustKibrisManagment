//
//  AdminManagmentVC.swift
//  justkibrisManagement
//
//  Created by Bircan Sezgin on 08-02-24.
//

import UIKit

class AdminManagmentVC: UIViewController {

    @IBOutlet weak var headerView: UIView!
    @IBOutlet weak var oneMenuView: UIView!
    @IBOutlet weak var twoMenuView: UIView!
    
    @IBOutlet weak var newCompanyAddButton: UIButton!
    @IBOutlet weak var companyEditButton: UIButton!
    @IBOutlet weak var newSponsorAddButton: UIButton!
    @IBOutlet weak var sponsorEditButton: UIButton!
    @IBOutlet weak var allUsersPushNotifButton: UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        DispatchQueue.main.async {
            self.setupUI()
        }
        self.setupButton()
    }


   

}

extension AdminManagmentVC{
    private func setupUI(){
        headerView.layer.cornerRadius = 15
        headerView.layer.masksToBounds = true
        
        oneMenuView.layer.cornerRadius = 15
        oneMenuView.layer.masksToBounds = true
        
        twoMenuView.layer.cornerRadius = 15
        twoMenuView.layer.masksToBounds = true
    }
    
    private func setupButton(){
        newCompanyAddButton.addTarget(self, action: #selector(goNewAddCompany), for: .touchUpInside)
        companyEditButton.addTarget(self, action: #selector(goCompanyEdit), for: .touchUpInside)
    }
}

// MARK: - Button Functions
extension AdminManagmentVC{
    @objc func goNewAddCompany(){
        let newCompanyPage = NewCompanyAddVC()
        newCompanyPage.modalPresentationStyle = .fullScreen // veya .pageSheet
        newCompanyPage.modalTransitionStyle = .coverVertical
        present(newCompanyPage, animated: true, completion: nil)
    }
    
    @objc func goCompanyEdit(){
        let companyEditPage = CompanyEditVC()
        companyEditPage.modalPresentationStyle = .fullScreen // veya .pageSheet
        companyEditPage.modalTransitionStyle = .coverVertical
        present(companyEditPage, animated: true, completion: nil)
    }
}
