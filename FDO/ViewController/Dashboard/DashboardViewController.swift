//
//  DashboardViewController.swift
//  FDO_TUSUR
//
//  Created by Leanid Herasimau on 18/04/2020.
//  Copyright © 2020 Tusur. All rights reserved.
//

import UIKit

class DashboardViewController: BaseViewController<DashboardPresenterProtocol> {

    @IBOutlet weak var mainContainer: UIView!
    var timelineFeed: TimelineFeed?

    @IBOutlet weak var headerCollectionView: UICollectionView!

    override func viewDidLoad() {
        super.viewDidLoad()
        prepareCollectionView()
        timelineFeed = TimelineFeed(frame: CGRect(x: 0, y: 0, width: mainContainer.bounds.width * 0.95, height: mainContainer.bounds.height))
        timelineFeed?.center.x = mainContainer.center.x
        timelineFeed?.dataSource = self
        timelineFeed?.delegate = self
        timelineFeed?.paddingBetweenCards = 20.0
        timelineFeed?.bottomMargin = 200
        view.addSubview(timelineFeed!)
        NSLayoutConstraint.activate([
             timelineFeed!.centerXAnchor.constraint(equalTo: mainContainer.centerXAnchor)
         ])
        presenter.loadData()
        let collectionViewLayout = headerCollectionView.collectionViewLayout as? UICollectionViewFlowLayout
        collectionViewLayout?.sectionInset = UIEdgeInsets(top: 5, left: 5, bottom: 5, right: 5)
        collectionViewLayout?.invalidateLayout()
        view.bringSubviewToFront(headerCollectionView)
    }

    override func viewWillAppear(_ animated: Bool) {
        timelineFeed?.reloadData()
    }

    public func reloadTimeline(pullRefresh: Bool) {
        if pullRefresh {
            timelineFeed?.cardsContainer.setContentOffset(CGPoint(x: 0, y: 70), animated: true)
            timelineFeed?.refreshControl.endRefreshing()
        }

        timelineFeed?.reloadData()
    }

    public func reloadHeader() {
        headerCollectionView.reloadData()
    }
}

extension DashboardViewController: TimelineFeedDataSource {

    func numberOfCards(in timelineFeed: TimelineFeed) -> Int {
        presenter.numOfLessons
    }

    func card(at index: Int, in timelineFeed: TimelineFeed) -> TimelineCard {
        return presenter.viewCard(at: index)
    }

    func elementsForTimelineCard(at index: Int, containerWidth: CGFloat) -> [TimelineSourceElement] {
        return presenter.viewCardElements(at: index)
    }

}

extension DashboardViewController: TimelineFeedDelegate {
    func refreshTimeline() {
        presenter.reloadCurrentSemester()
    }

    func didSelectElement(at index: Int, timelineCardIndex: Int) {
        print("didSelectElement")
    }

    func didSelectSubElement(at index: (Int, Int), timelineCardIndex: Int) {
        print("didSelectSubElement")
    }
}

extension DashboardViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func prepareCollectionView() {
        headerCollectionView.backgroundColor = UIColor.white
        headerCollectionView.register(UINib(nibName: "SemesterCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "SemesterCollectionViewCell")
        headerCollectionView.delegate = self
        headerCollectionView.dataSource = self
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.presenter.numOfSemesters
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "SemesterCollectionViewCell", for: indexPath) as? SemesterCollectionViewCell else { return UICollectionViewCell() }
        cell.set(viewModel: presenter.viewModelForSemester(at: indexPath.row))
        cell.backgroundColor = UIColor(named: "logoColor")
        return cell
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        presenter.loadSemester(at: indexPath.row)
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 50, height: 60)
    }
}
