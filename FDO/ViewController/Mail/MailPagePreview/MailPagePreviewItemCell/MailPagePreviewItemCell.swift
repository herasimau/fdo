//
//  MailPagePreviewItemCell.swift
//  FDO_TUSUR
//
//  Created by Leanid Herasimau on 25/04/2020.
//  Copyright © 2020 Tusur. All rights reserved.
//

import UIKit

class MailPagePreviewItemCell: UITableViewCell, ViewViewModable {
    typealias VMODEL = MailPagePreviewItemCellViewModel
    var viewModel: MailPagePreviewItemCellViewModel?

    @IBOutlet weak var fromLabel: UILabel!
    @IBOutlet weak var subjectLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
    }

    func set(from: String, unRead: Bool, subject: String, date: String) {
        if unRead {
            fromLabel.attributedText = NSMutableAttributedString().bold("\(from)")
            subjectLabel.attributedText = NSMutableAttributedString().bold("\(subject)")
            dateLabel.attributedText = NSMutableAttributedString().bold("\(date)")
        } else {
            fromLabel.attributedText = NSMutableAttributedString().normal("\(from)")
            subjectLabel.attributedText = NSMutableAttributedString().normal("\(subject)")
            dateLabel.attributedText = NSMutableAttributedString().normal("\(date)")
        }
    }
}
