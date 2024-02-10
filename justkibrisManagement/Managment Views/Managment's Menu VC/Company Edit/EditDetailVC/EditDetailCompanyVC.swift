

import UIKit
import SDWebImage
import Firebase
import FirebaseFirestore

class EditDetailCompanyVC: UIViewController {
    
    @IBOutlet weak var imageBackView: UIView!
    @IBOutlet weak var activityImageView: UIImageView!
    
    @IBOutlet weak var scrollView: UIScrollView!
    
    @IBOutlet weak var activityManagerView: UIView!
    @IBOutlet weak var activityOnlineButton: UIButton!
    @IBOutlet weak var activityOfflineButton: UIButton!
    
    
    @IBOutlet weak var activityQFirstView: UIView!
    @IBOutlet weak var activityPlaceTextF: UITextField!
    @IBOutlet weak var activityNameTextF: UITextField!
    
    @IBOutlet weak var activityQSecondView: UIView!
    @IBOutlet weak var activityDateTextF: UITextField!
    @IBOutlet weak var activityPriceTextF: UITextField!
    
    @IBOutlet weak var activityQThirtView: UIView!
    @IBOutlet weak var activityDesTextF: UITextView!
    @IBOutlet weak var activityCategoryTextF: UITextField!
    
    @IBOutlet weak var activityQFourView: UIView!
    @IBOutlet weak var activityPhoneTextF: UITextField!
    
    
    @IBOutlet weak var activityQFiveView: UIView!
    @IBOutlet weak var activityFinishDateTextF: UITextField!
    
    @IBOutlet weak var activityContentMangerView: UIView!
    @IBOutlet weak var activityInfoUpdateButton: UIButton!
    @IBOutlet weak var backButton: UIButton!
    
    
    
    @IBOutlet weak var loading: UIActivityIndicatorView!
    
    
    var incomingActivity: Etkinlik?
    let db = Firestore.firestore()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupContent()
        setupButton()
        setupcloseKeyBoard()
        
    }
    
    
    
    
}



//MARK: - UI
extension EditDetailCompanyVC{
    private func setupUI(){
        imageBackView.layer.cornerRadius = 20
        imageBackView.layer.masksToBounds = true
        
        activityManagerView.layer.cornerRadius = 20
        activityManagerView.layer.masksToBounds = true
        
        activityQFirstView.layer.cornerRadius = 20
        activityQFirstView.layer.masksToBounds = true
        
        activityQSecondView.layer.cornerRadius = 20
        activityQSecondView.layer.masksToBounds = true
        
        activityQThirtView.layer.cornerRadius = 20
        activityQThirtView.layer.masksToBounds = true
        
        activityContentMangerView.layer.cornerRadius = 20
        activityContentMangerView.layer.masksToBounds = true
        
        activityQFourView.layer.cornerRadius = 20
        activityQFourView.layer.masksToBounds = true
        
        //Photo Radius
        activityImageView.layer.cornerRadius = 20
        activityImageView.layer.masksToBounds = true
        
        activityDesTextF.layer.cornerRadius = 20
        activityDesTextF.layer.masksToBounds = true
        
        
        loading.isHidden = true
    }
    
