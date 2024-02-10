
import UIKit
import PhotosUI
import Firebase
import FirebaseStorage
import FirebaseFirestore

class NewSponsorAddVC: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITextFieldDelegate, UITextViewDelegate {
    @IBOutlet weak var headerView: UIView!
    
    @IBOutlet weak var sponsorView: UIView!
    @IBOutlet weak var sponsorImageView: UIImageView!
    
    
    @IBOutlet weak var firstQView: UIView!
    @IBOutlet weak var brandNameTextF: UITextField!
    @IBOutlet weak var brandTypeTextF: UITextField!
     
    
    @IBOutlet weak var secondQView: UIView!
    @IBOutlet weak var destinationTextV: UITextView!

    
    @IBOutlet weak var thirtQView: UIView!
    @IBOutlet weak var brandPhoneNumberTextF: UITextField!
    
    @IBOutlet weak var fourQView: UIView!
    @IBOutlet weak var brandDiscoundTextF: UITextField!
    @IBOutlet weak var brandDateTextF: UITextField!
    
    @IBOutlet weak var fiveQView: UIView!
    @IBOutlet weak var brandPriceRecTextF: UITextField!
    
    
    @IBOutlet weak var sixQView: UIView!
    @IBOutlet weak var sponsorFinishDateT: UITextField!
    
    
    @IBOutlet weak var managerView: UIView!
    @IBOutlet weak var sponsorUploadButton: UIButton!
    @IBOutlet weak var backButton: UIButton!
    
    
    var brodcastOptions = Int()
    let db = Firestore.firestore()

    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupButton()
        setup_gestureReco()
        setup_close_KeyBoard()
        
    }
 
}

//MARK: - Delegete
extension NewSponsorAddVC{

    func setup_textField_Delegete(){
        brandNameTextF.delegate = self
        brandTypeTextF.delegate = self
        destinationTextV.delegate = self
        brandPhoneNumberTextF.delegate = self
        brandDiscoundTextF.delegate = self
        brandDateTextF.delegate = self
        
       // kategoriTextField.inputView = etkinlikKategoriPickerView
        
    //    setup_PickerView_Delegete()
    }
    
    // Close Keyboard
    func setup_close_KeyBoard(){
        let tap = UITapGestureRecognizer(target: self, action: #selector(close_keyboard))
        view.addGestureRecognizer(tap)
    }
    
    @objc func close_keyboard(){
        view.endEditing(true)
    }
}

// UI
extension NewSponsorAddVC{
    private func setupUI(){
        headerView.layer.cornerRadius = 20
        headerView.layer.masksToBounds = true
        
        sponsorView.layer.cornerRadius = 20
        sponsorView.layer.masksToBounds = true
        
        firstQView.layer.cornerRadius = 20
        firstQView.layer.masksToBounds = true
        
        secondQView.layer.cornerRadius = 20
        secondQView.layer.masksToBounds = true
        
        thirtQView.layer.cornerRadius = 20
        thirtQView.layer.masksToBounds = true
        
        fourQView.layer.cornerRadius = 20
        fourQView.layer.masksToBounds = true
        
        managerView.layer.cornerRadius = 20
        managerView.layer.masksToBounds = true
        
        destinationTextV.layer.cornerRadius = 20
        destinationTextV.layer.masksToBounds = true
        
        fiveQView.layer.cornerRadius = 20
        fiveQView.layer.masksToBounds = true
        sixQView.layer.cornerRadius = 20
        sixQView.layer.masksToBounds = true
    }
    
    
    
