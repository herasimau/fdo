//
//  SemesterCollectionViewCell.swift
//  FDO_TUSUR
//
//  Created by Leanid Herasimau on 22/04/2020.
//  Copyright © 2020 Tusur. All rights reserved.
//

import UIKit

class SemesterCollectionViewCell: UICollectionViewCell, ViewViewModable {
    typealias VMODEL = SemesterCollectionViewCellViewModel
    var viewModel: SemesterCollectionViewCellViewModel?

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var courseLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        courseLabel.text = "Сем"
        self.layer.cornerRadius = 15.0
        self.layer.borderWidth = 5.0
        self.layer.borderColor = UIColor.clear.cgColor
        self.layer.masksToBounds = true
    }

    func set(title: String, isSelected: Bool) {
        self.contentView.backgroundColor = isSelected ? UIColor(named: "logoColor") : UIColor.white
        self.contentView.layer.borderColor =  isSelected ? UIColor.white.cgColor : UIColor(named: "logoColor")?.cgColor
        courseLabel.textColor = isSelected ? UIColor.white : UIColor.darkGray
        titleLabel.textColor = isSelected ? UIColor.white : UIColor.darkGray
        titleLabel.text = title
    }

}
