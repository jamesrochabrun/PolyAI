//
//  LLMMessageStreamResponse.swift
//  
//
//  Created by James Rochabrun on 4/14/24.
//

import Foundation

// MARK: LLMMessageStreamResponse

/// A protocol defining the essential property for a response that streams from an LLM service.
public protocol LLMMessageStreamResponse {
   /// The content of the response, which may be nil if the response does not contain textual data.
   var content: String? { get }
}
