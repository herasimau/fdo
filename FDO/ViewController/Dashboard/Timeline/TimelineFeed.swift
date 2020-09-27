//
//  TimelineFeed.swift
//  FDO_TUSUR
//
//  Created by Leanid Herasimau on 20/04/2020.
//  Copyright © 2020 Tusur. All rights reserved.
//

import UIKit

public protocol TimelineFeedDataSource {
    func numberOfCards(in timelineFeed: TimelineFeed) -> Int
    func card(at index: Int, in timelineFeed: TimelineFeed) -> TimelineCard
    func elementsForTimelineCard(at index: Int, containerWidth: CGFloat) -> [TimelineSourceElement]
    func titleAndSubtitle(at index: Int, in timelineFeed: TimelineFeed) -> (NSAttributedString, NSAttributedString?)?
    func headerViewForCard(at index: Int, in timelineFeed: TimelineFeed) -> UIView?
}

public extension TimelineFeedDataSource {
    func titleAndSubtitle(at index: Int, in timelineFeed: TimelineFeed) -> (NSAttributedString, NSAttributedString?)? {
        return nil
    }
    
    func headerViewForCard(at index: Int, in timelineFeed: TimelineFeed) -> UIView? {
        return nil
    }
}

public protocol TimelineFeedDelegate {
    func refreshTimeline()
    func didSelectElement(at index: Int, timelineCardIndex: Int)
    func didSelectSubElement(at index: (Int, Int), timelineCardIndex: Int)
    func didTouchHeaderView(_ headerView: UIView, timelineCardIndex: Int)
    func didTouchFooterView(_ footerView: UIView, timelineCardIndex: Int)
}

public extension TimelineFeedDelegate {
    func didTouchHeaderView(_ headerView: UIView, timelineCardIndex: Int) { }
    func didTouchFooterView(_ footerView: UIView, timelineCardIndex: Int) { }
}

