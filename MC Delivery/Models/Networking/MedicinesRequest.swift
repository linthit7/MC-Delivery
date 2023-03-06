//
//  MedicinesRequest.swift
//  MC Delivery
//
//  Created by Lin Thit Khant on 2/21/23.
//

import SwiftyJSON
import Alamofire

struct MedicineRequest {
    
    static func getMedicineById(medicineId: String, completion: @escaping (Medicine) -> Void) {
        
        let medicineByIdRoute: String = "https://pharmacydelivery-production.up.railway.app/api/medicines/\(medicineId)"
        
        DispatchQueue.global(qos: .userInitiated).async {
            
            AF.request(medicineByIdRoute, method: .get).response { response in
                switch response.data {
                case .some(let data):
                    let json: JSON = JSON(data)
                    if json["statusCode"].stringValue == "200" {
                        let medicine = Medicine.loadMedicine(json: JSON(rawValue: json["payload"].dictionaryValue)!)
                        completion(medicine)
                    }
                    
                case .none: print("Nothing in response")
                }
            }
        }
    }
    
    
}

struct MedicinesRequest {
        
    private let allMedicinesRoute: String = "https://pharmacydelivery-production.up.railway.app/api/medicines"
    
    func getAllMedicinesWithPagination(page: Int, limit: Int = 10, completion: @escaping ([Medicine], Int) -> Void) {
        
        let medicineRouteWithHTTP = "\(allMedicinesRoute)?page=\(page)&limit=\(limit)"
        
        DispatchQueue.global(qos: .userInitiated).async {
            
            AF.request(medicineRouteWithHTTP, method: .get).response { response in
                switch response.data {
                case .some(let data):
                    let json: JSON = JSON(data)
                    if json["statusCode"].stringValue == "200" {
                        let medicines = Medicine.loadMedicineArray(jsonArray: json["payload"].arrayValue)
                        let total = json["total"].intValue
                        completion(medicines, total)
                    }

                case .none: print("Nothing in response")
                }
            }
        }
    }
    
}
