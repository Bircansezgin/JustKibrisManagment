
import UIKit
import Firebase
import SDWebImage
import FirebaseFirestore

class CompanyEditVC: UIViewController {
    
    @IBOutlet weak var userView: UIView!
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var segmentControll: UISegmentedControl!
    @IBOutlet weak var exitImage: UIImageView!
    @IBOutlet weak var loading: UIActivityIndicatorView!
    @IBOutlet weak var statusLabel: UILabel!
    
    var allActivities: [Etkinlik] = []
    var yayindaOlmayanEtkinlikler: [Etkinlik] = []
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        DispatchQueue.main.async {
            self.fetchAllActivitys()
            self.setupUI()
        }

    
        
        // FUNC
        tableView.delegate = self
        tableView.dataSource = self
        tableView.layer.cornerRadius = 20
        tableView.layer.masksToBounds = true
        
        let nib = UINib(nibName: "CompanyTCell", bundle: nil)
        tableView.register(nib, forCellReuseIdentifier: "CompanyTCell")
     
        
       
    }
    
    
    @IBAction func segmentControlls(_ sender: UISegmentedControl) {
        switch sender.selectedSegmentIndex {
           case 0:
            self.tableView.reloadData()
           case 1:
            self.tableView.reloadData()
           default:
               break
           }
        
        self.tableView.reloadData()
    }

   
}//






//MARK: - SETUP UI
extension CompanyEditVC{
    private func setupUI(){
        loadingStatus(status: true)
        userView.layer.cornerRadius = 20
        userView.layer.masksToBounds = true
        
        exitImage.isUserInteractionEnabled = true
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(backExit))
        exitImage.addGestureRecognizer(tapGesture)
    }
    
    
    @objc func backExit(){
        self.dismiss(animated: true)
    }
    
    
    func tapticEngine(){
        let feedbackGenerator = UIImpactFeedbackGenerator(style: .heavy)
        feedbackGenerator.prepare()
        feedbackGenerator.impactOccurred()
        
    }
    
}

extension CompanyEditVC{
    private func loadingStatus(status: Bool){
        if status{
            self.loading.startAnimating()
            self.loading.isHidden = false
        }else{
            self.loading.stopAnimating()
            self.loading.isHidden = true
        }
    }
}

//MARK: - TableView
extension CompanyEditVC: UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        switch segmentControll.selectedSegmentIndex {
        case 0:
            return allActivities.count
        case 1:
            return yayindaOlmayanEtkinlikler.count
        default:
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CompanyTCell", for: indexPath) as! CompanyTCell
        
        var gelenEtkinlik: Etkinlik
        
        switch segmentControll.selectedSegmentIndex {
        case 0:
            gelenEtkinlik = allActivities[indexPath.row]
        case 1:
            gelenEtkinlik = yayindaOlmayanEtkinlikler[indexPath.row]
        default:
            print("Beklenmedik CASE")
            return cell
        }
        
        cell.activityImageView.layer.cornerRadius = 15
        cell.activityImageView.layer.masksToBounds = true
        
        cell.activityImageView.sd_setImage(with: URL(string: gelenEtkinlik.photoURLArray))
        
        cell.activityNameLabel.text = gelenEtkinlik.activityName
        cell.activityDateLabel.text = gelenEtkinlik.activityDate
        cell.activityPriceLabel.text = gelenEtkinlik.activityPrice
        cell.mekanOwnerLabel.text = gelenEtkinlik.mekanName
        
        if gelenEtkinlik.isActive == 1 {
               let attributedString = NSMutableAttributedString(string: "Durum : Aktif")
            attributedString.addAttribute(NSAttributedString.Key.foregroundColor, value: UIColor.systemGreen, range: NSRange(location: 8, length: 5))
               cell.durumLabel.attributedText = attributedString
             
           } else {
               let attributedString = NSMutableAttributedString(string: "Durum : Pasif")
               attributedString.addAttribute(NSAttributedString.Key.foregroundColor, value: UIColor.systemRed, range: NSRange(location: 8, length: 5))
               cell.durumLabel.attributedText = attributedString
              
           }
        
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        var selectedActivity: Etkinlik?
        
        switch segmentControll.selectedSegmentIndex {
        case 0:
            selectedActivity = allActivities[indexPath.row]
        case 1:
            selectedActivity = yayindaOlmayanEtkinlikler[indexPath.row]
        default:
            break
        }
        
        if let selectedActivity = selectedActivity {
            
          let editDetailCompany = EditDetailCompanyVC()
            editDetailCompany.incomingActivity = selectedActivity
            editDetailCompany.modalPresentationStyle = .fullScreen // veya .pageSheet
            editDetailCompany.modalTransitionStyle = .coverVertical
            present(editDetailCompany, animated: true, completion: nil)
        }
    }
    

    
    
}