fileprivate class SimpleTimelineItemHeader: UIView {
    static let defaultHeight: CGFloat = 60.0
    static let defaultPadding: CGFloat = 10.0

    var titleLabel: UILabel!
    var subtitleLabel: UILabel!

    init(frame: CGRect, title: NSAttributedString, subtitle: NSAttributedString? = nil) {
        super.init(frame: frame)
        backgroundColor = .clear
        self.translatesAutoresizingMaskIntoConstraints = false
        let titlesContainer = UIView(frame: CGRect(x: 0, y: 0, width: bounds.width, height: bounds.height - SimpleTimelineItemHeader.defaultPadding))
        titlesContainer.backgroundColor = .clear
        addSubview(titlesContainer)
        let titleHeight: CGFloat = subtitle != nil ? titlesContainer.bounds.height / 2 : titlesContainer.bounds.height
        titleLabel = UILabel(frame: CGRect(x: 0, y: 0, width: titlesContainer.bounds.width, height: titleHeight))
        titleLabel.attributedText = title
        titlesContainer.addSubview(titleLabel)
        if let subtitle = subtitle {
            subtitleLabel = UILabel(frame: CGRect(x: 0, y: titlesContainer.bounds.height / 2, width: titlesContainer.bounds.width, height: titlesContainer.bounds.height / 2))
            subtitleLabel.attributedText = subtitle
            titlesContainer.addSubview(subtitleLabel)
        }
    }

    convenience init(width: CGFloat, title: NSAttributedString, subtitle: NSAttributedString) {
        self.init(frame: CGRect.init(x: 0, y: 0, width: width, height: SimpleTimelineItemHeader.defaultHeight + SimpleTimelineItemHeader.defaultPadding), title: title, subtitle: subtitle)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

fileprivate class TimelineFeedCell: UITableViewCell {
    private(set) var headerView: UIView? = nil
    var card: TimelineCard? = nil

    var bottomPadding: CGFloat = 0.0 {
        didSet {
            guard card != nil else { return }
            
            constraints.forEach {
                if $0.secondItem is TimelineCard, $0.secondAttribute == .bottom {
                    $0.constant = bottomPadding
                    
                    setNeedsLayout()
                }
            }
        }
    }

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        initState()
        
        clipsToBounds = true
        cleanUp()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        initState()
        
        clipsToBounds = true
        cleanUp()
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        cleanUp()
    }

    private func initState() {
        backgroundColor = .clear
        selectionStyle = .none
        separatorInset = UIEdgeInsets(top: 0, left: CGFloat.greatestFiniteMagnitude, bottom: 0, right: 0)
    }

    private func cleanUp() {
        self.constraints.forEach { removeConstraint($0) }
        self.subviews.forEach { $0.removeFromSuperview() }
        
        headerView = nil
        card = nil
        
        bottomPadding = 0.0
    }

    private func setUp(card: TimelineCard, headerStrings: (NSAttributedString, NSAttributedString?)?, customHeaderView: UIView?) {
        
        if let customHeader = customHeaderView {
            headerView = customHeader
        } else if let title = headerStrings?.0 {
            headerView = SimpleTimelineItemHeader(width: bounds.width,
                                                  title: title, subtitle: headerStrings?.1 ?? NSAttributedString(string: ""))
        }
        
        if let headerView = headerView { addHeader(headerView) }
        
        addCard(card)
        
        contentView.setNeedsLayout()
    }
    
    func setUp(customHeaderView: UIView,
               card: TimelineCard) {
        
        setUp(card: card, headerStrings: nil, customHeaderView: customHeaderView)
    }
    
    func setUp(title: NSAttributedString, subtitle: NSAttributedString? = nil, card: TimelineCard) {
        setUp(card: card, headerStrings: (title, subtitle), customHeaderView: nil)
    }
    
    func setUp(card: TimelineCard) {
        setUp(card: card, headerStrings: nil, customHeaderView: nil)
    }

    private func addHeader(_ header: UIView) {
        header.frame = CGRect(origin: .zero, size: header.bounds.size)
        self.addSubview(header)
        
        let constraints: [NSLayoutConstraint] = [
            NSLayoutConstraint(item: self, attribute: .top, relatedBy: .equal, toItem: header, attribute: .top, multiplier: 1, constant: 0),
            NSLayoutConstraint(item: self, attribute: .leading, relatedBy: .equal, toItem: header, attribute: .leading, multiplier: 1, constant: 0),
            NSLayoutConstraint(item: self, attribute: .trailing, relatedBy: .equal, toItem: header, attribute: .trailing, multiplier: 1, constant: 0),
            NSLayoutConstraint(item: header, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: header.bounds.height)
        ]
        
        constraints.forEach { $0.isActive = true }
    }
    
    private func addCard(_ card: TimelineCard) {
        self.card = card
        
        card.reload()
        
        card.frame = CGRect(origin: CGPoint(x: 0.0, y: (headerView?.frame.origin.y ?? 0.0) + (headerView?.frame.height ?? 0.0)), size: card.bounds.size)
        
        self.insertSubview(card, at: subviews.count)
        
        let constraints: [NSLayoutConstraint] = [
            NSLayoutConstraint(item: headerView ?? self, attribute: headerView != nil ? .bottom : .top, relatedBy: .equal, toItem: card, attribute: .top, multiplier: 1, constant: 0),
            NSLayoutConstraint(item: self, attribute: .leading, relatedBy: .equal, toItem: card, attribute: .leading, multiplier: 1, constant: 0),
            NSLayoutConstraint(item: self, attribute: .trailing, relatedBy: .equal, toItem: card, attribute: .trailing, multiplier: 1, constant: 0),
            NSLayoutConstraint(item: self, attribute: .bottom, relatedBy: .equal, toItem: card, attribute: .bottom, multiplier: 1, constant: bottomPadding),
            NSLayoutConstraint(item: card, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: card.bounds.size.height)
        ]
        
        constraints.forEach { $0.isActive = true }
    }
}

public class TimelineFeed: UIView, UITableViewDataSource, UITableViewDelegate, TimelineCardEventsHandler {

    public var cardsContainer = UITableView()
    public var refreshControl = UIRefreshControl()

    override public var frame: CGRect {
        didSet {
            cardsContainer.frame = bounds
            cardsContainer.estimatedRowHeight = frame.height
            
            if oldValue == .zero {
                cardsContainer.backgroundColor = .clear
            }
        }
    }

    public var paddingBetweenCards: CGFloat = 20.0 {
        didSet {
            reloadData()
        }
    }

    public var topMargin: CGFloat = 80.0 {
          didSet {
              if cardsContainer.tableHeaderView == nil {
                  cardsContainer.tableHeaderView = UIView()
                  cardsContainer.tableHeaderView?.backgroundColor = .clear
              }
              
              cardsContainer.tableHeaderView?.frame = CGRect(x: 0, y: 0, width: 0, height: topMargin)
          }
      }

    public var bottomMargin: CGFloat = 250.0 {
        didSet {
            if cardsContainer.tableFooterView == nil {
                cardsContainer.tableFooterView = UIView()
                cardsContainer.tableFooterView?.backgroundColor = .clear
            }
            
            cardsContainer.tableFooterView?.frame = CGRect(x: 0, y: 0, width: 0, height: bottomMargin)
        }
    }

    public var dataSource: TimelineFeedDataSource? = nil

    public var delegate: TimelineFeedDelegate? = nil

    init() {
        super.init(frame: .zero)
        setUpCardsContainer()
    }
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        setUpCardsContainer()
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setUpCardsContainer() {
        backgroundColor = .clear
        
        cardsContainer.frame = bounds
        cardsContainer.backgroundColor = .clear
        cardsContainer.rowHeight = UITableView.automaticDimension
        cardsContainer.estimatedRowHeight = frame.height
        
        cardsContainer.dataSource = self
        cardsContainer.delegate = self
        
        cardsContainer.register(TimelineFeedCell.self, forCellReuseIdentifier: String(describing: TimelineFeedCell.self))
        cardsContainer.showsVerticalScrollIndicator = false
        
        topMargin = CGFloat(topMargin)
        bottomMargin = CGFloat(bottomMargin)
        refreshControl.addTarget(self, action: #selector(self.refresSemester(_:)), for: .valueChanged)
        refreshControl.bounds = CGRect(x: -15, y: 70, width: refreshControl.bounds.size.width, height: refreshControl.bounds.size.height)
        cardsContainer.addSubview(refreshControl)

        addSubview(cardsContainer)
    }

    @objc private func refresSemester(_ sender: Any) {
        self.delegate?.refreshTimeline()
    }

    override public func willMove(toSuperview newSuperview: UIView?) {
        super.willMove(toSuperview: newSuperview)
    }

    public func reloadData() {
        guard let _ = dataSource else { return }
        cardsContainer.reloadData()
    }

    public func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let dataSource = dataSource else { return 0 }
        return Int(dataSource.numberOfCards(in: self))
    }

    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: TimelineFeedCell.self), for: indexPath) as! TimelineFeedCell
        
        guard let dataSource = dataSource else { return cell }
        
        if indexPath.row < Int(dataSource.numberOfCards(in: self) - 1) {
            cell.bottomPadding = paddingBetweenCards
        } else {
            cell.bottomPadding = 0.0
        }
        
        let card = dataSource.card(at: Int(indexPath.row), in: self)
        card.source = dataSource.elementsForTimelineCard(at: Int(indexPath.row), containerWidth: card.descriptionContentWidthLimit)
        
        card.eventsHandler = self
        
        if let customHeader = dataSource.headerViewForCard(at: Int(indexPath.row), in: self) {
            cell.setUp(customHeaderView: customHeader, card: card)
        } else if let headerInfo = dataSource.titleAndSubtitle(at: Int(indexPath.row), in: self) {
            cell.setUp(title: headerInfo.0, subtitle: headerInfo.1, card: card)
        } else {
            cell.setUp(card: card)
        }
        
        return cell
    }

    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: false)
    }

    public func didSelectElement(at index: Int, in timelineCard: TimelineCard) {
        guard let cell = (cardsContainer.visibleCells as? [TimelineFeedCell])?.compactMap({ return $0.card == timelineCard ? $0 : nil }).first, let cardIndex = cardsContainer.indexPath(for: cell)?.row else { return }
        
        delegate?.didSelectElement(at: index, timelineCardIndex: cardIndex)
    }
    
    public func didSelectSubElement(at index: (Int, Int), in timelineCard: TimelineCard) {
        guard let cell = (cardsContainer.visibleCells as? [TimelineFeedCell])?.compactMap({ return $0.card == timelineCard ? $0 : nil }).first, let cardIndex = cardsContainer.indexPath(for: cell)?.row else { return }
        
        delegate?.didSelectSubElement(at: index, timelineCardIndex: cardIndex)
    }
    
    public func didTouchHeaderView(_ headerView: UIView, in timelineCard: TimelineCard) {
        guard let cell = (cardsContainer.visibleCells as? [TimelineFeedCell])?.compactMap({ return $0.card == timelineCard ? $0 : nil }).first, let cardIndex = cardsContainer.indexPath(for: cell)?.row else { return }
        
        delegate?.didTouchHeaderView(headerView, timelineCardIndex: cardIndex)
    }
    
    public func didTouchFooterView(_ footerView: UIView, in timelineCard: TimelineCard) {
        guard let cell = (cardsContainer.visibleCells as? [TimelineFeedCell])?.compactMap({ return $0.card == timelineCard ? $0 : nil }).first, let cardIndex = cardsContainer.indexPath(for: cell)?.row else { return }
        
        delegate?.didTouchFooterView(footerView, timelineCardIndex: cardIndex)
    }
}
