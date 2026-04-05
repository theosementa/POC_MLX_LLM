# POC — On-Device LLM with MLX on Apple Silicon

> ⚠️ **This is a Proof of Concept.** It is not intended for production use, but to explore and demonstrate the capabilities of running Large Language Models locally on Apple devices using the [MLX](https://github.com/ml-explore/mlx) framework.

---

## What is this?

**POC_MLX** is a native iOS/macOS chat application that runs LLMs **entirely on-device**, with no internet connection required. It leverages Apple's [MLX](https://github.com/ml-explore/mlx) machine learning framework to perform inference on Apple Silicon chips (M-series / A-series) efficiently.

---

## What does this repo provide?

### `ArtificialIntelligence` module
A standalone Swift Package that encapsulates all the AI logic:

- **`LLMService`** — Core service managing model loading, KV cache, streaming generation, and GPU memory
- **`ModelOption`** — Enum listing the supported models with their registry configurations
- **`ChatMessage`** — Data model representing a message in a conversation (role, content, timestamp)
- **`LLMOutput`** — Wrapper around the model's raw output with trimming utilities
- **`LLMError`** — Error handling, including a simulator guard (MLX requires a real device)

### Main app
A SwiftUI chat interface demonstrating the module in action:

- Model selection before loading
- Real-time streaming responses (token by token)
- Conversation history management
- Performance metrics (tokens/sec, KV cache size)
- Session clear with cache reset

---

## Requirements

- Xcode 16+
- Swift 6.0
- iOS 17+ or macOS 14+
- **A real Apple Silicon device** (simulator is not supported by MLX)
- The `com.apple.developer.kernel.increased-memory-limit` entitlement is required to load large models in memory

---

## Tech Stack

- **SwiftUI** — UI layer
- **Swift Concurrency** (async/await) — Streaming pipeline
- **MLX / MLX-Swift** — On-device inference engine
- **MLX-Swift-LM** — Pre-built model configurations

---

## Getting Started

1. Clone the repo
2. Open `POC_MLX.xcodeproj` in Xcode
3. Select a real device as the build target
4. Build & run
5. Select a model, tap **Load**, and start chatting

---

*Handmade by Théo Sementa — [@theosementa](https://x.com/theosementa)*