//MARK: - DB
extension CompanyEditVC{
    private func fetchAllActivitys() {
        let database = Firestore.firestore()
        let ilanlarCollection = database.collection("etkinlikler")
        
        ilanlarCollection.addSnapshotListener { (snapshot, error) in
            if let error = error {
                print("Hata oluştu: \(error.localizedDescription)")
                self.loadingStatus(status: false)
            } else {
                if let documents = snapshot?.documents {
                    self.allActivities.removeAll(keepingCapacity: false)
                    self.yayindaOlmayanEtkinlikler.removeAll(keepingCapacity: false)
                    
                    for document in documents {
                        if let docData = document.data() as? [String: Any] {
                            if let ilanBilgileri = self.createIlanBilgileri(from: docData) {
                                
                                switch ilanBilgileri.isActive{
                                case 0:
                                    self.yayindaOlmayanEtkinlikler.append(ilanBilgileri)
                                    self.tableView.reloadData()
                                case 1:
                                    self.allActivities.append(ilanBilgileri)
                                    self.tableView.reloadData()
                                default:
                                    fatalError("Beklenmeyen segment index")
                                }
                                
                            }
                        }
                    }
                    
                    
                    
                    if self.yayindaOlmayanEtkinlikler.count >= 0{
                        self.statusLabel.isHidden = true
                    }else if self.allActivities.count >= 0 {
                        self.statusLabel.isHidden = true
                    }else{
                        self.statusLabel.isHidden = false

                    }
                    
                    self.tableView.reloadData()
                    self.tapticEngine()
                    self.loadingStatus(status: false)
                } else {
                    print("Hiç doküman bulunamadı.")
                }
            }
        }
    }
    
    
    func createIlanBilgileri(from docData: [String: Any]) -> Etkinlik? {
        
        guard
            let activityDate = docData["activityDate"] as? String else {
            print("activityDate değeri nil veya uyumsuz: \(String(describing: docData["activityDate"]))")
            return nil
        }
        
        guard
            let activityDescription = docData["activityDescription"] as? String else {
            print("activityDescription değeri nil veya uyumsuz: \(String(describing: docData["activityDescription"]))")
            return nil
        }
        
        guard
            let activityName = docData["activityName"] as? String else {
            print("activityName değeri nil veya uyumsuz: \(String(describing: docData["activityName"]))")
            return nil
        }
        
        guard
            let activityPrice = docData["activityPrice"] as? String else {
            print("evBanyoSayisi değeri nil veya uyumsuz: \(String(describing: docData["activityPrice"]))")
            return nil
        }
        
        guard
            let etkinlikEklenisTarihi = docData["etkinlikEklenisTarihi"] as? Timestamp else {
            print("etkinlikEklenisTarihi değeri nil veya uyumsuz: \(String(describing: docData["etkinlikEklenisTarihi"]))")
            return nil
        }
        
        guard
            let isActive = docData["isActive"] as? Int else {
            print("isActive değeri nil veya uyumsuz: \(String(describing: docData["isActive"]))")
            return nil
        }
        
        guard
            let mekanName = docData["mekanName"] as? String else {
            print("mekanName değeri nil veya uyumsuz: \(String(describing: docData["mekanName"]))")
            return nil
        }
        
        guard
            let photoURL = docData["photoURL"] as? String else {
            print("photoURL değeri nil veya uyumsuz: \(String(describing: docData["photoURL"]))")
            return nil
        }
        
        guard
            let activityDocumentID = docData["activityDocumentID"] as? String else {
            print("activityDocumentID değeri nil veya uyumsuz: \(String(describing: docData["activityDocumentID"]))")
            return nil
        }
        
        guard
            let activityCategory = docData["activityCategory"] as? String else {
            print("activityCategory değeri nil veya uyumsuz: \(String(describing: docData["activityCategory"]))")
            return nil
        }
        
        guard
            let activityPhoneNumber = docData["activityPhoneNumber"] as? String else {
            print("activityPhoneNumber değeri nil veya uyumsuz: \(String(describing: docData["activityPhoneNumber"]))")
            return nil
        }
        
        guard
            let activityBarCodeNo = docData["activityBarCodeNo"] as? String else {
            print("activityPhoneNumber değeri nil veya uyumsuz: \(String(describing: docData["activityBarCodeNo"]))")
            return nil
        }
        
        guard
            let reservationOn = docData["reservationOn"] as? String else {
            print("reservationOn değeri nil veya uyumsuz: \(String(describing: docData["reservationOn"]))")
            return nil
        }
        
        guard
            let xCoordinate = docData["xCoordinate"] as? Double else {
            print("xCoordinate değeri nil veya uyumsuz: \(String(describing: docData["xCoordinate"]))")
            return nil
        }
        
        guard
            let yCoordinate = docData["yCoordinate"] as? Double else {
            print("yCoordinate değeri nil veya uyumsuz: \(String(describing: docData["yCoordinate"]))")
            return nil
        }
        
        
        
        
        let etkinlikler = Etkinlik(
            mekanName: mekanName,
            activityName: activityName,
            activityDate: activityDate,
            activityPrice: activityPrice,
            activityDescription: activityDescription,
            photoURLArray: photoURL,
            isActive: isActive,
            etkinlikEklenisTarihi: etkinlikEklenisTarihi.dateValue(),
            activityCategory: activityCategory,
            activityDocumentID: activityDocumentID,
            activityPhoneNumber: activityPhoneNumber,
            activityBarCodeNo: activityBarCodeNo,
            reservationOn: reservationOn,
            xCoordinate: xCoordinate,
            yCoordinate: yCoordinate
            
        )
        
        
        
        
        
        return etkinlikler
    }
    
}
