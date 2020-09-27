//
//  ProfileViewController.swift
//  FDO_TUSUR
//
//  Created by Leanid Herasimau on 19/04/2020.
//  Copyright © 2020 Tusur. All rights reserved.
//

import UIKit
import SwiftSpinner

class ProfileViewController: BaseViewController<ProfilePresenterProtocol> {

    private let userService: UserServiceAPI = DIContainer.inject()

    @IBOutlet weak var pageTitle: UILabel!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var userImage: UIImageView!
    @IBOutlet weak var completeName: UILabel!
    @IBOutlet weak var statusLabel: UILabel!
    @IBOutlet weak var emailLabel: UILabel!
    @IBOutlet weak var editButton: UIButton!
    @IBOutlet weak var groupIcon: UIImageView!
    @IBOutlet weak var departmentIcon: UIImageView!
    @IBOutlet weak var directionIcon: UIImageView!
    @IBOutlet weak var courseIcon: UIImageView!
    @IBOutlet weak var variantIcon: UIImageView!
    @IBOutlet weak var planIcon: UIImageView!

    @IBOutlet weak var groupTitle: UILabel!
    @IBOutlet weak var groupLabel: UILabel!

    @IBOutlet weak var departmentTitle: UILabel!
    @IBOutlet weak var departmentLabel: UILabel!

    @IBOutlet weak var planTitle: UILabel!
    @IBOutlet weak var planLabel: UILabel!

    @IBOutlet weak var directionTitle: UILabel!
    @IBOutlet weak var directionLabel: UILabel!

    @IBOutlet weak var courseTitle: UILabel!
    @IBOutlet weak var courseLabel: UILabel!

    @IBOutlet weak var variantTitle: UILabel!
    @IBOutlet weak var variantLabel: UILabel!

    var imagePicker: ImagePicker!
    var userInfoModel: UserInfoModel?

    override func viewDidLoad() {
        super.viewDidLoad()
        imagePicker = ImagePicker(presentationController: self, delegate: self)
        pageTitle.text = "Личные данные"
        let radius = userImage.frame.width/2.0
        userImage.clipsToBounds = true
        userImage.layer.cornerRadius = radius
        userImage.layer.masksToBounds = true
        userImage.layer.borderColor = UIColor(named: "logoColor")?.cgColor
        userImage.layer.borderWidth = 2

        editButton.backgroundColor = UIColor(named: "logoColor")
        editButton.layer.cornerRadius = 12.5
        editButton.layer.borderWidth = 1
        editButton.layer.borderColor = UIColor(named: "logoColor")?.cgColor
        let image = UIImage(named: "editIcon")?.withColor(UIColor.white)
        if let editImage = image {
            editButton.setImage(UIImage.resize(image: editImage, targetSize: CGSize(width: 15, height: 15)), for: .normal)
            editButton.layer.zPosition = 1
        }

        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(imageTapped(tapGestureRecognizer:)))
        userImage.isUserInteractionEnabled = true
        userImage.addGestureRecognizer(tapGestureRecognizer)

        
        userImage.image = loadUserImage()

        prepareFont()
        presenter.getUserInfo(force: false, pullRefresh: false)
    }

    public func reloadText(userInfo: UserInfoModel, pullRefresh: Bool) {
        if pullRefresh {
            self.scrollView.refreshControl?.endRefreshing()
        }
        prepareText(userInfo: userInfo)
    }

    public func prepareText(userInfo: UserInfoModel) {
        completeName.text = userInfo.completeName ?? ""
        emailLabel.text = userInfo.email ?? ""
        statusLabel.text = userInfo.status ?? ""
        groupLabel.text = userInfo.group ?? ""
        departmentLabel.text = userInfo.department ?? ""
        planLabel.text = userInfo.studyPlan ?? ""
        directionLabel.text = userInfo.trainingDirection ?? ""
        courseLabel.text = userInfo.course ?? ""
        variantLabel.text = userInfo.variantCode ?? ""
    }

    public func prepareFont() {
        [groupTitle, directionTitle, courseTitle, variantTitle, departmentTitle, planTitle].forEach {
            $0.font = UIFont(name: "Gilroy-ExtraBold", size: 14)
        }
        [groupLabel, directionLabel, courseLabel, variantLabel, departmentLabel, planLabel].forEach {
            $0.font = UIFont(name: "Gilroy-ExtraBold", size: 13)
        }
    }

    var refreshControl: UIRefreshControl!
        override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(refresh), for: .valueChanged)
        scrollView.refreshControl = refreshControl
    }

    @objc func refresh() {
        presenter.getUserInfo(force: true, pullRefresh: true)
    }

    @objc func imageTapped(tapGestureRecognizer: UITapGestureRecognizer) {
        self.imagePicker.present(from: self.view)
    }

    func loadUserImage() -> UIImage? {
        let imgPath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent("userPicture.jpg")
        var image: UIImage?
        if let path = imgPath?.path {
            image = UIImage.loadImageFromPath(path as NSString)
        }

        return image ?? UIImage(named: "imageEmpty")
    }

}

extension ProfileViewController: ImagePickerDelegate {

    func didSelect(image: UIImage?) {
        SwiftSpinner.show("Сохраняю...")

        self.userImage.image = image
        saveImage(image: image)
    }

    func saveImage(image: UIImage?) {
        if let imageCheck = image {
            let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent("userPicture.jpg")
            if let data = imageCheck.jpegData(compressionQuality:  1.0), let path = documentsDirectory {
                do {
                    try data.write(to: path, options: .atomic)
                    SwiftSpinner.hide()
                } catch {
                    SwiftSpinner.hide()
                }
            }
        }
    }

}
