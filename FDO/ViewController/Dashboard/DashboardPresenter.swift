//
//  DashboardPresenter.swift
//  FDO_TUSUR
//
//  Created by Leanid Herasimau on 20/04/2020.
//  Copyright © 2020 Tusur. All rights reserved.
//

import Foundation
import UIKit
import SwiftSpinner

protocol DashboardPresenterProtocol: class {
    var numOfLessons: Int { get }
    var numOfSemesters: Int { get }
    func loadData()
    func reloadCurrentSemester()
    func loadSemester(at index: Int)
    func viewModelForSemester(at index: Int) -> BaseViewBindable<SemesterCollectionViewCell>
    func viewCard(at index: Int) -> TimelineCard
    func viewCardElements(at index: Int) -> [TimelineSourceElement]
}

class DashboardPresenter: BasePresenter<DashboardViewController, Void>, DashboardPresenterProtocol {
   private let semesterService: SemesterServiceAPI = DIContainer.inject()

    private var semesters: [SemesterCollectionViewCellViewModel] = []
    private var semester: SemesterModel?
    private var lessons: [LessonModel] = []

    var numOfLessons: Int {
        return lessons.count
    }

    var numOfSemesters: Int {
        return semesters.count
    }

    func loadData() {
        getSemesters()
    }

    func loadSemester(at index: Int) {
        semesters.forEach { $0.isSelected = false }
        semesters[index].isSelected = true
        getSemester(semesterId: semesters[index].model.id, force: false)
    }

    func viewCard(at index: Int) -> TimelineCard {
        let lesson = lessons[index]
        return buildCard(lesson: lesson)
    }

    func viewModelForSemester(at index: Int) -> BaseViewBindable<SemesterCollectionViewCell> {
        return semesters[index]
    }

    func viewCardElements(at index: Int) -> [TimelineSourceElement] {
        let lesson = lessons[index]
        return buildCardElements(lesson: lesson)
    }

    private func buildCardElements(lesson: LessonModel) -> [TimelineSourceElement] {
        var elements: [TimelineSourceElement] = []
        var items: [TimelineItem] = []

        lesson.certifications.forEach { certification in
            let font = UIFont(name: "Gilroy-ExtraBold", size: 14)
            let attributesTitle: [NSAttributedString.Key: Any] = [
                .font: font ?? UIFont.boldSystemFont(ofSize: 14),
                .foregroundColor: UIColor.darkText,
            ]
            let attributesSubTitle: [NSAttributedString.Key: Any] = [
                .font: font ?? UIFont.boldSystemFont(ofSize: 14),
                .foregroundColor: UIColor.darkGray,
            ]
            let attrubitedTitle = NSAttributedString(string: certification.title ?? "", attributes: attributesTitle)
            let str = "\(certification.score ?? "") \(certification.completionDate?.toString() ?? "")"
            let attrubitedSubTitle = NSAttributedString(string: str, attributes: attributesSubTitle)
            let icon = getIconByType(certificationType: certification.certificationType ?? .none)
            let item = TimelineItem.init(title: attrubitedTitle, subtitle: attrubitedSubTitle, icon: icon)
            items.append(item)
        }

        let header = UIView(frame: CGRect(x: 0, y: 0, width: 60, height: 40))
        header.backgroundColor = UIColor.white
        let label = UILabel(frame: CGRect(x: 0, y: 0, width: 50, height: 30))
        label.text = "Аттестация"
        label.textColor = UIColor.darkText
        label.font = UIFont(name: "Gilroy-ExtraBold", size: 15)
        header.addSubview(label)

        label.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            label.leftAnchor.constraint(equalTo: header.leftAnchor, constant: 0),
            label.centerYAnchor.constraint(equalTo: header.centerYAnchor)
        ])

        let groupItem = TimelineItemGroup(customView: header, items: items, icon: UIImage(named: "certificationIcon"))

        elements.append(groupItem)
        return elements
    }

    private func getIconByType(certificationType: CertificationType) -> UIImage? {
        switch(certificationType) {
        case .credit: return UIImage(named: "creditIcon")
        case .exam: return UIImage(named: "examIcon")
        case .test: return UIImage(named: "testIcon")
        case .laboratory: return UIImage(named: "laboratoryIcon")
        default: return nil
        }
    }

    private func buildCard(lesson: LessonModel) -> TimelineCard {
        let timelineCard = TimelineCard(width: self.view!.mainContainer.bounds.width * 0.95)
        timelineCard.backgroundColor = UIColor.white
        timelineCard.borderAppearance = (UIColor(named: "logoColor") ?? UIColor.white, 2.0)
        timelineCard.cornerRadius = 20.0
        timelineCard.lineColor = .darkGray
        timelineCard.itemShapeHeight = 30.0
        timelineCard.timelinePathWidth = 2.0
        timelineCard.margins = (20, 10, 20, 10)

        let header = UIView(frame: CGRect(x: 0, y: 0, width: 60, height: 40))
        header.backgroundColor = UIColor(named: "logoColor")
        timelineCard.headerView = header
        let label = UILabel(frame: CGRect(x: 0, y: 0, width: 50, height: 30))
        label.text = lesson.title
        label.textColor = UIColor.white
        label.font = UIFont(name: "Gilroy-ExtraBold", size: 14)
        header.addSubview(label)

        label.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            label.leftAnchor.constraint(equalTo: header.leftAnchor, constant: 15),
            label.centerYAnchor.constraint(equalTo: header.centerYAnchor)
        ])

        return timelineCard
    }

    func reloadCurrentSemester() {
        if let sem = self.semesters.first(where: { $0.isSelected }) {
            getSemester(semesterId: sem.model.id, force: true, pullRefresh: true)
        }
    }

    private func getSemesters() {
        semesterService.getSemesters(){ [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let semestersData):
                self.semesters = semestersData.map { SemesterCollectionViewCellViewModel(model: $0) }
                if let sem = self.semesters.first(where: {$0.model.isCurrent}) {
                    sem.isSelected = true
                    self.getSemester(semesterId: sem.model.id, force: false, pullRefresh: false)
                }
            case .failure:
                print("Error loading semester")
            }
        }
    }

    public func getSemester(semesterId: Int, force: Bool, pullRefresh: Bool = false) {
        semesterService.getSemester(semesterId: semesterId, force: force, pullRefresh: pullRefresh){ [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let semester):
                self.semester = semester
                self.lessons = semester.lessons
                self.view?.reloadTimeline(pullRefresh: pullRefresh)
                self.view?.reloadHeader()
            case .failure:
                print("Error loading semester")
            }
        }
    }

}
