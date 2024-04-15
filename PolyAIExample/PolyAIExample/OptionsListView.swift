//
//  OptionsListView.swift
//  PolyAIExample
//
//  Created by James Rochabrun on 4/14/24.
//

import SwiftUI
import PolyAI

import SwiftUI

struct OptionsListView: View {
   
   let service: PolyAIService
   
   @State private var selection: APIOption? = nil
   
   /// https://docs.anthropic.com/claude/reference/getting-started-with-the-api
   enum APIOption: String, CaseIterable, Identifiable {
      
      case message = "Message"
      var id: String { rawValue }
   }

   var body: some View {
      List(APIOption.allCases, id: \.self, selection: $selection) { option in
         Text(option.rawValue)
            .sheet(item: $selection) { selection in
               VStack {
                  Text(selection.rawValue)
                     .font(.largeTitle)
                     .padding()
                  switch selection {
                  case .message:
                     MessageDemoView(observable: .init(service: service))
                  }
               }
            }
      }
   }
}
