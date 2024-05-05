//
//  LLMMessageStreamResponse+Gemini.swift
//  
//
//  Created by James Rochabrun on 5/4/24.
//

import Foundation
import GoogleGenerativeAI

// MARK: Gemini

extension GenerateContentResponse: LLMMessageStreamResponse {
   
   public var content: String? {
      text
   }
}
