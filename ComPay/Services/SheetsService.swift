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
        query.ranges = ["A3:A", "K3:K"]
        
        return service.rx.request(withQuery: query).map() { [weak self] ticket, response in
            guard let data = response.json else {
                return [MonthData]()
            }
            
            let json = JSON(data)
            let dateValue = json["valueRanges"][0]["values"].arrayValue
            let value = json["valueRanges"][1]["values"].arrayValue
            
            var monthData = [MonthData]()
            for i in 0..<dateValue.count {
                if let date = self?.dateFormatter.date(from: dateValue[i][0].stringValue) {
                    monthData.append(MonthData(date: date, value: value[i][0].doubleValue))
                }
            }
            return monthData
        }
    }
    
    func create(entry: Entry) -> Observable<Void> {
        let rage = "Test"
        let json: [String : Any] = ["range": rage, "majorDimension": "ROWS", "values": [[entry.date, entry.hotWater, entry.coldWater, entry.electricity, 180.55, 35.4, 5.38]]]
        let object = GTLRSheets_ValueRange(json: json)
        let query = GTLRSheetsQuery_SpreadsheetsValuesAppend.query(withObject: object, spreadsheetId: spreadsheetId, range: rage)
        query.valueInputOption = kGTLRSheets_BatchUpdateValuesRequest_ValueInputOption_Raw
        return service.rx.request(withQuery: query).map(){ _ -> Void in
            return Void()
        }
    }
}
