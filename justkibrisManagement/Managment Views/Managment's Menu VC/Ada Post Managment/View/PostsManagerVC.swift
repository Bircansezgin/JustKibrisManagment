//
//  PostsManagerVC.swift
//  justkibrisManagement
//
//  Created by Bircan Sezgin on 2/29/24.
//

import UIKit
import SDWebImage

class PostsManagerVC: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var segmentControll: UISegmentedControl!
    
    var commonPost = [Post]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        setupTableViewDelgete()
        fetchPostsForSegmentControl(isActive: 2)
        
    }

    @IBAction func segmentActions(_ sender: Any) {
        switch (sender as AnyObject).selectedSegmentIndex {
           case 0:
               fetchPostsForSegmentControl(isActive: 2)
           case 1:
               fetchPostsForSegmentControl(isActive: 0)
           case 2:
               fetchPostsForSegmentControl(isActive: 1)
           default:
               break
           }
    }
    
    
    

}

//MARK: - SETUP
extension PostsManagerVC{
    private func setupView(){
        
    }
}

//MARK: - TABLEVEW DELEGETE
extension PostsManagerVC: UITableViewDelegate, UITableViewDataSource{
    
    
    private func setupTableViewDelgete(){
        tableView.delegate = self
        tableView.dataSource = self
        
        let nib = UINib(nibName: "PostsCell", bundle: nil)
        tableView.register(nib, forCellReuseIdentifier: "PostsCell")
    
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return commonPost.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let pots = commonPost[indexPath.row]
        if let cell = tableView.dequeueReusableCell(withIdentifier: "PostsCell", for: indexPath) as? PostsCell{
            
            cell.postImageCEll.sd_setImage(with: URL(string: pots.postPhotoURL))
            cell.postImageCEll.layer.cornerRadius = 15
            cell.postImageCEll.layer.masksToBounds = true
            
            cell.postOwnerLabel.text = pots.userName
            
            return cell
        }
        
        return UITableViewCell()
    }

    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 85.0
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        var selectedPost = commonPost[indexPath.row]
        let goToDetail = PostDetailVC()
        goToDetail.sendingPost = selectedPost
        goToDetail.modalPresentationStyle = .fullScreen
        self.present(goToDetail, animated: true)
    }
    
}

// MARK: - Setup FetchData
extension PostsManagerVC{
    private func fetchPostsForSegmentControl(isActive: Int) {
        PostManager.shared.fetchPosts { [weak self] posts in
            let filteredPosts = posts.filter { $0.isActivePost == isActive }
            self?.commonPost = filteredPosts
            self?.tableView.reloadData()
        }
    }
}