    private func setupButton(){
        sponsorUploadButton.addTarget(self, action: #selector(uploadClick), for: .touchUpInside)
        backButton.addTarget(self, action: #selector(backClick), for: .touchUpInside)
    }
    
    
    @objc func uploadClick(){
        self.sendActivityAlert(title: "Yayın Seçenekleri", message: "Yayın Zamanını Seçiniz")
    }
    
    
    @objc func backClick(){
        self.dismiss(animated: true)
    }
    
    
    
    
//Gesture Reco
    private func setup_gestureReco(){
        sponsorImageView.isUserInteractionEnabled = true
        let gestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(choosePictures))
        sponsorImageView.addGestureRecognizer(gestureRecognizer)
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        view.addGestureRecognizer(tapGesture)
        
    }
}

//Other Code
extension NewSponsorAddVC{
    func tapticEngine(){
        let feedbackGenerator = UIImpactFeedbackGenerator(style: .heavy)
        feedbackGenerator.prepare()
        feedbackGenerator.impactOccurred()
        
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
}


//MARK: - Photo Selected
extension NewSponsorAddVC{
    @objc func choosePictures() {
        tapticEngine()
        
        let vc = UIImagePickerController()
        vc.sourceType = .photoLibrary
        vc.delegate = self
        vc.allowsEditing = true
        present(vc, animated: true)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        if let image = info[UIImagePickerController.InfoKey(rawValue: "UIImagePickerControllerEditedImage")] as? UIImage{
            sponsorImageView.contentMode = .scaleAspectFill
            sponsorImageView.layer.cornerRadius = 20
            sponsorImageView.layer.masksToBounds = true
            sponsorImageView.image = image
            headerView.backgroundColor = .systemGreen
            sponsorView.backgroundColor = .clear
        }
        
        picker.dismiss(animated: true)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true)
    }

}

//MARK: -  DB ALERT
extension NewSponsorAddVC{
    private func sendActivityAlert(title:String, message:String){
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let yayinlaButton = UIAlertAction(title: "Şimdi Yayınla", style: .cancel) { _ in
            self.brodcastOptions = 1
            guard let image = self.sponsorImageView.image else {
                 print("Hata: Activity image boş.")
                 return
             }
            self.uploadImageToFirebase(image: image)
        }
        let laterYayinlaButton = UIAlertAction(title: "Sonra Yayınla", style: .default) { _ in
            self.brodcastOptions = 0
            guard let image = self.sponsorImageView.image else {
                 print("Hata: Activity image boş.")
                 return
             }
            self.uploadImageToFirebase(image: image)
        }
        
        alert.addAction(yayinlaButton)
        alert.addAction(laterYayinlaButton)
        
        self.present(alert, animated: true)
    }
}

//DB
extension NewSponsorAddVC{
    
    func uploadImageToFirebase(image: UIImage) {
        let userIDnumberGenerete = String(format: "%04d", arc4random_uniform(10000))
        if let compressedImageData = compressImage(image, maxFileSizeKB: 200) {
            let storage = Storage.storage()
            let storageReference = storage.reference()
            let mediaFolder = storageReference.child("\(brandTypeTextF.text ?? "Kategori Belirlenemedi")_photos")

            let uuid = UUID().uuidString
            let photoFileName = "\(brandTypeTextF.text ?? "Kategori Belirlenemedi")\(uuid).jpg"
            let photoReference = mediaFolder.child(photoFileName)

            _ = photoReference.putData(compressedImageData, metadata: nil) { (metadata, error) in
                if error != nil {
                    // Hata
                    print("Fotoğraf yüklenirken hata oluştu: \(error!.localizedDescription)")
                    //self.loading.isHidden = true
                    //self.completeButton.isEnabled = true
                } else {
                    // Başarılı
                    let customDocumentName = "\(self.brandTypeTextF.text ?? "Kategori Belirlenemedi")\(uuid)"
                    print("Fotoğraf başarıyla yüklendi.")
                    photoReference.downloadURL { (url, error) in
                        if let downloadURL = url?.absoluteString {
                            let userInfoDict: [String: Any] = [
                                "activityDocumentID":customDocumentName,
                                "brandName": self.brandNameTextF.text ?? "MekanName Alınamadı",
                                "brandType": self.brandTypeTextF.text ?? "activityName not Take",
                                "brandDescription" :self.destinationTextV.text ?? "activityDate not Take",
                                "brandPhoneNumber": self.brandPhoneNumberTextF.text ?? "activityPrice not Take",
                                "brandDiscound": self.brandDiscoundTextF.text ?? "activityDescription not Take",
                                "photoURL": downloadURL,
                                "isActive" : self.brodcastOptions,
                                "etkinlikEklenisTarihi": FieldValue.serverTimestamp(),
                                "brandDate": self.brandDateTextF.text ?? "activityCategory not Take",
                                "priceReceived": self.brandPriceRecTextF.text ?? "brandPriceRecTextF not Take"
                                //"sponsorOFFDate":
                            ]

                            
                            self.db.collection("sponsors").document(customDocumentName).setData(userInfoDict) { error in
                                if error != nil {
                                    self.setupShowAlert(title: "Hata", message: error!.localizedDescription, buttonHeader: "Tekrar dene!")
                                } else {
                                    self.setupShowAlert(title: "Etkinlik Haberi", message: "Başarılı Bir şekilde Yüklendi", buttonHeader: "Tamam")
                                }
                            }
                        }
                    }
                }
            }
        }
    }
    
    
    func compressImage(_ image: UIImage, maxFileSizeKB: Int) -> Data? {
        var compression: CGFloat = 1.0
        let maxCompression: CGFloat = 0.1
        let maxFileSizeBytes = maxFileSizeKB * 1024
        
        while let imageData = image.jpegData(compressionQuality: compression),
              imageData.count > maxFileSizeBytes && compression > maxCompression {
            compression -= 0.1
        }
        
        return image.jpegData(compressionQuality: compression)
    }
    
    
    func setupShowAlert(title:String, message:String, buttonHeader:String){
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let okButton = UIAlertAction(title: buttonHeader, style: .default) { _ in
            self.dismiss(animated: true)
        }
        alert.addAction(okButton)
        self.present(alert, animated: true)
    }
    
    
}


