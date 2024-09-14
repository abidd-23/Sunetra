//
//  TimerServiceProtocol.swift
//  Sunetra
//
//  Created by Abid Ali    on 27/05/24.
//

import Foundation
protocol TimerServiceProtocol{
    var delegate: TimerServiceDelegate? { get set }
    var timer: Timer? { get }
    
    func start(intervalSeconds: Double)
    func stop()
    func incrementSpeed(_ incrementSeconds: Double)
}
