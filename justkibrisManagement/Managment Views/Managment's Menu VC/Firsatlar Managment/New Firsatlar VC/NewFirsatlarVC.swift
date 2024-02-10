//
//  NewFirsatlarVC.swift
//  justkibrisManagement
//
//  Created by Bircan Sezgin on 10-02-24.
//

import UIKit
import Firebase
import FirebaseFirestore
import FirebaseStorage

class NewFirsatlarVC: UIViewController {
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var firsatBasligiTextF: UITextField!
    @IBOutlet weak var firsatAciklamasiTextF: UITextField!
    @IBOutlet weak var firsatSonTarihTextF: UITextField!
    @IBOutlet weak var firsatEskiTutarTextF: UITextField!
    @IBOutlet weak var firsatYeniTutarTextF: UITextField!
    @IBOutlet weak var firsatSistemKapanisTarihTextF: UITextField!
    
    @IBOutlet weak var firsatKullanimSayisiTextF: UITextField!
    
    @IBOutlet weak var firsatYukleButton: UIButton!
    @IBOutlet weak var backButton: UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupPickerView()
        setupButton()
        setupImageViewTap()
        
        
    }
    
    
    
    
}

// SETUP UI
extension NewFirsatlarVC{
    private func setupButton(){
        firsatYukleButton.addTarget(self, action: #selector(uploadButton), for: .touchUpInside)
    }
    
    @objc func uploadButton() {
        guard let firsatBasligi = firsatBasligiTextF.text, !firsatBasligi.isEmpty,
              let firsatAciklamasi = firsatAciklamasiTextF.text, !firsatAciklamasi.isEmpty,
              let firsatSonTarih = firsatSonTarihTextF.text, !firsatSonTarih.isEmpty,
              let firsatEskiTutar = firsatEskiTutarTextF.text, !firsatEskiTutar.isEmpty,
              let firsatYeniTutar = firsatYeniTutarTextF.text, !firsatYeniTutar.isEmpty,
              let firsatSistemKapanisTarih = firsatSistemKapanisTarihTextF.text, !firsatSistemKapanisTarih.isEmpty,
              let firsatKullanimSayisi = firsatKullanimSayisiTextF.text, !firsatKullanimSayisi.isEmpty,
              let selectedImage = imageView.image else {
            
            let alert = UIAlertController(title: "Eksik Veri", message: "Lütfen tüm alanları doldurun ve bir resim seçin.", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Tamam", style: .default, handler: nil))
            present(alert, animated: true, completion: nil)
            return
        }
        
        let alert = UIAlertController(title: "Yayınlanma Onayı", message: "Fırsatı yayınlamak istiyor musunuz?", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Yayınla", style: .default, handler: { (_) in
            self.uploadToFirestore(isActive: true)
        }))
        alert.addAction(UIAlertAction(title: "İptal", style: .cancel, handler: nil))
        present(alert, animated: true, completion: nil)
    }

}

