//
//  DependencyInjection.swift
//  FDO_TUSUR
//
//  Created by Leanid Herasimau on 18/04/2020.
//  Copyright © 2020 Tusur. All rights reserved.
//

import UIKit

public protocol Component { }

public protocol Repository: Component { }

public protocol Service: Component { }

public class DIContainer: NSObject {

    private static var components: [String: Component] = [:]

    public static func register<T: Component>(_ componentType: String, component: T) {
        components[componentType] = component
    }

    public static func register<T: Component>(_ componentType: Any.Type, component: T) {
        let className = String(describing: type(of: componentType.self))
        components[className] = component
    }

    public static func inject<T>() -> T {
        let className = String(describing: type(of: T.self))
        if let component = components[className], let tComponent = component as? T {
            return tComponent
        }
        fatalError("Missing component \(className)")
    }

    public static func inject<T>(_ componentType: String) -> T {
        if let component = components[componentType], let tComponent = component as? T {
            return tComponent
        }
        fatalError("Missing component \(componentType)")
    }

    public static func inject<T>(_ componentType: Any.Type) -> T {
        let className = String(describing: type(of: componentType.self))
        if let component = components[className], let tComponent = component as? T {
            return tComponent
        }
        fatalError("Missing component \(className)")
    }

}
