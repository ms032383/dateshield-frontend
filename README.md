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

lib/
├── models/         # Data models for Scan Results
├── state/          # Riverpod controllers (ScanController)
├── views/          # UI Screens (Home, Result, Scanner)
└── widgets/        # Reusable UI components
⚙️ Setup & Installation
Prerequisites
Flutter SDK installed

Backend server running (see [Backend Repo URL])

Installation
Clone the repository:

Bash
git clone [https://github.com/ms032383/datashield-frontend.git](https://github.com/ms032383/datashield-frontend.git)
Install dependencies:

Bash
flutter pub get
Update the baseUrl in lib/state/scan_controller.dart to your live backend URL.

Run the app:

Bash
flutter run -d chrome
🌐 Live Demo
Check out the live version here: [Your Vercel Link Here]

👤 Author
Mohan

GitHub: @ms032383

Portfolio: Portfolio Link

Developed as part of the "12 Startups in 12 Months" Challenge. 🚀


---

### 🚩 Kuch Zaroori Tips:
* **Screenshots:** Is file mein jahan `[Image of...]` likha hai, wahan apne app ka ek mast screenshot ya GIF dalna mat bhulna, isse log impress hote hain.
* **Live Link:** Jab Vercel par deployment successful ho jaye (wo `build/web` wala fix karke), toh wahan apna link zaroor update kar dena.

**Bhai, kya aapka build folder GitHub par push ho gaya?** Ek baar wo confirm ho j
