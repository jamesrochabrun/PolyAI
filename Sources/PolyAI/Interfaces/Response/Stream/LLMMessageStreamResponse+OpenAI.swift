//
//  LLMMessageStreamResponse+OpenAI.swift
//
//
//  Created by James Rochabrun on 4/15/24.
//

import Foundation
import SwiftOpenAI

// MARK: OpenAI

extension ChatCompletionChunkObject: LLMMessageStreamResponse {
   
   public var content: String? {
      choices.first?.delta.content
   }
}
