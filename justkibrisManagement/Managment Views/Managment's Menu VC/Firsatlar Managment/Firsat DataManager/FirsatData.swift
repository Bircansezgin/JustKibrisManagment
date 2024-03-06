//
//  FirsatData.swift
//  justkibrisManagement
//
//  Created by Bircan Sezgin on 3/1/24.
//

import Foundation

struct Firsatlar:Codable {
    var firsatBasligi: String
    var firsatAciklamasi: String
    var firsatSonTarih: String
    var firsatEskiTutar: Int
    var firsatYeniTutar: Int
    var firsatSistemKapanisTarih: Date
    var firsatKullanimSayisi: Int
    var firsatEklenmeTarihi:Date
    var imageUrl: String
    var documentID:String
    var isActive: Int
    
    var firsatSistemiDurumu: Bool {
            return firsatSistemKapanisTarih > Date()  // Örnek bir kontrol, gerçek kontrolü kendinize göre uyarlayabilirsiniz
    }
}
