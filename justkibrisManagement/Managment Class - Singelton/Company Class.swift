//
//  CompanyAcivity.swift
//  justkibrisManagement
//
//  Created by Bircan Sezgin on 09-02-24.
//

import Foundation

struct Etkinlik:Codable {
    var mekanName: String
    var activityName: String
    var activityDate: String
    var activityPrice: String
    var activityDescription: String
    var photoURLArray: String
    var isActive: Int
    var etkinlikEklenisTarihi: Date
    var activityCategory : String
    var activityDocumentID : String
    var activityPhoneNumber: String
    var activityBarCodeNo: String
    var reservationOn: String
    
    var xCoordinate: Double
    var yCoordinate: Double
}



struct Sponsor: Codable{
    var activityDocumentID: String
    var brandName: String
    var brandType: String
    var brandDescription: String
    var brandPhoneNumber: String
    var photoURLArray: String
    var isActive: Int
    var etkinlikEklenisTarihi: Date
    var brandDiscound: String
    var brandDate : String
    var priceReceived: String
}
