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

## ScreenShots


<img width="479" height="935" alt="Screenshot_46" src="https://github.com/user-attachments/assets/e85ce9cc-af03-4387-9398-71ea7097a5c0" />
<img width="479" height="933" alt="Screenshot_47" src="https://github.com/user-attachments/assets/6a672f3b-e37c-4c1b-a3a6-4718ff311ba0" />
<img width="478" height="934" alt="Screenshot_48" src="https://github.com/user-attachments/assets/cb6150d5-2daf-4785-99ce-1c0f45e432f0" />
<img width="478" height="934" alt="Screenshot_49" src="https://github.com/user-attachments/assets/7c4b63dc-870e-4bf0-be55-70d9daf5b992" />
<img width="478" height="934" alt="Screenshot_50" src="https://github.com/user-attachments/assets/5fc0d6fd-c134-44b8-9138-89ce268fc14d" />
<img width="478" height="933" alt="Screenshot_51" src="https://github.com/user-attachments/assets/0e4f5706-acb2-4d5c-9b4b-00f7a35565c5" />
<img width="478" height="930" alt="Screenshot_52" src="https://github.com/user-attachments/assets/a3b68e2c-e9ba-49a8-9139-6564f937f452" />
<img width="478" height="933" alt="Screenshot_53" src="https://github.com/user-attachments/assets/b312d2d6-0b03-4860-a7dd-37d6f7fde3c8" />
<img width="478" height="937" alt="Screenshot_54" src="https://github.com/user-attachments/assets/058b6bfb-2709-49a8-9aa0-6d799baa5d7d" />
<img width="476" height="933" alt="Screenshot_55" src="https://github.com/user-attachments/assets/39114c62-07ee-46fc-bb2a-345f1d255536" />
<img width="477" height="931" alt="Screenshot_56" src="https://github.com/user-attachments/assets/54d8f38b-b86f-4152-b00d-3c20e49ee7e2" />
<img width="477" height="934" alt="Screenshot_57" src="https://github.com/user-attachments/assets/0a92d9a5-bf65-4687-9f9b-3800db49afa1" />
<img width="477" height="934" alt="Screenshot_58" src="https://github.com/user-attachments/assets/d00c730b-6494-45a2-8759-52a184c93c0f" />
<img width="479" height="934" alt="Screenshot_59" src="https://github.com/user-attachments/assets/326d3ee0-0ade-4b18-b152-dd326645c5b0" />
<img width="477" height="934" alt="Screenshot_60" src="https://github.com/user-attachments/assets/7655a39c-a9ee-40a7-8c19-b76b783049fe" />
<img width="478" height="935" alt="Screenshot_61" src="https://github.com/user-attachments/assets/e6ab227b-cfb7-4e26-95b1-ecd4a8ec869e" />
<img width="477" height="933" alt="Screenshot_62" src="https://github.com/user-attachments/assets/bd904e01-d104-4869-8fd0-417a999efc5d" />
<img width="477" height="935" alt="Screenshot_63" src="https://github.com/user-attachments/assets/dcbce238-e196-407a-aea7-add8dfc3439a" />
<img width="476" height="935" alt="Screenshot_64" src="https://github.com/user-attachments/assets/792843ee-c467-44fe-980e-83561014fa64" />

