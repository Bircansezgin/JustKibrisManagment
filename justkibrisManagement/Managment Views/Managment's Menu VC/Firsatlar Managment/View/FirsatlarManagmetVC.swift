//
//  FirsatlarManagmetVC.swift
//  justkibrisManagement
//
//  Created by Bircan Sezgin on 3/1/24.
//

import UIKit
import Firebase
import SDWebImage

class FirsatlarManagmetVC: UIViewController {
    
    @IBOutlet weak var backView: UIView!
    @IBOutlet weak var exitButton: UIButton!
    @IBOutlet weak var newFirsatButton: UIButton!
    @IBOutlet weak var tableView: UITableView!
    
    var commonFirsat = [Firsatlar]()
    var isActiveSegment: Int = 1

    override func viewDidLoad() {
        super.viewDidLoad()
        
        DispatchQueue.main.async {
            self.setupTableViewDelegete()
            self.setupUI()
            self.firsatFetch(isActive: self.isActiveSegment)
   
        }
        setupButton()
        
        
    }

    @IBAction func segmentActions(_ sender: Any) {
       
        switch (sender as AnyObject).selectedSegmentIndex {
           case 0:
               firsatFetch(isActive: 1)
            self.tableView.reloadData()
           case 1:
            firsatFetch(isActive: 0)
            self.tableView.reloadData()
           default:
               break
           }
        
        self.tableView.reloadData()
    }
    
    
}

extension FirsatlarManagmetVC{
    private func setupUI(){
        backView.layer.cornerRadius = 15
        backView.layer.masksToBounds = true
        
        tableView.layer.cornerRadius = 15
        tableView.layer.masksToBounds = true
    }
    
    private func setupButton(){
        exitButton.addTarget(self, action: #selector(exitClick), for: .touchUpInside)
        newFirsatButton.addTarget(self, action: #selector(newClick), for: .touchUpInside)
    }
    
    @objc func exitClick(){
        self.dismiss(animated: true)
    }
    
    @objc func newClick(){
        let newFirsat = NewFirsatlarVC()
        present(newFirsat, animated: true)
    }
}


//MARK: - TableView
extension FirsatlarManagmetVC: UITableViewDelegate, UITableViewDataSource{
    private func setupTableViewDelegete(){
        tableView.delegate = self
        tableView.dataSource = self
        
        
        let nib = UINib(nibName: "FirsatlarCell", bundle: nil)
        tableView.register(nib, forCellReuseIdentifier: "FirsatlarCell")
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return commonFirsat.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "FirsatlarCell", for: indexPath) as? FirsatlarCell{
            
            cell.configure(with: commonFirsat[indexPath.row])
            
            
            return cell
        }
        
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selecetFirsat = commonFirsat[indexPath.row]
        let firsatDetail = FirsatDetailVC()
        firsatDetail.sendFirsat = selecetFirsat
        self.present(firsatDetail, animated: true)
    }
    
}


//MARK: - Fetch DATA DB
extension FirsatlarManagmetVC{
    func firsatFetch(isActive: Int) {
           let db = Firestore.firestore()
           db.collection("firsatlar")
               .whereField("isActive", isEqualTo: isActive)
               .order(by: "firsatEklenmeTarihi", descending: true)
               .addSnapshotListener { [weak self] (querySnapshot, error) in
                   guard let self = self else { return }
                   if let error = error {
                       print("Error getting documents: \(error)")
                   } else if let snapshot = querySnapshot {
                       let firsatlar = snapshot.documents.compactMap { document in
                           do {
                               let firsat = try Firestore.Decoder().decode(Firsatlar.self, from: document.data())
                               return firsat
                           } catch {
                               print("Error decoding firsat data: \(error)")
                               return nil
                           }
                       }
                       print("SOZ : \(firsatlar.count)")
                       self.commonFirsat = firsatlar
                       self.tableView.reloadData()
                   }
               }
       }
}

