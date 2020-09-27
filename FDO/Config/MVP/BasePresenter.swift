//
//  BasePresenter.swift
//  FDO_TUSUR
//
//  Created by Leanid Herasimau on 20/04/2020.
//  Copyright © 2020 Tusur. All rights reserved.
//

import Foundation

public protocol Presenter: AnyObject {
    associatedtype View
    associatedtype Param

    var view: View! { get set }
    var param: Param { get set }

    func start() -> View
    func setup()

    init(param: Param)
}

public extension Presenter where View: Presentable {
    func start() -> View {
        guard let presenter = self as? View.PRS else {
            fatalError("define a Presenter class in the view declaration")
        }

        let rootView = View(presenter: presenter)
        view = rootView
        setup()
        return rootView
    }
}

open class BasePresenter<V: Presentable, P>: Presenter {
    public weak var view: V!
    public var param: P

    public required init(param: P) {
        self.param = param
    }

    open func setup() {}
}

public extension BasePresenter where P == Void {

    convenience init() {
        self.init(param: Void())
    }
}
