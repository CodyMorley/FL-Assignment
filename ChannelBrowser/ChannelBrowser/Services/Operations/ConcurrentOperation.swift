//
//  ConcurrentOperation.swift
//  ChannelBrowser
//
//  Created by Cody Morley on 5/20/21.
//

import Foundation

class ConcurrentOperation: Operation {
    // MARK: Types
    enum State: String {
        case isReady
        case isExecuting
        case isFinished
    }
    
    
    // MARK: Properties
    private var _state = State.isReady
    private let stateQueue = DispatchQueue(label: .queueID)
    var state: State {
        get {
            var result: State?
            let queue = self.stateQueue
            queue.sync {
                result = _state
            }
            return result!
        }
        set {
            let oldValue = state
            willChangeValue(forKey: newValue.rawValue)
            willChangeValue(forKey: oldValue.rawValue)
            
            stateQueue.sync { self._state = newValue }
            
            didChangeValue(forKey: oldValue.rawValue)
            didChangeValue(forKey: newValue.rawValue)
        }
    }
    
    
    // MARK: NSOperation
    override dynamic var isReady: Bool {
        return super.isReady && state == .isReady
    }
    
    override dynamic var isExecuting: Bool {
        return state == .isExecuting
    }
    
    override dynamic var isFinished: Bool {
        return state == .isFinished
    }
    
    override var isAsynchronous: Bool {
        return true
    }
}
