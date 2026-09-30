# Mumma's Tailor Hub — Flutter App

A Flutter rebuild of the tailor shop web app, with:
- Dashboard (pending orders, ready-to-deliver, dues at a glance)
- Customers list — **Add Customer is the ➕ icon top-right, or "Add Your First Customer" button**
- New Order screen — customer dropdown **with its own quick ➕ add-customer button**, garment picker, per-garment measurement fields (same fields as your web app, in Hindi + English)
- Orders list with status tracker (Pending → Cutting → Sewing → Ready → Completed)
- **Chats tab** — real WhatsApp-style chat screen per customer, backed by Firestore, updates live

## Before you run it — one-time setup (about 15 minutes)

You need three things installed on your laptop: **Flutter SDK**, **Android Studio** (for an emulator, or just plug in your phone), and a **free Firebase project**.

### Step 1 — Install Flutter
Follow: https://docs.flutter.dev/get-started/install (pick Windows/Mac based on your laptop).
Then check it worked:
```
flutter doctor
```

### Step 2 — Open this project
```
cd mummas_tailor_hub
flutter pub get
```

### Step 3 — Connect Firebase (this is your "backend")
1. Go to https://console.firebase.google.com → **Add project** → name it anything (e.g. "mummas-tailor-hub") → create it (free "Spark" plan is enough).
2. In the project, go to **Build → Firestore Database → Create database** → start in **test mode** (you can lock it down later).
3. Install the FlutterFire CLI (one time):
   ```
   dart pub global activate flutterfire_cli
   ```
4. From inside the `mummas_tailor_hub` folder, run:
   ```
   flutterfire configure
   ```
   Pick your Firebase project when it asks, select Android (and iOS if you have a Mac). This **automatically overwrites** `lib/firebase_options.dart` with your real project's keys — you don't need to type anything by hand.

### Step 4 — Run it
Plug in an Android phone (with USB debugging on) or start an emulator, then:
```
flutter run
```

## Where things live in the code
| What you want to change | File |
|---|---|
| Add/edit a customer | `lib/screens/customers_screen.dart` |
| The chat screen | `lib/screens/chat_screen.dart` |
| Chat list (all customers) | `lib/screens/chat_list_screen.dart` |
| New order form + measurements | `lib/screens/new_order_screen.dart` |
| Garment measurement fields | `lib/data/measurement_templates.dart` |
| Colors / fonts | `lib/theme/app_theme.dart` |

## Notes
- Since it's just your mumma using it (as the shop owner), there's no login screen — it opens straight to the Dashboard. If you ever want customers to have their own app and reply to chats themselves, that's a separate build (a second, customer-facing app) — just ask when you're ready for that.
- The "Firestore test mode" from Step 3 is open to anyone for 30 days by default — fine while building, but before giving this to Mumma for real, come back and ask me to help lock down the Firestore security rules.
