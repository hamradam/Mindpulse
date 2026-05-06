//
//  DIManager.swift
//  MindPulse
//
//  Created by Petra Satkova on 20.01.2026.
//
import Foundation

@available(iOS 26.0, *)
final class DIContainer {
    typealias Resolver = () -> Any

    private var resolvers = [String: Resolver]()
    private var cache = [String: Any]()

    static let shared = DIContainer()
    private var factories: [String: () -> Any] = [:]

    init() {
        registerDependencies()
    }

    func register<T, R>(_ type: T.Type, cached: Bool = false, service: @escaping () -> R) {
        let key = String(reflecting: type)
        resolvers[key] = service

        if cached {
            cache[key] = service()
        }
    }
    
    func resolve<T>() -> T {
        let key = String(reflecting: T.self)

        if let cachedService = cache[key] as? T {
            print("🥣 Resolving cached instance of \(T.self).")

            return cachedService
        }

        if let resolver = resolvers[key], let service = resolver() as? T {
            print("🥣 Resolving new instance of \(T.self).")

            return service
        }

        fatalError("🥣 \(key) has not been registered.")
    }
    
    // HeartManager must be a factory, one manager instance per workout
    func registerFactory<T>(_ type: T.Type, factory: @escaping () -> T) {
        factories[String(reflecting: type)] = factory
    }

    func resolveFactory<T>() -> T {
        let key = String(reflecting: T.self)
        guard let factory = factories[key], let instance = factory() as? T else {
            fatalError("No registration for \(T.self)")
        }
        return instance
    }
}

@available(iOS 26.0, *)
extension DIContainer {
    func registerDependencies() {

        register(DataManaging.self, cached: true) {
            DataManager()
        }
        
        registerFactory(HeartRateManaging.self) {
            HeartRateManager()
        }
        
        register(NotificationManaging.self, cached: true) {
            NotificationManager()
        }

        #if os(iOS)
        register(WatchConnecting.self, cached: true) { [unowned self] in
            WatchConnector(dataManager: self.resolve())
        }
        #endif

        #if os(watchOS)
        register(PhoneConnecting.self, cached: true) { [unowned self] in
            PhoneConnector(dataManager: self.resolve(), heartRateManager: self.resolveFactory())
        }
        #endif
    }
}
