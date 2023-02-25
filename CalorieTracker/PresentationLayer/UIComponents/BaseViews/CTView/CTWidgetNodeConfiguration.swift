//
//  CTViewConfiguration.swift
//  CalorieTracker
//
//  Created by Vladimir Banushkin on 18.07.2022.
//

import UIKit

struct CTWidgetNodeConfiguration: CustomStringConvertible {
    var description: String {
        return """
    Current view has:
        - height: \(height),
        - suggestedTopSafeAreaOffset: \(suggestedTopSafeAreaOffset),
        - suggestedInterItemSpacing: - \(suggestedInterItemSpacing),
        - suggestedSidesInset: - \(suggestedSideInset)
    """
    }
    
    enum CTWidgetViewConfigurationType {
        case widget, large, compact, custom
    }
    
    // MARK: - Private properties
    private var _suggestedTopSafeAreaOffset: CGFloat = 2
    private var _suggestedInterItemSpacing: CGFloat = 10
    private var _height: CGFloat = 0
    private var _suggestedSideInset: CGFloat = 0
    private var _tabBarHeight: CGFloat = 64
    private var type: CTWidgetViewConfigurationType = .widget
    
    // MARK: - Public properties
    
    /// Константа для констрейта высоты, применяется самостоятельно.
    var height: CGFloat {
        switch UIDevice.screenType {
            
        case .h19x414:
            switch type {
            case .widget:
                return 218
            case .large:
                return 112
            case .compact:
                return 64
            case .custom:
                return _height
            }
            
        case .h19x428:
            switch type {
            case .widget:
                return 218
            case .large:
                return 112
            case .compact:
                return 64
            case .custom:
                return _height
            }
            
        case .h19x375:
            switch type {
            case .widget:
                return 200
            case .large:
                return 100
            case .compact:
                return 58
            case .custom:
                return _height
            }
            
        case .h19x390:
            switch type {
            case .widget:
                return 200
            case .large:
                return 100
            case .compact:
                return 64
            case .custom:
                return _height
            }
            
        case .h16x414:
            switch type {
            case .widget:
                return 218
            case .large:
                return 112
            case .compact:
                return 64
            case .custom:
                return _height
            }
            
        case .h16x375:
            switch type {
            case .widget:
                return 200
            case .large:
                return 100
            case .compact:
                return 58
            case .custom:
                return _height
            }
            
        case .unknown:
            switch type {
            case .widget:
                return 200
            case .large:
                return 100
            case .compact:
                return 58
            case .custom:
                return _height
            }
        case .h19x430:
            switch type {
            case .widget:
                return 218
            case .large:
                return 112
            case .compact:
                return 64
            case .custom:
                return _height
            }
        case .h19x393:
            switch type {
            case .widget:
                return 200
            case .large:
                return 100
            case .compact:
                return 64
            case .custom:
                return _height
            }
        }
    }
    
    /// Константа нужна лишь для крепления элемента к верхним границам.
    var suggestedTopSafeAreaOffset: CGFloat {
        switch UIDevice.screenType {
        case .h19x414:
            return 2
        case .h19x428:
            return 8
        case .h19x375:
            return 2
        case .h19x390:
            return 4
        case .h16x414:
            return 2
        case .h16x375:
            return 2
        case .unknown:
            return _suggestedTopSafeAreaOffset
        case .h19x430:
            return 8
        case .h19x393:
            return 8
        }
    }
    
    /// Константа расстояния между элементами
    var suggestedInterItemSpacing: CGFloat {
        switch UIDevice.screenType {
        case .h19x414:
            return 12
        case .h19x428:
            return 16
        case .h19x375:
            return 10
        case .h19x390:
            return 12
        case .h16x414:
            return 12
        case .h16x375:
            return 10
        case .unknown:
            return _suggestedInterItemSpacing
        case .h19x430:
            return 18
        case .h19x393:
            return 12
        }
    }
    
    /// Константа предполагаемых отступов от leading/trailing якорей
    var suggestedSideInset: CGFloat {
        switch UIDevice.screenType {
        case .h19x414:
            return 20
        case .h19x428:
            return 20
        case .h19x375:
            return 18
        case .h19x390:
            return 18
        case .h16x414:
            return 20
        case .h16x375:
            return 18
        case .unknown:
            return 18
        case .h19x430:
            return 20
        case .h19x393:
            return 20
        }
    }
    
    /// Константа верхнего отступа safeAria
    var safeAreaTopInset: CGFloat {
        switch UIDevice.screenType {
        case .h19x414:
            return 44
        case .h19x428:
            return 44
        case .h19x375:
            return 44
        case .h19x390:
            return 44
        case .h16x414:
            return 30
        case .h16x375:
            return 30
        case .unknown:
            return 30
        case .h19x430:
            return 44
        case .h19x393:
            return 44
        }
    }
    
    var tabBarHeight: CGFloat {
        _tabBarHeight
    }
    
    init(type: CTWidgetViewConfigurationType = .widget) {
        self.type = type
    }
    
    mutating func setCustomTopOffset(_ offset: CGFloat) {
        precondition(type == .custom, "To set custom constants you view must be of type 'custom' ")
        _suggestedTopSafeAreaOffset = offset
    }
    
    mutating func setCustomSideInset(_ inset: CGFloat) {
        precondition(type == .custom, "To set custom constants you view must be of type 'custom' ")
        _suggestedSideInset = inset
    }
    
    mutating func setCustomInterItemSpacing(_ spacing: CGFloat) {
        precondition(type == .custom, "To set custom constants you view must be of type 'custom' ")
        _suggestedInterItemSpacing = spacing
    }
}
