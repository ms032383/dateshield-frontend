# 🛡️ DateShield - AI Red Flag Scanner

**DateShield** is an AI-powered safety tool designed to help users identify toxic behavior, scams, and "red flags" in their dating app conversations. Built as part of the **12 Startups in 12 Months** challenge.



## 🚀 Features
* **AI Chat Analysis:** Analyzes screenshots of chats using Tesseract OCR and Generative AI.
* **Toxicity Scoring:** Provides a clear score on how toxic or safe a conversation is.
* **Red Flag Detection:** Specifically looks for manipulative behavior, scams, and aggressive patterns.
* **Suggested Replies:** Provides witty or safe ways to respond to difficult messages.
* **AI Roast:** A touch of humor to lighten the mood while identifying bad dates.

## 🛠️ Tech Stack
* **Frontend:** Flutter (Web/Android/iOS)
* **State Management:** Riverpod
* **Backend:** Python Flask
* **OCR:** Tesseract OCR
* **Deployment:** Vercel (Frontend) & Railway/Render (Backend)

## 📂 Project Structure
```text
lib/
├── models/         # Data models for Scan Results
├── state/          # Riverpod controllers (ScanController)
├── views/          # UI Screens (Home, Result, Scanner)
└── widgets/        # Reusable UI components

hello
