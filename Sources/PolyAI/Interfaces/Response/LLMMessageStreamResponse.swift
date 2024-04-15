//
//  LLMMessageStreamResponse.swift
//  
//
//  Created by James Rochabrun on 4/14/24.
//

import Foundation
import SwiftAnthropic
import SwiftOpenAI

// MARK: Interface

public protocol LLMMessageStreamResponse {
   var content: String? { get }
}

// MARK: OpenAI

extension ChatCompletionChunkObject: LLMMessageStreamResponse {
   
   public var content: String? {
      choices.first?.delta.content
   }
}

// MARK: Anthropic

extension MessageStreamResponse: LLMMessageStreamResponse {
   
   public var content: String? {
      delta?.text
   }
}

