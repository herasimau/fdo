//
//  PaymentViewController.swift
//  FDO_TUSUR
//
//  Created by Leanid Herasimau on 19/04/2020.
//  Copyright © 2020 Tusur. All rights reserved.
//

import UIKit

class PaymentViewController: BaseViewController<PaymentPresenterProtocol> {

    public var refreshActualControl = UIRefreshControl()
    public var refreshPlanControl = UIRefreshControl()
    @IBOutlet weak var planTablewView: UITableView!
    @IBOutlet weak var actualTableView: UITableView!

    override func viewDidLoad() {
        super.viewDidLoad()
        prepareTableView()
        presenter.loadData(force: false, pullRefresh: false)
    }
    
    func reloadTable(pullRefresh: Bool) {
        if pullRefresh {
            refreshActualControl.endRefreshing()
            refreshPlanControl.endRefreshing()
        }

        actualTableView.reloadData()
        planTablewView.reloadData()

    }

}

extension PaymentViewController: UITableViewDataSource, UITableViewDelegate {

    private func prepareTableView() {
        let planHeader = UIView(frame: CGRect(x: 0, y: 0, width: 60, height: 40))
        planHeader.backgroundColor = UIColor(named: "logoColor")
        let label = UILabel(frame: CGRect(x: 0, y: 0, width: 50, height: 30))
        label.text = "Запланированные платежи"
        label.textColor = UIColor.white
        label.font = UIFont(name: "Gilroy-ExtraBold", size: 15)
        planHeader.addSubview(label)
        planHeader.layer.cornerRadius = 8.0
        planHeader.clipsToBounds = true
        label.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            label.leftAnchor.constraint(equalTo: planHeader.leftAnchor, constant: 5),
            label.centerYAnchor.constraint(equalTo: planHeader.centerYAnchor)
        ])
        planTablewView.tableHeaderView = planHeader
        planTablewView.register(UINib(nibName: "PaymentCell", bundle: nil), forCellReuseIdentifier: "cell")
        planTablewView.dataSource = self
        planTablewView.delegate = self
        planTablewView.tableFooterView = UIView()
        refreshPlanControl.addTarget(self, action: #selector(self.refreshControl(_:)), for: .valueChanged)
        planTablewView.addSubview(refreshPlanControl)


        let actualHeader = UIView(frame: CGRect(x: 0, y: 0, width: 60, height: 40))
        actualHeader.backgroundColor =  UIColor(named: "logoColor")
        let actualLabel = UILabel(frame: CGRect(x: 0, y: 0, width: 50, height: 30))
        actualLabel.text = "Фактические платежи"
        actualLabel.textColor = UIColor.white
        actualLabel.font = UIFont(name: "Gilroy-ExtraBold", size: 15)
        actualHeader.addSubview(actualLabel)
        actualHeader.layer.cornerRadius = 8.0
        actualHeader.clipsToBounds = true
        actualLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            actualLabel.leftAnchor.constraint(equalTo: actualHeader.leftAnchor, constant: 5),
            actualLabel.centerYAnchor.constraint(equalTo: actualHeader.centerYAnchor)
        ])
        actualTableView.tableHeaderView = actualHeader
        actualTableView.register(UINib(nibName: "PaymentCell", bundle: nil), forCellReuseIdentifier: "cell")
        actualTableView.dataSource = self
        actualTableView.delegate = self
        actualTableView.tableFooterView = UIView()
        refreshActualControl.addTarget(self, action: #selector(self.refreshControl(_:)), for: .valueChanged)
        actualTableView.addSubview(refreshActualControl)
    }

    @objc func refreshControl(_ sender: Any) {
        presenter.loadData(force: true, pullRefresh: true)
    }

    func numberOfSections(in tableView: UITableView) -> Int {
        return tableView == actualTableView ? presenter.numOfActualPayments : presenter.numOfPlanPayments
    }

    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 10
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
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "cell") as? PaymentCell else { return UITableViewCell() }
        let viewModel = tableView == actualTableView ? presenter.viewModelForActualPayment(at: indexPath.section) : presenter.viewModelForPlanPayment(at: indexPath.section)
        cell.set(viewModel: viewModel)
        return cell
    }

    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        cell.contentView.layer.masksToBounds = true
        let radius = cell.contentView.layer.cornerRadius
        cell.layer.shadowPath = UIBezierPath(roundedRect: cell.bounds, cornerRadius: radius).cgPath
    }
}
