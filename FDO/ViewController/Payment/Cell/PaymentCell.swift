//
//  PaymentCell.swift
//  FDO_TUSUR
//
//  Created by Leanid Herasimau on 25/04/2020.
//  Copyright © 2020 Tusur. All rights reserved.
//

import UIKit

class PaymentCell: UITableViewCell, ViewViewModable {
    typealias VMODEL = PaymentCellViewModel
    var viewModel: PaymentCellViewModel?

    @IBOutlet weak var purposeLabel: UILabel!
    @IBOutlet weak var amountLabel: UILabel!
    @IBOutlet weak var paymentDateLabel: UILabel!

    @IBOutlet weak var mainView: UIView!
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    func set(purpose: String, amount: String, paymentDate: String) {
        purposeLabel.text = purpose.capitalizingFirstLetter()
        let amountString = amount + "₽"
        amountLabel.text = amountString
        paymentDateLabel.text = paymentDate
    }
}
