//
//  ListItemViewModel.swift
//  ComPay
//
//  Created by Anton Goncharov on 8/21/18.
//  Copyright © 2018 Anton Goncharov. All rights reserved.
//

import Foundation

struct MonthItemViewModel {
    let date: String
    let value: String
    
    let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "d MMMM"
        return formatter
    }()
    
    let numberFormatter: NumberFormatter = {
        let formatter = NumberFormatter()
        formatter.decimalSeparator = "."
        formatter.maximumFractionDigits = 2
        return formatter
    }()
    
    init(monthData: MonthData) {
        date = dateFormatter.string(from: monthData.date)
        value = numberFormatter.string(from: monthData.value as NSNumber) ?? "0.00"
    }
}
