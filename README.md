# Chatty AI

Chatty AI is a modern conversational AI mobile app built with **Flutter**. It integrates with **OpenRouter API** to provide intelligent and interactive chat experiences. The app stores chat history locally using **Hive** and organizes conversations with generated titles.

---

## 🚀 Features

* Chat with AI in real-time (streaming responses).
* Automatic chat title generation.
* Save and view chat history using Hive.
* Delete conversations individually or clear all history.
* Stop response generation manually.
* Clean and modern UI.
* State management handled by **Cubit (flutter_bloc)**.

---

## 📦 Installation

1. Clone the repository:

   ```bash
   git clone https://github.com/your-username/chatty_ai.git
   cd chatty_ai
   ```

2. Install dependencies:

   ```bash
   flutter pub get
   ```

3. Generate Hive models:

   ```bash
   flutter packages pub run build_runner build
   ```

4. Run the app:

   ```bash
   flutter run
   ```

---

## ⚙️ Setup

### Hive Initialization

```dart
await Hive.initFlutter();
Hive.registerAdapter(ConversationAdapter());
await Hive.openBox<Conversation>('conversations');
```

### API Key

Replace the placeholder `OPENROUTER_API_KEY` with your own key from [OpenRouter](https://openrouter.ai/).

> ⚠️ **Important:** Do not hardcode the API key in production. Use secure storage or environment variables.

---

## 🎯 Cubit Integration

* **ChatCubit** → Handles sending messages, receiving streaming responses, and generating titles.
* **HistoryCubit** → Manages conversation history (load, delete, clear all).
* **SearchCubit** → Enables searching through chat history.

---
---

## 🤝 Contributing

Pull requests are welcome. For major changes, please open an issue first to discuss what you’d like to change.

---
