//
//  MailPageItemCell.swift
//  FDO_TUSUR
//
//  Created by Leanid Herasimau on 25/04/2020.
//  Copyright © 2020 Tusur. All rights reserved.
//

import UIKit

class MailPageItemCell: UITableViewCell, ViewViewModable {
    typealias VMODEL = MailPageItemCellViewModel
    var viewModel: MailPageItemCellViewModel?

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var countLabel: UILabel!
    @IBOutlet weak var mailTypeIcon: UIImageView!

    override func awakeFromNib() {
        super.awakeFromNib()
    }

    func set(title: String, unRead: Int?, total: Int?, mailType: MailType) {
        titleLabel.text = title
        var attributedText: NSAttributedString?
        if let count = unRead, count > 0 {
            attributedText = NSMutableAttributedString().bold("(\(count)) ").normal("\(total ?? 0)")
        } else {
            attributedText = NSMutableAttributedString().normal("\(total ?? 0)")
        }

        countLabel.attributedText = attributedText
        switch mailType {
        case .arrival:
            mailTypeIcon.image = UIImage(named: "arrivalMail")?.withColor(UIColor(named: "logoColor") ?? UIColor.white)
        case .study:
            mailTypeIcon.image = UIImage(named: "studyMail")?.withColor(UIColor(named: "logoColor") ?? UIColor.white)
        case .sent:
            mailTypeIcon.image = UIImage(named: "sentMail")?.withColor(UIColor(named: "logoColor") ?? UIColor.white)
        }
    }
}
