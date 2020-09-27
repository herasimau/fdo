//
//  HomeViewController.swift
//  FDO_TUSUR
//
//  Created by Leanid Herasimau on 14/04/2020.
//  Copyright © 2020 Tusur. All rights reserved.
//

import UIKit

class HomeViewController: UIViewController {

    private let authService: AuthServiceAPI = DIContainer.inject()

    @IBOutlet weak var mainContainerView: UIView!
    @IBOutlet weak var menuContainerView: UIView!
    @IBOutlet weak var profileButton: UIButton!
    @IBOutlet weak var mailButton: UIButton!
    @IBOutlet weak var recordBookButton: UIButton!
    @IBOutlet weak var paymentsButton: UIButton!
    @IBOutlet weak var mainButton: UIButton!
    @IBOutlet weak var profileLabel: UILabel!
    @IBOutlet weak var mailLabel: UILabel!
    @IBOutlet weak var recordBookLabel: UILabel!
    @IBOutlet weak var paymentLabel: UILabel!

    @IBOutlet weak var profileStackView: UIStackView!
    @IBOutlet weak var mailStackView: UIStackView!
    @IBOutlet weak var recordBookStackView: UIStackView!
    @IBOutlet weak var paymentStackView: UIStackView!

    private var isMainActive: Bool = true
    private var isProfileActive: Bool = false
    private var isMailActive: Bool = false
    private var isRecordBookActive: Bool = false
    private var isPaymentActive: Bool = false

    open override func viewDidLoad() {
        super.viewDidLoad()
        AppCoordinator.shared().initializeCoordinator(homeViewController: self)
        prepareButtons()
        prepareButtonsImages()
        prepareLabels()
        prepareLablesColors()
        prepareGestureRecognizers()
    }
    
