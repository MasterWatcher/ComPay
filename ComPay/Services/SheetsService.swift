//
//  SheetsService.swift
//  ComPay
//
//  Created by Anton Goncharov on 1/14/18.
//  Copyright © 2018 Anton Goncharov. All rights reserved.
//

import Foundation
import GoogleAPIClientForREST
import GoogleSignIn
import RxSwift
import SwiftyJSON

protocol SheetsService {
    func monthData() -> Observable<[MonthData]>
    func create(entry: Entry) -> Observable<Void>
}

class SheetsServiceImpl : NSObject, SheetsService {
   
    let spreadsheetId = "1XAp7yK02Ekiw_roxyUonpwEdbVS-7T63Tp9LBHQZ9Xs"
    
    lazy var dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd/MM/yyyy"
        return formatter
    }()
    
    private let service: GTLRSheetsService
    
    init(service: GTLRSheetsService) {
        self.service = service
        super.init()
    }
    
    func monthData() -> Observable<[MonthData]> {
        let query = GTLRSheetsQuery_SpreadsheetsValuesBatchGet.query(withSpreadsheetId: spreadsheetId)
        query.ranges = ["A3:A", "B3:B", "C3:C", "D3:D", "H3:H", "I3:I", "J3:J", "K3:K"]
        
        return service.rx.request(withQuery: query).map() { [weak self] ticket, response in
            guard let data = response.json else {
                return [MonthData]()
            }
            
            let json = JSON(data)
            let dateValue = json["valueRanges"][0]["values"].arrayValue
            let hotWaterValue = json["valueRanges"][1]["values"].arrayValue
            let coldWaterValue = json["valueRanges"][2]["values"].arrayValue
            let electricityValue = json["valueRanges"][3]["values"].arrayValue
            let hotWaterCost = json["valueRanges"][4]["values"].arrayValue
            let coldWaterCost = json["valueRanges"][5]["values"].arrayValue
            let electricityCost = json["valueRanges"][6]["values"].arrayValue
            let total = json["valueRanges"][7]["values"].arrayValue
            
            var monthData = [MonthData]()
            for i in 0..<dateValue.count {
                if let date = self?.dateFormatter.date(from: dateValue[i][0].stringValue) {
                    monthData.append(MonthData(date: date,
                                               hotWaterValue: hotWaterValue[i][0].doubleValue,
                                               coldWaterValue: coldWaterValue[i][0].doubleValue,
                                               electricityValue: electricityValue[i][0].doubleValue,
                                               hotWaterCost: hotWaterCost[i][0].doubleValue,
                                               coldWaterCost: coldWaterCost[i][0].doubleValue,
                                               electricityCost: electricityCost[i][0].doubleValue,
                                               total: total[i][0].doubleValue))
                }
            }
            return monthData
        }
    }
    
    func create(entry: Entry) -> Observable<Void> {
        let rage = "Test"
        let json: [String : Any] = ["range": rage, "majorDimension": "ROWS", "values": [[entry.date, entry.hotWater, entry.coldWater, entry.electricity, 188.33, 38.06, 5.47]]]
        let object = GTLRSheets_ValueRange(json: json)
        let query = GTLRSheetsQuery_SpreadsheetsValuesAppend.query(withObject: object, spreadsheetId: spreadsheetId, range: rage)
        query.valueInputOption = kGTLRSheets_BatchUpdateValuesRequest_ValueInputOption_Raw
        return service.rx.request(withQuery: query).map(){ _ -> Void in
            return Void()
        }
    }
}
