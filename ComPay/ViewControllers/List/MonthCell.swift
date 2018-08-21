//
//  MonthCell.swift
//  ComPay
//
//  Created by Anton Goncharov on 1/14/18.
//  Copyright © 2018 Anton Goncharov. All rights reserved.
//

import UIKit

class MonthCell: UITableViewCell {

    @IBOutlet weak var monthLabel: UILabel!
    @IBOutlet weak var totalLabel: UILabel!
    
    func configure(with viewModel: MonthItemViewModel) {
        monthLabel.text = viewModel.date
        totalLabel.text = viewModel.value
    }
}
