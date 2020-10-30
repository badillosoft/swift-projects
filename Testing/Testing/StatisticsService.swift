//
//  StatitisticsService.swift
//  Testing
//
//  Created by Dragon on 30/10/20.
//

import Foundation

class StatisticsService {
    
    static func avg(values: Double...) -> Double {
        var sum = 0.0
        
        for value in values {
            sum += value
        }
        
        return sum / Double(values.count)
    }
    
}
