//
//  MVVM.swift
//  FDO_TUSUR
//
//  Created by Leanid Herasimau on 20/04/2020.
//  Copyright © 2020 Tusur. All rights reserved.
//

import Foundation
import UIKit

protocol ViewBindable {
    associatedtype VIEW: ViewViewModable
    var view: VIEW? { get }

    func bind(view: VIEW)
}

protocol ViewViewModable: UIView {
    associatedtype VMODEL: ViewBindable
    var viewModel: VMODEL? { get set }

    func set(viewModel: VMODEL)
}
extension ViewViewModable where Self: UIView {
    func set<VM>(viewModel: VM) where VM: ViewBindable, VM.VIEW == Self {
        self.viewModel = viewModel as? Self.VMODEL
        viewModel.bind(view: self)
    }
}

class BaseViewBindable<V: ViewViewModable>: ViewBindable {
    weak private(set) var view: V?

    func bind(view: V) {
        self.view = view
    }
}

class BaseViewModel<V: ViewViewModable, M>: BaseViewBindable<V> {
    var model: M
    init(model: M) {
        self.model = model
    }

    final override func bind(view: V) {
        super.bind(view: view)
        bind(view: view, model: model)
    }

    open func bind(view: V, model: M) {}
}
