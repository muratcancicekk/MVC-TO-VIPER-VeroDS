//
//  HomeEntities.swift
//  VeroDS
//
//  Created by Murat Çiçek on 27.06.2023.
//

import Foundation

final class HomeEntities {
    
    struct Response: Codable {
        let BusinessUnitKey: String?
        let businessUnit: String?
        let colorCode: String?
        let description: String?
        let parentTaskID: String?
        let preplanningBoardQuickSelect: String?
        let task: String?
        let title: String?
        let wageType: String?
        let workingTime: String?
    }
    
}
