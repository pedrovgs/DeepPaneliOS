//
//  Performance.swift
//  DeepPanelSample
//
//  Created by Pedro Gómez on 12/10/2020.
//  Copyright © 2020 Pedro Gómez. All rights reserved.
//

import Foundation

func measureExecutionTime<T>(block: () -> T) -> (Int, T) {
    let start = DispatchTime.now()
    let result = block()
    let end = DispatchTime.now()
    let diffInNanos = end.uptimeNanoseconds - start.uptimeNanoseconds
    let diffInMillis = Int(diffInNanos) / 1_000_000
    return (diffInMillis, result)
}
