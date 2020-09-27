//
//  RecordBookTableViewCell.swift
//  FDO_TUSUR
//
//  Created by Leanid Herasimau on 25/04/2020.
//  Copyright © 2020 Tusur. All rights reserved.
//

import UIKit

class RecordBookCell: UITableViewCell, ViewViewModable {
    typealias VMODEL = RecordBookCellViewModel
    var viewModel: RecordBookCellViewModel?
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var intermidiateCertificationLabel: UILabel!
    @IBOutlet weak var gradeLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!

    @IBOutlet weak var mainView: UIView!
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    func set(title: String?, grade: String?, intermidiateCertification: String?, date: String?) {
        titleLabel.text = title
        gradeLabel.text = grade
        dateLabel.text = date
        intermidiateCertificationLabel.text = intermidiateCertification
    }

}