//MARK: - Selected Photo
extension NewFirsatlarVC: UIImagePickerControllerDelegate, UINavigationControllerDelegate{
    private func setupImageViewTap(){
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(imageViewTapped))
        imageView.addGestureRecognizer(tapGesture)
        imageView.isUserInteractionEnabled = true
    }
    
    @objc func imageViewTapped() {
        let imagePickerController = UIImagePickerController()
        imagePickerController.delegate = self
        imagePickerController.sourceType = .photoLibrary
        imagePickerController.allowsEditing = true
        present(imagePickerController, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let selectedImage = info[.originalImage] as? UIImage {
            imageView.image = selectedImage
            imageView.contentMode = .scaleAspectFill
            imageView.layer.cornerRadius = 15
            imageView.layer.masksToBounds = true
        }
        dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
}



//MARK: - Date PickerView
extension NewFirsatlarVC{
    private func setupPickerView(){
        // Tarih ve saat seçimi için UIDatePicker
        let dateTimePicker1 = UIDatePicker()
        dateTimePicker1.datePickerMode = .dateAndTime
        dateTimePicker1.addTarget(self, action: #selector(dateTimePickerValueChanged(_:)), for: .valueChanged)
        firsatSonTarihTextF.inputView = dateTimePicker1
        
        // Tarih ve saat seçimi için başka bir UIDatePicker
        let dateTimePicker2 = UIDatePicker()
        dateTimePicker2.datePickerMode = .dateAndTime
        dateTimePicker2.addTarget(self, action: #selector(dateTimePickerValueChanged(_:)), for: .valueChanged)
        firsatSistemKapanisTarihTextF.inputView = dateTimePicker2
    }
    
    @objc func dateTimePickerValueChanged(_ sender: UIDatePicker) {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd/MM/yyyy HH:mm"
        let formattedDate = dateFormatter.string(from: sender.date)
        
        if firsatSonTarihTextF.isFirstResponder {
            firsatSonTarihTextF.text = formattedDate
        } else if firsatSistemKapanisTarihTextF.isFirstResponder {
            firsatSistemKapanisTarihTextF.text = formattedDate
        }
    }
}


// MARK: - DB
extension NewFirsatlarVC {
    private func uploadToFirestore(isActive: Bool) {
        guard let firsatBasligi = firsatBasligiTextF.text, !firsatBasligi.isEmpty,
              let firsatAciklamasi = firsatAciklamasiTextF.text, !firsatAciklamasi.isEmpty,
              let firsatSonTarih = firsatSonTarihTextF.text, !firsatSonTarih.isEmpty,
              let firsatEskiTutar = firsatEskiTutarTextF.text, !firsatEskiTutar.isEmpty,
              let firsatYeniTutar = firsatYeniTutarTextF.text, !firsatYeniTutar.isEmpty,
              let firsatSistemKapanisTarih = firsatSistemKapanisTarihTextF.text, !firsatSistemKapanisTarih.isEmpty,
              let firsatKullanimSayisi = firsatKullanimSayisiTextF.text, !firsatKullanimSayisi.isEmpty else {
            
            let alert = UIAlertController(title: "Eksik Veri", message: "Lütfen tüm alanları doldurun.", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Tamam", style: .default, handler: nil))
            present(alert, animated: true, completion: nil)
            return
        }
        
        let dateFormatter = DateFormatter()
           dateFormatter.dateFormat = "dd/MM/yyyy HH:mm"
           guard let firsatSistemKapanisTarih = dateFormatter.date(from: firsatSistemKapanisTarih) else {
               let alert = UIAlertController(title: "Yanlış Tarih Format", message: "Lütfen Tarih Giriniz.", preferredStyle: .alert)
               alert.addAction(UIAlertAction(title: "Tamam", style: .default, handler: nil))
               present(alert, animated: true, completion: nil)
               return
           }
           let firsatSistemKapanisTarihTimestamp = Timestamp(date: firsatSistemKapanisTarih)
        
        guard let firsatEskiTutar = Int(firsatEskiTutar),
                let firsatYeniTutar = Int(firsatYeniTutar),
                let firsatKullanimSayisi = Int(firsatKullanimSayisi) else {
            
            let alert = UIAlertController(title: "Yanlış Format", message: "Lütfen Fırsat Eski, Yeni ve Kullanım Sayılarını Tam sayı yazınız", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Tamam", style: .default, handler: nil))
            present(alert, animated: true, completion: nil)
              return
          }
        

        var ref: DocumentReference? = nil
        var uuids = UUID().uuidString
        let db = Firestore.firestore()
        let customDocumentName = "\(firsatBasligi)\(uuids)"
        db.collection("firsatlar").document(customDocumentName).setData([
            "firsatBasligi": firsatBasligi,
            "firsatAciklamasi": firsatAciklamasi,
            "firsatSonTarih": firsatSonTarih,
            "firsatEskiTutar": firsatEskiTutar,
            "firsatYeniTutar": firsatYeniTutar,
            "firsatSistemKapanisTarih": firsatSistemKapanisTarihTimestamp,
            "firsatKullanimSayisi": firsatKullanimSayisi,
            "isActive": isActive ? 1 : 0,
            "firsatEklenmeTarihi": FieldValue.serverTimestamp()
        ]) { err in
            if let err = err {
                print("Error adding document: \(err)")
            } else {
                print("Document added with custom ID: \(customDocumentName)")
                ref = db.collection("firsatlar").document(customDocumentName)
            }
        }
        
        let storageRef = Storage.storage().reference()
        let imageRef = storageRef.child("Firsatlar/\(UUID().uuidString).jpg")
        
        if let imageData = imageView.image?.jpegData(compressionQuality: 0.5) {
            imageRef.putData(imageData, metadata: nil) { (metadata, error) in
                guard let _ = metadata else {
                    print("Error uploading image: \(error?.localizedDescription ?? "Unknown error")")
                    return
                }
                
                // Resmin indirme URL'sini alma
                imageRef.downloadURL { (url, error) in
                    if let downloadURL = url {
                        ref?.updateData(["imageUrl": downloadURL.absoluteString])
                        print("Image uploaded successfully. Download URL: \(downloadURL)")
                        self.newAlert(title: "Durum", Message: "Yükleme Başarılı!")
                    } else {
                        print("Error getting download URL: \(error?.localizedDescription ?? "Unknown error")")
                    }
                }
            }
        }
    }
}


extension NewFirsatlarVC{
    private func newAlert(title: String, Message: String){
        let alert = UIAlertController(title: title, message: Message, preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: "Tamam", style: .default, handler: { UIAlertAction in
            self.dismiss(animated: true)
        }))
        present(alert, animated: true, completion: nil)
    }
}


