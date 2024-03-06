//
//  PostManager.swift
//  justkibrisManagement
//
//  Created by Bircan Sezgin on 2/29/24.
//

import Foundation
import Firebase

struct Post: Codable {
    var postID: String
    var userName: String
    var activityName: String
    var activityPlace: String
    var postPhotoURL: String
    var likeCount: Int
    var postSendingDate: Date
    var postingUserImageURL: String
    var isActivePost: Int
    var activityPosterImageURL: String
    var activityID: String
    var activityCategory: String
    var postDocumentID: String
    var postingUserID: String
    var isLikedByCurrentUser: Bool = false
    
    
    
    
    
    init(dictionary: [String: Any]) {
        self.postID = dictionary["postID"] as? String ?? ""
        self.userName = dictionary["userName"] as? String ?? ""
        self.activityName = dictionary["activityName"] as? String ?? ""
        self.activityPlace = dictionary["activityPlace"] as? String ?? ""
        self.postPhotoURL = dictionary["postPhotoURL"] as? String ?? ""
        self.likeCount = dictionary["likeCount"] as? Int ?? 0
        self.postingUserImageURL = dictionary["postingUserImageURL"] as? String ?? ""
        self.isActivePost = dictionary["isActivePost"] as? Int ?? 0
        self.activityPosterImageURL = dictionary["activityPosterImageURL"] as? String ?? ""
        self.activityID = dictionary["activityID"] as? String ?? ""
        self.activityCategory = dictionary["activityCategory"] as? String ?? ""
        self.postDocumentID = dictionary["postDocumentID"] as? String ?? ""
        self.postingUserID = dictionary["postingUserID"] as? String ?? ""
        
        if let timestamp = dictionary["postSendingDate"] as? Timestamp {
            self.postSendingDate = timestamp.dateValue()
        } else {
            self.postSendingDate = Date()
        }
    }
}

class PostManager {
    
    static let shared = PostManager()
    
    private init() {}
    
    func fetchPosts(completion: @escaping ([Post]) -> Void) {
        let oneWeekAgo = Calendar.current.date(byAdding: .day, value: -7, to: Date()) ?? Date()
        let db = Firestore.firestore()
        db.collection("Posts")
            .order(by: "postSendingDate", descending: true)
            .addSnapshotListener { (snapshot, error) in
                if let error = error {
                    print("Error getting documents: \(error)")
                    completion([]) // Return empty array on error
                } else {
                    let posts = snapshot?.documents.compactMap { doc -> Post? in
                        return Post(dictionary: doc.data())
                    } ?? []
                    completion(posts) // Return fetched posts
                }
            }
    }
    
    
    func updatePost(_ post: Post, completion: @escaping (Bool) -> Void) {
        let db = Firestore.firestore()
        let postRef = db.collection("Posts").document(post.postDocumentID)
        
        postRef.updateData(["isActivePost": post.isActivePost]) { error in
            if let error = error {
                print("Error updating document: \(error)")
                completion(false)
            } else {
                print("Document successfully updated")
                completion(true)
            }
        }
    }
    
    
}
