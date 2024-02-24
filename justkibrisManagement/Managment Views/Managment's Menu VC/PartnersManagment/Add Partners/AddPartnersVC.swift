//
//  AddPartnersVC.swift
//  justkibrisManagement
//
//  Created by Bircan Sezgin on 2/24/24.
//

import UIKit
import Firebase
import FirebaseStorage

class AddPartnersVC: UIViewController {

    @IBOutlet weak var selectedImageView: UIImageView!
    @IBOutlet weak var middleView: UIView!
    @IBOutlet weak var partnerNameTextView: UITextField!
    @IBOutlet weak var addPartnerButton: UIButton!
    @IBOutlet weak var statusLabel: UILabel!
    
    var photoSelected = false
    var imagePicker = UIImagePickerController()

    
    override func viewDidLoad() {
        super.viewDidLoad()
        DispatchQueue.main.async {
            self.setupUI()
        }
        setupImageGesture()
        setupButton()
        setupDelegete()

    }

    

}


extension AddPartnersVC{
    private func setupUI(){
        middleView.layer.cornerRadius = 15
        middleView.layer.masksToBounds = true
    }
    
    private func setupButton(){
        addPartnerButton.addTarget(self, action: #selector(clickAddPartner), for: .touchUpInside)
    }
    
    private func setupDelegete(){
        imagePicker.delegate = self
    }
    
    private func setupImageGesture(){
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleImageTap))
          selectedImageView.addGestureRecognizer(tapGesture)
          selectedImageView.isUserInteractionEnabled = true
    }
    
    @objc private func handleImageTap() {
        presentImagePicker()
    }
    
    @objc func clickAddPartner(){
        guard let image = selectedImageView.image, photoSelected else {
             // Kullanıcı bir fotoğraf seçmemişse veya seçim işlemi başarısız olduysa uyarı gösterin
             showAlert(title: "Uyarı", message: "Lütfen bir fotoğraf seçin.")
             return
         }
         
         guard let imageData = image.jpegData(compressionQuality: 0.5) else {
             // Fotoğrafı Data'ya çevirirken bir hata olursa uyarı gösterin
             showAlert(title: "Hata", message: "Fotoğrafı işlerken bir hata oluştu.")
             return
         }
        
        uploadImageToFirebase(data: imageData)
    }
}


// MARK: - SELECTED PHOTO
extension AddPartnersVC: UIImagePickerControllerDelegate, UINavigationControllerDelegate{
    private func presentImagePicker() {
        imagePicker.allowsEditing = true
        imagePicker.sourceType = .photoLibrary
        present(imagePicker, animated: true, completion: nil)
    }
    
    // Fotoğraf seçildiğinde çağrılır
       func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
           if let editedImage = info[.editedImage] as? UIImage {
               selectedImageView.image = editedImage
               photoSelected = true
           } else if let originalImage = info[.originalImage] as? UIImage {
               selectedImageView.image = originalImage
               photoSelected = true
           }

           // Fotoğraf seçildikten sonra picker kapatılır
           dismiss(animated: true, completion: nil)
       }

       // Fotoğraf seçimi iptal edildiğinde çağrılır
       func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
           dismiss(animated: true, completion: nil)
       }
}


extension UIViewController {
    func showAlert(title: String, message: String) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        let okAction = UIAlertAction(title: "Tamam", style: .default, handler: nil)
        alertController.addAction(okAction)
        
        present(alertController, animated: true, completion: nil)
    }
}



extension AddPartnersVC{
    private func uploadImageToFirebase(data: Data) {
        self.statusLabel.isHidden = false
        self.addPartnerButton.isEnabled = false
        // Resim dosyasının adını ve yolunu belirleyin (örneğin, kullanıcının UID'si ile)
        let imageFileName = "\(UUID().uuidString).jpg"
        let imageStorageRef = Storage.storage().reference().child("partner_images").child(imageFileName)
        
        // Storage'a fotoğrafı yükleyin
        imageStorageRef.putData(data, metadata: nil) { (metadata, error) in
            if let error = error {
                self.statusLabel.isHidden = true
                self.addPartnerButton.isEnabled = true
                self.showAlert(title: "Hata", message: error.localizedDescription)
            } else {
                // Fotoğraf başarıyla yüklendiyse, URL'yi alın ve partner eklemeye devam edin
                imageStorageRef.downloadURL { (url, error) in
                    if let imageUrl = url {
                        // Fotoğrafın URL'sini aldık, şimdi Partners eklemeye devam edebiliriz
                        self.addPartnerToFirebase(imageUrl: imageUrl.absoluteString)
                    } else {
                        self.statusLabel.isHidden = true
                        self.addPartnerButton.isEnabled = true
                        self.showAlert(title: "Hata", message: "Fotoğraf URL'sini alırken bir hata oluştu.")
                    }
                }
            }
        }
    }
    
    
    
    private func addPartnerToFirebase(imageUrl: String) {
        guard let partnerName = partnerNameTextView.text, !partnerName.isEmpty else {
            showAlert(title: "Uyarı", message: "Lütfen Partners adını girin.")
            self.statusLabel.isHidden = true
            self.addPartnerButton.isEnabled = true
            return
        }
        
        let db = Firestore.firestore()
        let uuid = UUID().uuidString
        let partnersRef = db.collection("partners")
        
        let documentID = partnerName.lowercased() + uuid
        
        partnersRef.document(documentID).setData([
            "partnerID": documentID,
            "partnerName": partnerName,
            "partnerImageURL": imageUrl,
            "partnerAddDate": FieldValue.serverTimestamp(),
            "whoAdded": "Admin", // Buraya Giriş yapan kişi eklenebilir
            "isActive" : 0
        ]) { (error) in
            if let error = error {
                self.statusLabel.isHidden = true
                self.addPartnerButton.isEnabled = true
                self.showAlert(title: "Hata", message: error.localizedDescription)
            } else {
                // Partners başarıyla eklendi
                self.showAlert(title: "Başarılı", message: "Partners başarıyla eklendi.")
            }
        }
    }


}
