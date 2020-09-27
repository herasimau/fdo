//
//  RecordBookViewController.swift
//  FDO_TUSUR
//
//  Created by Leanid Herasimau on 19/04/2020.
//  Copyright © 2020 Tusur. All rights reserved.
//

import UIKit

class RecordBookViewController: BaseViewController<RecordBookPresenterProtocol> {

    public var refreshControl = UIRefreshControl()
    @IBOutlet weak var tableView: UITableView!

    override func viewDidLoad() {
        super.viewDidLoad()
        prepareTableView()
        presenter.loadData(force: false, pullRefresh: false)
    }
    
    func reloadTable(pullRefresh: Bool) {
        if pullRefresh {
            refreshControl.endRefreshing()
        }
        tableView.reloadData()
    }

}

extension RecordBookViewController: UITableViewDataSource, UITableViewDelegate {

    private func prepareTableView() {
        let header = UIView(frame: CGRect(x: 0, y: 0, width: 60, height: 40))
        header.backgroundColor =  UIColor(named: "logoColor")
        let label = UILabel(frame: CGRect(x: 0, y: 0, width: 50, height: 30))
        label.text = "Зачетная книжка"
        label.textColor = UIColor.white
        label.font = UIFont(name: "Gilroy-ExtraBold", size: 15)
        header.addSubview(label)
        header.layer.cornerRadius = 8.0
        header.clipsToBounds = true
        label.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            label.leftAnchor.constraint(equalTo: header.leftAnchor, constant: 5),
            label.centerYAnchor.constraint(equalTo: header.centerYAnchor)
        ])
        tableView.tableHeaderView = header

        tableView.register(UINib(nibName: "RecordBookCell", bundle: nil), forCellReuseIdentifier: "cell")
        tableView.dataSource = self
        tableView.delegate = self
        tableView.tableFooterView = UIView()
        refreshControl.addTarget(self, action: #selector(self.refreshControl(_:)), for: .valueChanged)
        tableView.addSubview(refreshControl)
    }

    @objc func refreshControl(_ sender: Any) {
        presenter.loadData(force: true, pullRefresh: true)
    }

    func numberOfSections(in tableView: UITableView) -> Int {
        return presenter.numOfRecords
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
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "cell") as? RecordBookCell else { return UITableViewCell() }
        cell.set(viewModel: presenter.viewModelForRecordItem(at: indexPath.section))
        return cell
    }

    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        cell.contentView.layer.masksToBounds = true
        let radius = cell.contentView.layer.cornerRadius
        cell.layer.shadowPath = UIBezierPath(roundedRect: cell.bounds, cornerRadius: radius).cgPath
    }
}
