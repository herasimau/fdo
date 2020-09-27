//
//  NetworkNotifier.swift
//  fdo
//
//  Created by Leanid Herasimau on 18/04/2020.
//  Copyright © 2020 Tusur. All rights reserved.
//

import Foundation

/**
  Network state
 */
public enum NetworkState: String {
    /// Disconected
    case noInternetConnection
    /// Connected
    case connected
}

/**
 Network observable
 */
public protocol NetworkNotifierDelegate: AnyObject {
    /**
     Notify the observers that there is a possible change of state
     - Parameter state:  The new `NetworkState`.
     */
    func didNetworkStateChanged(state: NetworkState)
}

/**
 Network observer notifier
 */
public class NetworkNotifier {

    /// Observers
    private static var observers: [String: NetworkNotifierDelegate] = [:]

    ///Connection disabled by the user
    public static var connectionDisabled: Bool = false

    /// True connection state
    private static var _connectionState: NetworkState = .connected

    /// Read only connection state
    public static var connectionState: NetworkState {
        return NetworkNotifier.connectionDisabled ? .noInternetConnection : _connectionState
    }

    /// Read only online check
    public static var isOnline: Bool {
        return NetworkNotifier.connectionState == .connected
    }

    /**
     Register new observer.
     - Parameter observerType: The observer type.
     - Parameter observer: The observer.
     */
    public static func register<T: NetworkNotifierDelegate>(_ observerType: String, observer: T) {
        observers[observerType] = observer
    }

    /**
     Register new observer.
     - Parameter observerType: The observer type.
     - Parameter observer: The observer.
     */
    public static func register<T: NetworkNotifierDelegate>(_ observerType: Any.Type, observer: T) {
        let className = String(describing: type(of: observerType.self))
        observers[className] = observer
    }

    /**
     Unregister a observer.
     - Parameter observerType: The observer type.
     */
    public static func unregister(_ observerType: String) {
        NetworkNotifier.observers.removeValue(forKey: observerType)
    }

    /**
     Unregister a observer.
     - Parameter observerType: The observer type.
     */
    public static func unregister(_ observerType: Any.Type) {
        let className = String(describing: type(of: observerType.self))
        NetworkNotifier.observers.removeValue(forKey: className)
    }

    /**
     Notify all observers
     - Parameter state: The new `NetworkState`.
     */
    public static func notifyAll(state: NetworkState) {
        for element in NetworkNotifier.observers {
            element.value.didNetworkStateChanged(state: state)
        }
    }

    /**
     Notify the observers that there is a possible change of state
     - Parameter state:  The new `NetworkState`.
     */
    public static func notifyObservers(state: NetworkState) {
        NetworkNotifier._connectionState = state
        NetworkNotifier.notifyAll(state: NetworkNotifier.connectionState)
    }
}
