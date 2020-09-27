//
//  MailPagePreviewViewController.swift
//  FDO_TUSUR
//
//  Created by Leanid Herasimau on 25/04/2020.
//  Copyright © 2020 Tusur. All rights reserved.
//

import UIKit
import Lottie

class MailPagePreviewViewController: BaseViewController<MailPreviewPresenterProtocol> {

    @IBOutlet weak var mailView: UIView!
    @IBOutlet weak var tableView: UITableView!

    override func viewDidLoad() {
        super.viewDidLoad()
        let mailAnimation = AnimationView(name: "mail")
        mailView.contentMode = .scaleAspectFit
        mailView.addSubview(mailAnimation)
        mailAnimation.frame = mailView.bounds
        mailAnimation.loopMode = .playOnce
        mailAnimation.play()
        prepareTableView()
        presenter.loadData(force: false, pullRefresh: false)
    }

    func reloadTable(pullRefresh: Bool) {
        tableView.reloadData()
    }
}

extension MailPagePreviewViewController: UITableViewDataSource, UITableViewDelegate {

    private func prepareTableView() {
        tableView.register(UINib(nibName: "MailPagePreviewItemCell", bundle: nil), forCellReuseIdentifier: "cell")
        tableView.dataSource = self
        tableView.delegate = self
        tableView.tableFooterView = UIView()
        //refreshControl.addTarget(self, action: #selector(self.refreshControl(_:)), for: .valueChanged)
        //tableView.addSubview(refreshControl)
    }

    @objc func refreshControl(_ sender: Any) {
        presenter.loadData(force: true, pullRefresh: true)
    }

    func numberOfSections(in tableView: UITableView) -> Int {
        return presenter.numOfMailPreviewItems
    }

    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 5
    }

    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = UIView()
        headerView.backgroundColor = UIColor.clear
        return headerView
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60.0
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "cell") as? MailPagePreviewItemCell else { return UITableViewCell() }
        cell.set(viewModel: presenter.viewModelForMailPagePreviewItem(at: indexPath.section))
        cell.backgroundColor = UIColor(named: "lightBg")
        return cell
    }

    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        cell.contentView.layer.masksToBounds = true
        let radius = cell.contentView.layer.cornerRadius
        cell.layer.shadowPath = UIBezierPath(roundedRect: cell.bounds, cornerRadius: radius).cgPath
    }
}
