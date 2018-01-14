//
//  GTLRSheetsService+Rx.swift
//  ComPay
//
//  Created by Anton Goncharov on 1/14/18.
//  Copyright © 2018 Anton Goncharov. All rights reserved.
//

import Foundation
import GoogleAPIClientForREST
import RxSwift
import RxCocoa

extension Reactive where Base: GTLRSheetsService {
    func request(withQuery query: GTLRQueryProtocol) -> Observable<(ticket: GTLRServiceTicket, response: GTLRObject)> {
        return Observable.create { observer in
            let task = self.base.executeQuery(query, completionHandler: { (ticket, response, error) in
                guard let response = response as? GTLRObject else {
                    observer.on(.error(error ?? RxCocoaURLError.unknown))
                    return
                }
                observer.on(.next((ticket, response)))
                observer.on(.completed)
            })
            return Disposables.create()
            //TODO: why "finished with error - code: -999"
            return Disposables.create(with: task.cancel)
        }
    }
}