    // Close Keyboard
    func setupcloseKeyBoard(){
        let tap = UITapGestureRecognizer(target: self, action: #selector(close_keyboard))
        view.addGestureRecognizer(tap)
    }
    
    @objc func close_keyboard(){
        view.endEditing(true)
    }
}

//MARK: - Button!
extension EditDetailCompanyVC{
    private func setupButton(){
        activityInfoUpdateButton.addTarget(self, action: #selector(setUpdateContent), for: .touchUpInside)
        activityOnlineButton.addTarget(self, action: #selector(setOnlineClick), for: .touchUpInside)
        activityOfflineButton.addTarget(self, action: #selector(setOfflineClick), for: .touchUpInside)
        backButton.addTarget(self, action: #selector(backClick), for: .touchUpInside)
    }
    
    @objc func setOnlineClick(){
        if var activite = incomingActivity {
            updateForActivity(activity: &activite, isActive: 1)
        }
    }
    
    @objc func setOfflineClick(){
        if var activite = incomingActivity {
            updateForActivity(activity: &activite, isActive: 0)
        }
    }
    
    @objc func setUpdateContent(){
        if var activite = incomingActivity {
            updateContent(activity: &activite)
        }
    }
    
    @objc func backClick(){
        tapticEngine()
        dismiss(animated: true)
    }
}


//MARK: - Setup Content
extension EditDetailCompanyVC{
    private func setupContent(){
        if let incomingActivity = incomingActivity{
            activityImageView.sd_setImage(with: URL(string: incomingActivity.photoURLArray))
            activityPlaceTextF.text = incomingActivity.mekanName
            activityNameTextF.text = incomingActivity.activityName
            activityDateTextF.text = incomingActivity.activityDate
            activityPriceTextF.text = incomingActivity.activityPrice
            activityDesTextF.text = incomingActivity.activityDescription
            activityCategoryTextF.text = incomingActivity.activityCategory
            activityPhoneTextF.text = incomingActivity.activityPhoneNumber
            
            // Button Settings
            switch incomingActivity.isActive {
            case 1:
                setButtonState(isOnline: true)
            case 0:
                setButtonState(isOnline: false)
            default:
                break
            }
        }
    }
    
    
    
    func tapticEngine(){
        let feedbackGenerator = UIImpactFeedbackGenerator(style: .heavy)
        feedbackGenerator.prepare()
        feedbackGenerator.impactOccurred()
        
    }
}


extension EditDetailCompanyVC{
    private func updateContent(activity: inout Etkinlik) {
        prepareForUpdate()
        self.tapticEngine()
        
        let activitiesCollection = Firestore.firestore().collection("etkinlikler")
        let activityDocRef = activitiesCollection.document(activity.activityDocumentID)
        
        activityDocRef.updateData([
            "activityCategory": self.activityCategoryTextF.text ?? "",
            "activityDate": self.activityDateTextF.text ?? "",
            "activityDescription": self.activityDesTextF.text ?? "",
            "activityName": self.activityNameTextF.text ?? "",
            "activityPrice": self.activityPriceTextF.text ?? "",
            "mekanName": self.activityPlaceTextF.text ?? "",
            "activityPhoneNumber" : self.activityPhoneTextF.text ?? ""
        ]) { error in
            if let error = error {
                print("Hata: \(error.localizedDescription)")
            } else {
                self.finishUpdate()
            }
        }
    }
    
}


//MARK: - Online Activite - Offline!
extension EditDetailCompanyVC{
    private func updateForActivity(activity: inout Etkinlik, isActive: Int){
        prepareForUpdate()
        self.tapticEngine()
        let activitiesCollection = Firestore.firestore().collection("etkinlikler")
        let activityDocRef = activitiesCollection.document(activity.activityDocumentID)
        activityDocRef.updateData(["isActive": isActive]) { error in
            if let error = error {
                print("Hata: \(error.localizedDescription)")
            } else {
                self.updateUIForActivity(isActive: isActive)
                self.finishUpdate()
            }
        }
    }
    
    
    private func updateUIForActivity(isActive: Int) {
        self.tapticEngine()
        setupButtonState(for: isActive)
    }
    
    private func setupButtonState(for isActive: Int) {
        switch isActive {
        case 1:
            setButtonState(isOnline: true)
        case 0:
            setButtonState(isOnline: false)
        default:
            break
        }
    }
    
    private func setButtonState(isOnline: Bool) {
        if isOnline {
            activityOnlineButton.isEnabled = false
            activityOfflineButton.isEnabled = true
        } else {
            activityOnlineButton.isEnabled = true
            activityOfflineButton.isEnabled = false
        }
    }
    
    
    private func prepareForUpdate() {
        loading.startAnimating()
        loading.isHidden = false
    }
    
    private func finishUpdate() {
        loading.stopAnimating()
        loading.isHidden = true
        self.showAlert(title: "Durum", Message: "Bilgi Güncelleme, Başarılı!", buttonTitle: "Kapat")
    }
    
    func showAlert(title : String, Message: String, buttonTitle:String){
        let alert = UIAlertController(title: title, message: Message, preferredStyle: .alert)
        let okButton = UIAlertAction(title: buttonTitle, style: .cancel)
        alert.addAction(okButton)
        self.present(alert, animated: true)
    }
    
    
    
}
