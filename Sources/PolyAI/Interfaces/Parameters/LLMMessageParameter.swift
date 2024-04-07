//
//  LLMMessageParameter.swift
//
//
//  Created by James Rochabrun on 4/6/24.
//

import Foundation

public protocol LLMMessageParameter {
   
   var role: String { get }
   var content: String { get }
}