    private func prepareGestureRecognizers() {
        let profileTap = UITapGestureRecognizer(target: self, action: #selector(self.profileButtonAction(_:)))
        let mailTap = UITapGestureRecognizer(target: self, action: #selector(self.mailButtonAction(_:)))
        let recordBookTap = UITapGestureRecognizer(target: self, action: #selector(self.recordBookButtonAction(_:)))
        let paymentTap = UITapGestureRecognizer(target: self, action: #selector(self.paymentButtonAction(_:)))

        profileStackView.addGestureRecognizer(profileTap)
        mailStackView.addGestureRecognizer(mailTap)
        recordBookStackView.addGestureRecognizer(recordBookTap)
        paymentStackView.addGestureRecognizer(paymentTap)
    }

    private func prepareLabels() {
        profileLabel.text = "Профиль"
        mailLabel.text = "Почта"
        recordBookLabel.text = "Зачетка"
        paymentLabel.text = "Платежи"
    }

    private func prepareLablesColors() {
        UIView.animate(withDuration: 1) {
            if let mainColor = UIColor(named: "logoColor") {
                self.profileLabel.textColor = self.isProfileActive ? mainColor : UIColor.gray
                self.profileLabel.font = self.isProfileActive ? UIFont(name: "Gilroy-ExtraBold", size: 14) : UIFont(name: "Gilroy-Light", size: 14)
                self.mailLabel.textColor = self.isMailActive ? mainColor : UIColor.gray
                self.mailLabel.font = self.isMailActive ? UIFont(name: "Gilroy-ExtraBold", size: 14) : UIFont(name: "Gilroy-Light", size: 14)
                self.recordBookLabel.textColor = self.isRecordBookActive ? mainColor : UIColor.gray
                self.recordBookLabel.font = self.isRecordBookActive ? UIFont(name: "Gilroy-ExtraBold", size: 14) : UIFont(name: "Gilroy-Light", size: 14)
                self.paymentLabel.textColor = self.isPaymentActive ? mainColor : UIColor.gray
                self.paymentLabel.font = self.isPaymentActive ? UIFont(name: "Gilroy-ExtraBold", size: 14) : UIFont(name: "Gilroy-Light", size: 14)
            }
        }
    }

    private func prepareButtons() {
        mainButton.layer.cornerRadius = 30
        mainButton.layer.borderWidth = 1
        mainButton.layer.borderColor = UIColor.gray.cgColor
    }

    private func prepareButtonsImages() {
        if let mainColor = UIColor(named: "logoColor") {
            let mainMenuImage = UIImage(named: "main_menu")?.withRenderingMode(.alwaysTemplate).withColor(isMainActive ? UIColor.white : UIColor.gray)
            let profileImage = UIImage(named: isProfileActive ? "profileFilled" : "profile")?.withRenderingMode(.alwaysTemplate).withColor(isProfileActive ? mainColor : UIColor.gray)
            let mailImage = UIImage(named: isMailActive ? "mailFilled" : "mail")?.withRenderingMode(.alwaysTemplate).withColor(isMailActive ? mainColor : UIColor.gray)
            let recordBookImage = UIImage(named: isRecordBookActive ? "record_bookFilled" : "record_book")?.withRenderingMode(.alwaysTemplate).withColor(isRecordBookActive ? mainColor : UIColor.gray)
            let paymentImage = UIImage(named: isPaymentActive ? "paymentFilled" : "payment")?.withRenderingMode(.alwaysTemplate).withColor(isPaymentActive ? mainColor : UIColor.gray)
            self.mainButton.setImage(mainMenuImage, for: .normal)
            self.mainButton.backgroundColor = isMainActive ? mainColor : UIColor.white
            self.profileButton.setImage(profileImage, for: .normal)
            self.mailButton.setImage(mailImage, for: .normal)
            self.recordBookButton.setImage(recordBookImage, for: .normal)
            self.paymentsButton.setImage(paymentImage, for: .normal)
        }

    }

    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        //NotificationCenter.default.removeObserver(self, name: .goToLogin, object: nil)
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        //let notifyCenter = NotificationCenter.default
        //notifyCenter.addObserver(self, selector: #selector(goToLogin(_:)), name: .goToLogin, object: nil)
        print("")
        if AppCoordinator.shared().isStartup() {
            self.startDashboard()
        }
    }

    @IBAction func paymentButtonAction(_ sender: Any) {
        isProfileActive = false
        isMainActive = false
        isMailActive = false
        isRecordBookActive = false
        isPaymentActive = true
        prepareButtonsImages()
        prepareLablesColors()
        if let mainColor = UIColor(named: "logoColor") {
            self.paymentLabel.doGlowAnimation(withColor: mainColor, withEffect: .big)
        }

        AppCoordinator.shared().startPaymentViewController()
    }

    @IBAction func recordBookButtonAction(_ sender: Any) {
        isProfileActive = false
        isMainActive = false
        isMailActive = false
        isRecordBookActive = true
        isPaymentActive = false
        prepareButtonsImages()
        prepareLablesColors()
        if let mainColor = UIColor(named: "logoColor") {
            self.recordBookLabel.doGlowAnimation(withColor: mainColor, withEffect: .big)
        }
        AppCoordinator.shared().startRecordBookViewController()
    }

    @IBAction func mailButtonAction(_ sender: Any) {
        isProfileActive = false
        isMainActive = false
        isMailActive = true
        isRecordBookActive = false
        isPaymentActive = false
        prepareButtonsImages()
        prepareLablesColors()
        if let mainColor = UIColor(named: "logoColor") {
            self.mailLabel.doGlowAnimation(withColor: mainColor, withEffect: .big)
        }
        AppCoordinator.shared().startMailViewController()
    }

    @IBAction func mainButtonAction(_ sender: Any) {
        isProfileActive = false
        isMainActive = true
        isMailActive = false
        isRecordBookActive = false
        isPaymentActive = false
        prepareButtonsImages()
        prepareLablesColors()
        AppCoordinator.shared().startDashBoardViewController()
    }

    @IBAction func profileButtonAction(_ sender: Any) {
        isProfileActive = true
        isMainActive = false
        isMailActive = false
        isRecordBookActive = false
        isPaymentActive = false
        prepareButtonsImages()
        prepareLablesColors()
        if let mainColor = UIColor(named: "logoColor") {
            self.profileLabel.doGlowAnimation(withColor: mainColor, withEffect: .big)
        }
        AppCoordinator.shared().startProfileViewController()
    }

}

extension HomeViewController {

    @objc func goToLogin(_ notification: NSNotification? = nil) {
        authService.logout()
        self.performSegue(withIdentifier: "backToLogin", sender: nil)
    }

    func startDashboard() {
        AppCoordinator.shared().startDashBoardViewController()
    }

}
