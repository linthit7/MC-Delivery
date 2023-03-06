//
//  Medicine.swift
//  MC Delivery
//
//  Created by Lin Thit Khant on 2/21/23.
//

import SwiftyJSON

struct MedicineResponse {
    
    var statusCode: Int!
    var total: Int!
    var payload: [Medicine]!
    
    static func loadMedicineResponse(json: JSON) -> MedicineResponse {
        
        var medicineResponse = MedicineResponse()
        medicineResponse.statusCode = json["statusCode"].intValue
        medicineResponse.total = json["total"].intValue
        return medicineResponse
    }
}

struct Medicine {
    
    var _id: String!
    var name: String!
    var details: String!
    var companyName: String!
    var expiredDate: String!
    var price: Int!
    var stocks: Int!
    var categoryId: String!
    var pictureUrls: [JSON]!
    var orderCount: Int!
    var avgRating: Int!
    var categoryDetail: CategoryDetail!
    
    static func loadMedicine(json: JSON) -> Medicine {
        
        var medicine = Medicine()
        medicine._id = json["_id"].stringValue
        medicine.name = json["name"].stringValue
        medicine.details = json["details"].stringValue
        medicine.companyName = json["companyName"].stringValue
        medicine.expiredDate = json["expiredDate"].stringValue
        medicine.price = json["price"].intValue
        medicine.stocks = json["stocks"].intValue
        medicine.categoryId = json["categoryId"].stringValue
        medicine.pictureUrls = json["pictureUrls"].arrayValue
        medicine.orderCount = json["orderCount"].intValue
        medicine.avgRating = json["avgRating"].intValue
        medicine.categoryDetail = CategoryDetail.loadCategoryDetail(json: JSON(rawValue: json["categoryDetail"].dictionaryValue)!)
        return medicine
    }
    
    static func loadMedicineArray(jsonArray: [JSON]) -> [Medicine] {
        
        var medicineArray: [Medicine] = []
        for json in jsonArray {
            let medicine = Medicine.loadMedicine(json: json)
            medicineArray.append(medicine)
        }
        return medicineArray
    }
}

struct CategoryDetail {
    
    var id: String!
    var title: String!
    var pictureUrls: [JSON]!
    
    static func loadCategoryDetail(json: JSON) -> CategoryDetail {
        
        var categoryDetail = CategoryDetail()
        categoryDetail.id = json["id"].stringValue
        categoryDetail.title = json["title"].stringValue
        categoryDetail.pictureUrls = json["pictureUrls"].arrayValue
        return categoryDetail
    }
}
