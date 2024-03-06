

import UIKit
import Firebase
import FirebaseStorage
import PhotosUI
import FirebaseFirestore


class NewCompanyAddVC: UIViewController, PHPickerViewControllerDelegate, UIImagePickerControllerDelegate & UINavigationControllerDelegate {
   

    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var activityImageView: UIImageView!
    @IBOutlet weak var firstQView: UIView!
    @IBOutlet weak var secondQvView: UIView!
    @IBOutlet weak var thirtQView: UIView!
    @IBOutlet weak var fourQView: UIView!
    @IBOutlet weak var fiveQView: UIView!
    @IBOutlet weak var sixQView: UIView!
    @IBOutlet weak var sevenQView: UIView!
    
    @IBOutlet weak var uploadActivityButton: UIButton!
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var backButton2: UIButton!
    
    
    //TEXTFIELDS
    @IBOutlet weak var mekanName: UITextField!
    @IBOutlet weak var activityName: UITextField!
    @IBOutlet weak var activityDate: UITextField!
    @IBOutlet weak var activityPrice: UITextField!
    @IBOutlet weak var activityDescription: UITextView!
    @IBOutlet weak var activityPhone: UITextField!
    @IBOutlet weak var activityOFFTimeTextF: UITextField!
    @IBOutlet weak var reservationOnTextF: UITextField!
    @IBOutlet weak var xKordinatTextF: UITextField!
    @IBOutlet weak var yKordinatTextF: UITextField!
    
    @IBOutlet weak var kategoriTextField: UITextField!
    
    let datePicker = UIDatePicker()
    let datePickerActivity = UIDatePicker()



    //Etkinlik Kategorileri!
    let etkinlikKategorileriData = ["Night Club", "Bar", "Konser", "Party","Meyhane", "Cafe", "Restoran", "Esnaf-Gündelik", "Yurt"]
    let reservasyonOnData = ["Açık", "Kapalı"]
    
    
    let etkinlikKategoriPickerView = UIPickerView()
    let reservasyonOnPickerView = UIPickerView()
    
    let db = Firestore.firestore()
    var brodcastOptions = Int()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupButton()
        setup_gestureReco()
        setup_textField_Delegete()
        setup_PickerView_Button()
        setup_close_KeyBoard()
        setupDatePicker()
    }
    

//    func textFieldDidBeginEditing(_ textField: UITextField) {
//        let scrollPoint = CGPoint(x: 0, y: textField.frame.origin.y - 300)
//        scrollView.setContentOffset(scrollPoint, animated: true)
//    }
//
//    func textFieldDidEndEditing(_ textField: UITextField) {
//        scrollView.setContentOffset(CGPoint.zero, animated: true)
//    }
}

//MARK : - SETUP UI
extension NewCompanyAddVC{
    private func setupUI(){
        firstQView.layer.cornerRadius = 20
        firstQView.layer.masksToBounds = true
        
        secondQvView.layer.cornerRadius = 20
        secondQvView.layer.masksToBounds = true
        
        thirtQView.layer.cornerRadius = 20
        thirtQView.layer.masksToBounds = true
        
        fourQView.layer.cornerRadius = 20
        fourQView.layer.masksToBounds = true
        
        fiveQView.layer.cornerRadius = 20
        fiveQView.layer.masksToBounds = true
        
        sixQView.layer.cornerRadius = 20
        sixQView.layer.masksToBounds = true
        
        sevenQView.layer.cornerRadius = 20
        sevenQView.layer.masksToBounds = true
        
        activityDescription.layer.cornerRadius = 10
        activityDescription.layer.masksToBounds = true
    }
    
