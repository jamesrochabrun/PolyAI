//
//  PolyAIServiceFactory.swift
//
//
//  Created by James Rochabrun on 4/6/24.
//

import Foundation

public struct PolyAIServiceFactory {
   
   public static func serviceWith(
      _ configurations: [LLMConfiguration],
      debugEnabled: Bool = false)
      -> PolyAIService
   {
      DefaultPolyAIService(configurations: configurations, debugEnabled: debugEnabled)
   }
}
