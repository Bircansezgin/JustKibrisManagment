//
//  PostDetailVC.swift
//  justkibrisManagement
//
//  Created by Bircan Sezgin on 2/29/24.
//

import UIKit

class PostDetailVC: UIViewController {
    
    @IBOutlet weak var backView: UIVisualEffectView!
    @IBOutlet weak var middleView: UIView!
    @IBOutlet weak var buttonViews: UIView!
    @IBOutlet weak var postingPhoto: UIImageView!
    @IBOutlet weak var postOwnerLabel: UILabel!
    @IBOutlet weak var categoryLabel: UILabel!
    @IBOutlet weak var postDateLabel: UILabel!
    
    @IBOutlet weak var activityView: UIView!
    
    @IBOutlet weak var activitiyImageS: UIImageView!
    @IBOutlet weak var activityPlaceName: UILabel!
    @IBOutlet weak var activityNameLabel: UILabel!
    @IBOutlet weak var activityDateLabel: UILabel!
    @IBOutlet weak var activityPriceLabel: UILabel!
    
    
    @IBOutlet weak var exitButton: UIButton!
    @IBOutlet weak var acceptButton: UIButton!
    @IBOutlet weak var redButton: UIButton!
    
    
    var sendingPost: Post?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        DispatchQueue.main.async {
            self.setupUI()
            
        }
        
        self.setupButton()
        
    }
    
    
    
    
    
}


extension PostDetailVC{
    private func showAlertStatus(title: String, message: String) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        alertController.addAction(okAction)
        present(alertController, animated: true, completion: nil)
    }
    
    private func showAlertSuccess(title: String, message: String) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default) { _ in
            self.dismiss(animated: true)
        }
        alertController.addAction(okAction)
        present(alertController, animated: true, completion: nil)
    }
}

//MARK: - Setup
extension PostDetailVC{
    private func setupUI() {
        
        backView.layer.cornerRadius = 20
        backView.layer.masksToBounds = true
        
        middleView.layer.cornerRadius = 20
        middleView.layer.masksToBounds = true
        
        guard let post = sendingPost else {
            showAlertStatus(title: "Hata", message: "Gönderi bilgisi yok.")
            return
        }
        
        acceptButton.isEnabled = post.isActivePost != 2
        redButton.isEnabled = post.isActivePost != 1
        
        postOwnerLabel.text = post.userName
        categoryLabel.text = post.activityCategory
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd.MM.yyyy HH:mm"
        postDateLabel.text = dateFormatter.string(from: post.postSendingDate)
        
        if let photoURL = URL(string: post.postPhotoURL) {
            postingPhoto.sd_setImage(with: photoURL, completed: nil)
            
            postingPhoto.layer.cornerRadius = 15
            postingPhoto.layer.masksToBounds = true
        }
        
        // Ek bilgileri de atama
        activityPlaceName.text = post.activityPlace
        activityNameLabel.text = post.activityName
        
        let activityDateFormatter = DateFormatter()
        activityDateFormatter.dateFormat = "dd.MM.yyyy HH:mm"
        activityDateLabel.text = activityDateFormatter.string(from: post.postSendingDate)
        
        activitiyImageS.sd_setImage(with: URL(string: post.activityPosterImageURL))
        
    }
    
    private func setupButton(){
        acceptButton.addTarget(self, action: #selector(acceptClick), for: .touchUpInside)
        redButton.addTarget(self, action: #selector(redClick), for: .touchUpInside)
        exitButton.addTarget(self, action: #selector(backClick), for: .touchUpInside)
        
    }
    
    @objc func acceptClick() {
        guard var post = sendingPost else {
            showAlert(title: "Hata", message: "Gönderi bilgisi yok.")
            return
        }
        
        post.isActivePost = 2
        
        // PostManager üzerinden güncellenmiş postu kaydet
        PostManager.shared.updatePost(post) { success in
            if success {
                self.showAlertSuccess(title: "Başarılı", message: "Gönderi başarıyla güncellendi.")
                print("Post isActive updated successfully.")
            } else {
                self.showAlertStatus(title: "Hata", message: "Gönderi güncellenirken bir hata oluştu.")
                print("Error updating post isActive.")
            }
        }
    }
    
    @objc func redClick() {
        guard var post = sendingPost else {
            showAlertStatus(title: "Hata", message: "Gönderi bilgisi yok.")
            return
        }
        
        post.isActivePost = 1
        
        // PostManager üzerinden güncellenmiş postu kaydet
        PostManager.shared.updatePost(post) { success in
            if success {
                self.showAlertSuccess(title: "Başarılı", message: "Gönderi başarıyla güncellendi.")
                print("Post isActive updated successfully.")
            } else {
                self.showAlertStatus(title: "Hata", message: "Gönderi güncellenirken bir hata oluştu.")
                print("Error updating post isActive.")
            }
        }
    }
    
    
    @objc func backClick(){
        self.dismiss(animated: true)
    }
}



