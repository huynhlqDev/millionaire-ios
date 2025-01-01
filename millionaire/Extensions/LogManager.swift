//
//  LogManager.swift
//  millionaire
//
//  Created by huynh on 19/12/24.
//

import Foundation

func debugLog(
    _ message: String,
    file: String = #file,
    function: String = #function,
    line: Int = #line
) {
    let fileName = (file as NSString).lastPathComponent
    let date = DateFormatter.localizedString(from: Date(), dateStyle: .short, timeStyle: .medium)
    print("[\(date)] [\(fileName):\(line)] \(function) - \(message)")
}
