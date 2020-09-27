//
//  BaseViewController.swift
//  FDO_TUSUR
//
//  Created by Leanid Herasimau on 20/04/2020.
//  Copyright © 2020 Tusur. All rights reserved.
//

import UIKit

public protocol Presentable: AnyObject {
    associatedtype PRS

    var presenter: PRS { get }

    init(presenter: PRS)
}

open class BaseViewController<P>: UIViewController, Presentable {
    public var presenter: P

    override open var nibBundle: Bundle? { return Bundle(for: type(of: self)) }

    public required init(presenter: P) {
        self.presenter = presenter
        super.init(nibName: nil, bundle: nil)
    }

    @available(*, unavailable)
    public required init?(coder aDecoder: NSCoder) {
        fatalError("don't use initWithCoder, use init(presenter:)")
    }

    override open func viewDidLoad() {
        super.viewDidLoad()

        setupLayout()
        setupTheme()
        setupLabels()
    }

    open func setupLayout() {}
    open func setupTheme() {}
    open func setupLabels() {}
}
