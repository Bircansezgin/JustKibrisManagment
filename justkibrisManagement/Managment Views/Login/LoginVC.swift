//
//  LoginVC.swift
//  justkibrisManagement
//
//  Created by Bircan Sezgin on 08-02-24.
//

import UIKit
import Firebase
import FirebaseAuth
import FirebaseFirestore

class LoginVC: UIViewController {
    
    @IBOutlet weak var backView: UIView!
    
    @IBOutlet weak var companyCodeTextF: UITextField!
    @IBOutlet weak var userNameTextF: UITextField!
    @IBOutlet weak var passwordTextF: UITextField!
    @IBOutlet weak var helpView: UIView!
    @IBOutlet weak var loginButton: UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupButton()
        setupCloseKeyBoard()
        DispatchQueue.main.async {
            self.autoLogin()
        }
        
    }
    
    
    
    
}

// MARK: - Setup UI
extension LoginVC{
    private func setupUI(){
        backView.layer.cornerRadius = 20
        backView.layer.masksToBounds = true
        
        helpView.layer.cornerRadius = 20
        helpView.layer.masksToBounds = true
    }
}

//MARK: - Login
extension LoginVC{
    private func setupButton(){
        loginButton.addTarget(self, action: #selector(loginClick), for: .touchUpInside)
    }
    
    @objc func loginClick() {
        guard let email = userNameTextF.text, !email.isEmpty,
              let password = passwordTextF.text, !password.isEmpty else {
            // Hata mesajı göster
            showAlert(message: "Lütfen tüm alanları doldurunuz")
            return
        }
        
        Auth.auth().signIn(withEmail: email, password: password) { [weak self] authResult, error in
            guard let strongSelf = self else { return }
            if let error = error {
                strongSelf.showAlert(message: "Giriş başarısız: \(error.localizedDescription)")
            } else {
                if let user = authResult?.user {
                    strongSelf.checkCompanyCode(forUser: user)
                }
            }
        }
    }

    func checkCompanyCode(forUser user: User) {
        guard let email = user.email, let companyCodeInput = companyCodeTextF.text else {
            showAlert(message: "Gerekli bilgiler eksik.")
            return
        }

        let db = Firestore.firestore()
        db.collection("AdminLogin").whereField("username", isEqualTo: email).getDocuments { [weak self] (querySnapshot, error) in
            if let error = error {
                self?.showAlert(message: "Sorgu sırasında bir hata oluştu: \(error.localizedDescription)")
                return
            }

            guard let documents = querySnapshot?.documents, !documents.isEmpty else {
                self?.showAlert(message: "Kullanıcı bilgileri bulunamadı.")
                return
            }

            for document in documents {
                let data = document.data()
                if data["companyCode"] as? String == companyCodeInput {
                    self!.navigateToHomePage()
                    return
                }
            }

            self?.showAlert(message: "Şirket kodu eşleşmiyor.")
        }
    }

    
       
       private func navigateToHomePage() {
           let adminManagementVC = AdminManagmentVC()
           adminManagementVC.modalPresentationStyle = .fullScreen // veya .pageSheet
           adminManagementVC.modalTransitionStyle = .coverVertical
           present(adminManagementVC, animated: true, completion: nil)
       }
}

//MARK: -
extension LoginVC{
    // ALert
    private func showAlert(message: String) {
        let alert = UIAlertController(title: "Hata", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Tamam", style: .default))
        present(alert, animated: true)
    }
    
    // KeyBoard
    
    func setupCloseKeyBoard(){
        let tap = UITapGestureRecognizer(target: self, action: #selector(close_keyboard))
        view.addGestureRecognizer(tap)
    }
    
    @objc func close_keyboard(){
        view.endEditing(true)
    }
}


// Auto Login
extension LoginVC{
    private func autoLogin() {
        if Auth.auth().currentUser != nil {
            print("Gecis Var")
            navigateToHomePage()
        }else{
            print("Aktif Kullanici Yok!")
        }
    }
}
