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
    
    private let service: GTLRSheetsService
    
    init(service: GTLRSheetsService) {
        self.service = service
        super.init()
    }
    
    func monthData() -> Observable<[MonthData]> {
        let query = GTLRSheetsQuery_SpreadsheetsValuesBatchGet.query(withSpreadsheetId: spreadsheetId)
        query.ranges = ["A3:A", "K3:K"]
        
        return service.rx.request(withQuery: query).map() { ticket, response in
            guard let data = response.json else {
                return [MonthData]()
            }
            
            let json = JSON(data)
            let date = json["valueRanges"][0]["values"].arrayValue
            let value = json["valueRanges"][1]["values"].arrayValue
            
            var monthData = [MonthData]()
            for i in 0..<date.count {
                monthData.append(MonthData(date: date[i][0].stringValue, value: value[i][0].doubleValue))
            }
            return monthData
        }
    }
    
    func create(entry: Entry) -> Observable<Void> {
        let rage = "Test"
        let json: [String : Any] = ["range": rage, "majorDimension": "ROWS", "values": [[entry.date, entry.hotWater, entry.coldWater, entry.electricity, 1, 1, 1]]]
        let object = GTLRSheets_ValueRange(json: json)
        let query = GTLRSheetsQuery_SpreadsheetsValuesAppend.query(withObject: object, spreadsheetId: spreadsheetId, range: rage)
        query.valueInputOption = kGTLRSheets_BatchUpdateValuesRequest_ValueInputOption_Raw
        return service.rx.request(withQuery: query).map(){ _ -> Void in
            return Void()
        }
    }
}
