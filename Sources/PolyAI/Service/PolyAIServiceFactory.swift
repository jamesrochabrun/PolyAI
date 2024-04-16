//
//  PolyAIServiceFactory.swift
//
//
//  Created by James Rochabrun on 4/6/24.
//

import Foundation

public struct PolyAIServiceFactory {
   
   public static func serviceWith(
      _ configurations: [LLMConfiguration])
      -> PolyAIService
   {
      DefaultPolyAIService(configurations: configurations)
   }
}
