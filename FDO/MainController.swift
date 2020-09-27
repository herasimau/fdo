//
//  ViewController.swift
//  FDO_TUSUR
//
//  Created by Leanid Herasimau on 14/04/2020.
//  Copyright © 2020 Tusur. All rights reserved.
//

import UIKit

class MainController: UIViewController {

    @IBOutlet weak var mainView: UIView?
    @IBOutlet weak var logoView: UIView?
    @IBOutlet weak var logoImage: UIImageView?
    @IBOutlet weak var loginButton: UIButton?
    @IBOutlet weak var titleLabel: UILabel?
    @IBOutlet weak var subTitle: UILabel?

    override func viewDidLoad() {
        super.viewDidLoad()
        if AuthManager.shared.getAuth() != nil {
            performSegue(withIdentifier: "noLoginSegue", sender: self)
        }
        logoImage?.image = UIImage(named: "logo")
        titleLabel?.text = "Факультет дистанционного"
        titleLabel?.font = UIFont(name: "Gilroy-ExtraBold", size: 16)
        titleLabel?.textColor = UIColor.white
        subTitle?.text = "обучения ТУСУР"
        subTitle?.font = UIFont(name: "Gilroy-ExtraBold", size: 16)
        subTitle?.textColor = UIColor.white
        loginButton?.setTitle("Войти", for: .normal)
        loginButton?.layer.cornerRadius = 10
        loginButton?.clipsToBounds = true

        let backgroundImage = UIImage(named: "loginBackground")
        if let image = backgroundImage {
            let backgroundView = UIImageView(image: UIImage.resize(image: image, targetSize: CGSize(width: 900, height: 1800)))
            backgroundView.alpha = 0.05
            mainView?.addSubview(backgroundView)
        }
    }

}