    private func setup_gestureReco(){
        activityImageView.isUserInteractionEnabled = true
        let gestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(choosePictures))
        activityImageView.addGestureRecognizer(gestureRecognizer)
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        view.addGestureRecognizer(tapGesture)
        
    }
    func generateRandomCode() -> String {
        let characters = "ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
        
        var code = ""
        
        for _ in 0..<6 {
            let randomIndex = Int(arc4random_uniform(UInt32(characters.count)))
            let randomCharacter = characters[characters.index(characters.startIndex, offsetBy: randomIndex)]
            code.append(randomCharacter)
        }
        
        return code
    }
}

//MARK : - SETUP BUTTON SETTINGS
extension NewCompanyAddVC{
    private func setupButton(){
        uploadActivityButton.addTarget(self, action: #selector(uploadActivity), for: .touchUpInside)
        backButton.addTarget(self, action: #selector(backClick), for: .touchUpInside)
        
        backButton2.addTarget(self, action: #selector(backClick), for: .touchUpInside)
    }
    
    @objc func uploadActivity(){
        // Tüm text field'larınızı ve text view'ınızı kontrol edin
        guard let mekanNameText = mekanName.text, !mekanNameText.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty,
              let activityNameText = activityName.text, !activityNameText.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty,
              let activityDateText = activityDate.text, !activityDateText.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty,
              let activityPriceText = activityPrice.text, !activityPriceText.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty,
              let activityPhoneText = activityPhone.text, !activityPhoneText.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty,
              let activityOFFTimeText = activityOFFTimeTextF.text, !activityOFFTimeText.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty,
              let reservationOnText = reservationOnTextF.text, !reservationOnText.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty,
              let xKordinatText = xKordinatTextF.text, !xKordinatText.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty,
              let yKordinatText = yKordinatTextF.text, !yKordinatText.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty,
              let kategoriText = kategoriTextField.text, !kategoriText.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty,
              !activityDescription.text.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty else {
            // Eğer herhangi bir alan boş ise, bir uyarı mesajı göster
            let alert = UIAlertController(title: "Hata", message: "Lütfen tüm alanları doldurunuz.", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Tamam", style: .default, handler: nil))
            self.present(alert, animated: true, completion: nil)
            return
        }
        
        // Eğer tüm alanlar doluysa, diğer işlemlerinizi burada yapın
        self.sendActivityAlert(title: "Yayın Seçenekleri", message: "Yayın Zamanını Seçiniz")
    }

    
    @objc func backClick(){
        self.dismiss(animated: true)
    }
}




// MARK: - Photo Select
extension NewCompanyAddVC{
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
    
    @objc func choosePictures() {
        tapticEngine()
        
        let vc = UIImagePickerController()
        vc.sourceType = .photoLibrary
        vc.delegate = self
        vc.allowsEditing = true
        present(vc, animated: true)
        
//        var configuration = PHPickerConfiguration()
//        configuration.selectionLimit = 1
//        let picker = PHPickerViewController(configuration: configuration)
//        picker.delegate = self
//        picker.editButtonItem.creatingFixedGroup()
//        present(picker, animated: true)
    }
    
    
    private func setupDatePicker() {
        datePicker.datePickerMode = .dateAndTime
        datePicker.addTarget(self, action: #selector(datePickerValueChangedActivity(_:)), for: .valueChanged)
        datePicker.preferredDatePickerStyle = .compact
        activityDate.inputView = datePicker
        
        datePickerActivity.datePickerMode = .dateAndTime
        datePickerActivity.addTarget(self, action: #selector(datePickerValueChanged(_:)), for: .valueChanged)
        datePickerActivity.preferredDatePickerStyle = .compact
        activityOFFTimeTextF.inputView = datePickerActivity
    }
    
    @objc func datePickerValueChanged(_ sender: UIDatePicker) {
          let dateFormatter = DateFormatter()
          dateFormatter.dateFormat = "yyyy-MM-dd HH:mm"
          activityOFFTimeTextF.text = dateFormatter.string(from: sender.date)
      }
    
    @objc func datePickerValueChangedActivity(_ sender: UIDatePicker) {
          let dateFormatter = DateFormatter()
          dateFormatter.dateFormat = "yyyy-MM-dd HH:mm"
          activityDate.text = dateFormatter.string(from: sender.date)
      }

    
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        if let image = info[UIImagePickerController.InfoKey(rawValue: "UIImagePickerControllerEditedImage")] as? UIImage{
            activityImageView.contentMode = .scaleAspectFill
            activityImageView.layer.cornerRadius = 20
            activityImageView.layer.masksToBounds = true
            activityImageView.image = image
        }
        
        picker.dismiss(animated: true)
    }
    
    func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
        
    }
    
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true)
    }

    
    
    // Alert
    func setupShowAlert(title:String, message:String, buttonHeader:String){
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let okButton = UIAlertAction(title: buttonHeader, style: .default) { _ in
            //self.dismiss(animated: true)
        }
        alert.addAction(okButton)
        self.present(alert, animated: true)
    }
    
    
    //Taptic Engine
    func tapticEngine(){
        let feedbackGenerator = UIImpactFeedbackGenerator(style: .heavy)
        feedbackGenerator.prepare()
        feedbackGenerator.impactOccurred()
        
    }
     
}


//MARK: - PICKERVIEW
extension NewCompanyAddVC: UITextFieldDelegate, UITextViewDelegate, UIPickerViewDelegate, UIPickerViewDataSource{
    func setup_textField_Delegete(){
        mekanName.delegate = self
        activityDate.delegate = self
        activityName.delegate = self
        activityPrice.delegate = self
        activityDescription.delegate = self
        kategoriTextField.delegate = self
        reservationOnTextF.delegate = self
        
        kategoriTextField.inputView = etkinlikKategoriPickerView
        reservationOnTextF.inputView = reservasyonOnPickerView
        
        setup_PickerView_Delegete()
    }
    
    
    func setup_PickerView_Delegete(){
        // Delegete
        etkinlikKategoriPickerView.delegate = self
        etkinlikKategoriPickerView.dataSource = self
        
        reservasyonOnPickerView.delegate = self
        reservasyonOnPickerView.dataSource = self
    }
    
    
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        switch pickerView {
        case etkinlikKategoriPickerView:
            return etkinlikKategorileriData.count
        case reservasyonOnPickerView:
            return reservasyonOnData.count
        default:
            return 0
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        switch pickerView {
        case etkinlikKategoriPickerView:
            return etkinlikKategorileriData[row]
        case reservasyonOnPickerView:
            return reservasyonOnData[row]
        default:
            return nil
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        switch pickerView {
        case etkinlikKategoriPickerView:
            return kategoriTextField.text = etkinlikKategorileriData[row]
        case reservasyonOnPickerView:
            return reservationOnTextF.text = reservasyonOnData[row]
        default:
            break
        }
    }
    
    
    func setup_PickerView_Button(){
        let toolbar = UIToolbar(frame: CGRect(x: 0, y: 0, width: view.frame.size.width, height: 44))
       
        let button = UILabel()
        button.text = "Tamam"
        button.textColor = UIColor.red
        button.font = UIFont.boldSystemFont(ofSize: 16)
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(labelTapped))
        button.isUserInteractionEnabled = true
        button.addGestureRecognizer(tapGesture)
        
        let labelButton = UIBarButtonItem(customView: button)
        let flexibleSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
    
        toolbar.setItems([labelButton, flexibleSpace], animated: true)

        kategoriTextField.inputAccessoryView = toolbar
        reservationOnTextF.inputAccessoryView = toolbar

    }
    
    @objc func labelTapped() {
        kategoriTextField.resignFirstResponder()
        reservationOnTextF.resignFirstResponder()
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

//MARK: - DB
extension NewCompanyAddVC{
    
    func uploadImageToFirebase(image: UIImage) {
        let generatedCode = generateRandomCode()
        let userIDnumberGenerete = String(format: "%04d", arc4random_uniform(10000))
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm"
        
        if let compressedImageData = compressImage(image, maxFileSizeKB: 200),
           let activityOffDateString = activityOFFTimeTextF.text,
           let activityOffDate = dateFormatter.date(from: activityOffDateString) {
            
            let activityOffTimestamp = Timestamp(date: activityOffDate)
            let storage = Storage.storage()
            let storageReference = storage.reference()
            let mediaFolder = storageReference.child("\(kategoriTextField.text ?? "Kategori Belirlenemedi")_photos")

            let uuid = UUID().uuidString
            let photoFileName = "\(kategoriTextField.text ?? "Kategori Belirlenemedi")\(uuid).jpg"
            let photoReference = mediaFolder.child(photoFileName)
            
            let xCoordinate = Double(self.xKordinatTextF.text ?? "") ?? 0.0
            let yCoordinate = Double(self.yKordinatTextF.text ?? "") ?? 0.0

            _ = photoReference.putData(compressedImageData, metadata: nil) { (metadata, error) in
                if error != nil {
                    print("Fotoğraf yüklenirken hata oluştu: \(error!.localizedDescription)")
                } else {
                    let customDocumentName = "\(self.kategoriTextField.text ?? "Kategori Belirlenemedi")\(uuid)"
                    photoReference.downloadURL { (url, error) in
                        if let downloadURL = url?.absoluteString {
                            let userInfoDict: [String: Any] = [
                                "activityDocumentID": customDocumentName,
                                "mekanName": self.mekanName.text ?? "MekanName Alınamadı",
                                "activityName": self.activityName.text ?? "activityName not Take",
                                "activityDate": self.activityDate.text ?? "activityDate not Take",
                                "activityPrice": self.activityPrice.text ?? "activityPrice not Take",
                                "activityDescription": self.activityDescription.text ?? "activityDescription not Take",
                                "photoURL": downloadURL,
                                "isActive": self.brodcastOptions,
                                "etkinlikEklenisTarihi": FieldValue.serverTimestamp(),
                                "activityCategory": self.kategoriTextField.text ?? "activityCategory not Take",
                                "activityPhoneNumber": self.activityPhone.text ?? "activityPhoneNumber no Take",
                                "activityBarCodeNo": generatedCode,
                                "activityOFF": activityOffTimestamp,
                                "reservationOn": self.reservationOnTextF.text ?? "reservationOnTextF not Take",
                                "xCoordinate": xCoordinate,
                                "yCoordinate": yCoordinate
                            ]

                            self.db.collection("etkinlikler").document(customDocumentName).setData(userInfoDict) { error in
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
    
    
    func getLastEventID(completion: @escaping (Int) -> Void) {
        let collectionRef = db.collection("etkinlikler")
        
        collectionRef.order(by: "etkinlikEklenisTarihi", descending: true).limit(to: 1).getDocuments { (querySnapshot, error) in
            if let error = error {
                print("Hata: \(error.localizedDescription)")
                completion(0)
            } else {
                if let document = querySnapshot?.documents.first {
                    if let lastEventID = document.data()["activityID"] as? Int {
                        completion(lastEventID)
                    } else {
                        completion(0)
                    }
                } else {
                    completion(0)
                }
            }
        }
    }
 
}




//MARK: - Alert
extension NewCompanyAddVC{

    private func sendActivityAlert(title:String, message:String){
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let yayinlaButton = UIAlertAction(title: "Şimdi Yayınla", style: .cancel) { _ in
            self.brodcastOptions = 1
            guard let image = self.activityImageView.image else {
                 print("Hata: Activity image boş.")
                 return
             }
            self.uploadImageToFirebase(image: image)
        }
        let laterYayinlaButton = UIAlertAction(title: "Sonra Yayınla", style: .default) { _ in
            self.brodcastOptions = 0
            guard let image = self.activityImageView.image else {
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
