//
//  BreedListResponse.swift
//  GuessMyBreed
//
//  Created by Huong Tran on 6/5/20.
//  Copyright © 2020 RiRiStudio. All rights reserved.
//

import Foundation

// MARK: - BreedListResponse
struct BreedListResponse: Codable {
    let message: [String: [String]]
    let status: String
}
