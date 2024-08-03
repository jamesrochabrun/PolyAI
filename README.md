# PolyAI
<img width="1202" alt="dragon" src="https://github.com/jamesrochabrun/PolyAI/assets/5378604/2d8c47f7-eec0-4d15-9d53-55ff21b6775e">

![iOS 15+](https://img.shields.io/badge/iOS-15%2B-blue.svg)
[![MIT license](https://img.shields.io/badge/License-MIT-blue.svg)](https://lbesson.mit-license.org/)
[![swift-version](https://img.shields.io/badge/swift-5.9-brightgreen.svg)](https://github.com/apple/swift)
[![swiftui-version](https://img.shields.io/badge/swiftui-brightgreen)](https://developer.apple.com/documentation/swiftui)
[![xcode-version](https://img.shields.io/badge/xcode-15%20-brightgreen)](https://developer.apple.com/xcode/)
[![swift-package-manager](https://img.shields.io/badge/package%20manager-compatible-brightgreen.svg?logo=data:image/svg+xml;base64,PD94bWwgdmVyc2lvbj0iMS4wIiBlbmNvZGluZz0iVVRGLTgiPz4KPHN2ZyB3aWR0aD0iNjJweCIgaGVpZ2h0PSI0OXB4IiB2aWV3Qm94PSIwIDAgNjIgNDkiIHZlcnNpb249IjEuMSIgeG1sbnM9Imh0dHA6Ly93d3cudzMub3JnLzIwMDAvc3ZnIiB4bWxuczp4bGluaz0iaHR0cDovL3d3dy53My5vcmcvMTk5OS94bGluayI+CiAgICA8IS0tIEdlbmVyYXRvcjogU2tldGNoIDYzLjEgKDkyNDUyKSAtIGh0dHBzOi8vc2tldGNoLmNvbSAtLT4KICAgIDx0aXRsZT5Hcm91cDwvdGl0bGU+CiAgICA8ZGVzYz5DcmVhdGVkIHdpdGggU2tldGNoLjwvZGVzYz4KICAgIDxnIGlkPSJQYWdlLTEiIHN0cm9rZT0ibm9uZSIgc3Ryb2tlLXdpZHRoPSIxIiBmaWxsPSJub25lIiBmaWxsLXJ1bGU9ImV2ZW5vZGQiPgogICAgICAgIDxnIGlkPSJHcm91cCIgZmlsbC1ydWxlPSJub256ZXJvIj4KICAgICAgICAgICAgPHBvbHlnb24gaWQ9IlBhdGgiIGZpbGw9IiNEQkI1NTEiIHBvaW50cz0iNTEuMzEwMzQ0OCAwIDEwLjY4OTY1NTIgMCAwIDEzLjUxNzI0MTQgMCA0OSA2MiA0OSA2MiAxMy41MTcyNDE0Ij48L3BvbHlnb24+CiAgICAgICAgICAgIDxwb2x5Z29uIGlkPSJQYXRoIiBmaWxsPSIjRjdFM0FGIiBwb2ludHM9IjI3IDI1IDMxIDI1IDM1IDI1IDM3IDI1IDM3IDE0IDI1IDE0IDI1IDI1Ij48L3BvbHlnb24+CiAgICAgICAgICAgIDxwb2x5Z29uIGlkPSJQYXRoIiBmaWxsPSIjRUZDNzVFIiBwb2ludHM9IjEwLjY4OTY1NTIgMCAwIDE0IDYyIDE0IDUxLjMxMDM0NDggMCI+PC9wb2x5Z29uPgogICAgICAgICAgICA8cG9seWdvbiBpZD0iUmVjdGFuZ2xlIiBmaWxsPSIjRjdFM0FGIiBwb2ludHM9IjI3IDAgMzUgMCAzNyAxNCAyNSAxNCI+PC9wb2x5Z29uPgogICAgICAgIDwvZz4KICAgIDwvZz4KPC9zdmc+)](https://github.com/apple/swift-package-manager)

An open-source Swift package that simplifies LLM message completions, inspired by [liteLLM](https://litellm.ai/) and adapted for Swift developers, following Swift conventions.

## Description

Call different LLM APIs using the OpenAI format; currently supporting [OpenAI](https://github.com/jamesrochabrun/SwiftOpenAI), [Anthropic](https://github.com/jamesrochabrun/SwiftAnthropic),  [Gemini](https://github.com/google-gemini/generative-ai-swift).

Also call any local model using [Ollama OpenAI compatibility endopints](https://ollama.com/blog/openai-compatibility). You can use models like [llama3](https://ollama.com/library/llama3) or [mistral](https://ollama.com/library/mistral).

## Table of Contents

- [Installation](#installation)
- [Usage](#usage)
- [Message](#message)
- [Collaboration](#collaboration)
- [OpenAI Azure](#openAI-azure)
- [OpenAI AIProxy](#openai-aiproxy)
- [Ollama](#ollama)

## Installation

### Swift Package Manager

1. Open your Swift project in Xcode.
2. Go to `File` ->  `Add Package Dependency`.
3. In the search bar, enter [this URL](https://github.com/jamesrochabrun/PolyAI).
4. Choose the version you'd like to install.
5. Click `Add Package`.

### Important

⚠️  Please take precautions to keep your API keys secure.

> Remember that your API keys are a secret! Do not share it with others or expose
> it in any client-side code (browsers, apps). Production requests must be
> routed through your backend server where your API keys can be securely
> loaded from an environment variable or key management service.

## Functionalities

- [x] Chat completions
- [x] Chat completions with stream
- [ ] Tool use
- [ ] Image as input

## Usage

To interface with different LLMs, you need only to supply the corresponding LLM configuration and adjust the parameters accordingly.

First, import the PolyAI package:

```swift
import PolyAI
```

Then, define the LLM configurations. 
Currently, OpenAI, Anthropic and Gemini are supported, you can also use Ollama or any provider that provides local models with OpenAI endpoint compatibilities to use local models such llama3 or Mistral.

```swift
let openAIConfiguration: LLMConfiguration = .openAI(.api(key: "your_openai_api_key_here"))
let anthropicConfiguration: LLMConfiguration = .anthropic(apiKey: "your_anthropic_api_key_here")
let geminiConfiguration: LLMConfiguration = .gemini(apiKey: "your_gemini_api_key_here")
let ollamaConfiguration: LLMConfiguration = .ollama(url: "http://localhost:11434")

let configurations = [openAIConfiguration, anthropicConfiguration, geminiConfiguration, ollamaConfiguration]
```

With the configurations set, initialize the service:

```swift
let service = PolyAIServiceFactory.serviceWith(configurations)
```

Now, you have access to OpenAI, Anthropic, Gemini, llama3, Mistral models in a single package. 🚀

## Message

To send a message using OpenAI:

```swift
let prompt = "How are you today?"
let parameters: LLMParameter = .openAI(model: .gpt4turbo, messages: [.init(role: .user, content: prompt)])
let stream = try await service.streamMessage(parameters)
```

To interact with Anthropic instead, all you need to do is change just one line of code! 🔥

```swift
let prompt = "How are you today?"
let parameters: LLMParameter = .anthropic(model: .claude3Sonnet, messages: [.init(role: .user, content: prompt)], maxTokens: 1024)
let stream = try await service.streamMessage(parameters)
```

To interact with Gemini instead, all you need to do (again) is change just one line of code! 🔥

```swift
let prompt = "How are you today?"
let parameters: LLMParameter = .gemini(model: ""gemini-1.5-pro-latest", messages: [.init(role: .user, content: prompt)], maxTokens: 2000)
let stream = try await service.streamMessage(parameters)
```

To interact with local models using Ollama, all you need to do(again) is change just one line of code! 🔥

```swift
let prompt = "How are you today?"
let parameters: LLMParameter = .ollama(model: "llama3", messages: [.init(role: .user, content: prompt)], maxTokens: 2000)
let stream = try await service.streamMessage(parameters)
```

## OpenAI Azure

To access the OpenAI API via Azure, you can use the following configuration setup.

```swift
let azureConfiguration: LLMConfiguration = .openAI(.azure(configuration: .init(resourceName: "YOUR_RESOURCE_NAME", openAIAPIKey: .apiKey("YOUR_API_KEY"), apiVersion: "THE_API_VERSION")))
```

More information can be found [here](https://github.com/jamesrochabrun/SwiftOpenAI?tab=readme-ov-file#azure-openai).

## OpenAI AIProxy

To access the OpenAI API via AIProxy, use the following configuration setup.

```swift
let aiProxyConfiguration: LLMConfiguration = .openAI(.aiProxy(aiproxyPartialKey: "hardcode_partial_key_here", aiproxyDeviceCheckBypass: "hardcode_device_check_bypass_here"))
```

More information can be found [here](https://github.com/jamesrochabrun/SwiftOpenAI?tab=readme-ov-file#aiproxy).

### Ollama

To interact with local models using [Ollama OpenAI compatibility endpoints](https://ollama.com/blog/openai-compatibility),  use the following configuration setup.

1 - Download [Ollama](https://ollama.com/) if yo don't have it installed already.
2 - Download the model you need, e.g for `llama3` type in terminal:
```
ollama pull llama3
```

Once you have the model installed locally you are ready to use PolyAI! 

```swift
let ollamaConfiguration: LLMConfiguration = .ollama(url: "http://localhost:11434")
```
More information can be found [here](https://github.com/jamesrochabrun/SwiftOpenAI?tab=readme-ov-file#ollama).

## Collaboration

Open a PR for any proposed change pointing it to `main` branch.
