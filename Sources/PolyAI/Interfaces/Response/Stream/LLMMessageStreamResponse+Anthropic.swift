//
//  LLMMessageStreamResponse+Anthropic.swift
//
//
//  Created by James Rochabrun on 4/15/24.
//

import Foundation
import SwiftAnthropic

// MARK: Anthropic

extension MessageStreamResponse: LLMMessageStreamResponse {
   
   public var content: String? {
      delta?.text
   }
}
