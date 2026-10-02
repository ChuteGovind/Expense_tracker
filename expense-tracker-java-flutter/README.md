# ExpenseFlow — Personal Finance & Expense Tracker

Portfolio project using **Java Spring Boot + MySQL + Flutter**. The UI follows the clean finance-dashboard idea from the reference image: summary cards, spending chart, trend chart and transaction history.

## What is included
- Spring Boot REST API with JPA/Hibernate and MySQL
- Flutter Material 3 frontend with Riverpod and Dio
- Add / edit / delete income and expense transactions
- Monthly income, expense and balance dashboard
- Category spending breakdown
- Six-month trend
- MySQL schema and optional demo data
- Docker Compose option for MySQL

## Requirements
- JDK 21 (JDK 24 should also work)
- IntelliJ IDEA
- Flutter 3.38+ / Dart 3.10+
- Android Studio + Android SDK/emulator
- MySQL 8 OR Docker Desktop
- VS Code optional for Flutter

## 1. Database
### MySQL installed
Run in MySQL Workbench:
```sql
CREATE DATABASE expense_tracker;
```
Default backend credentials are `root` / `root`. If yours differ, set `DB_USERNAME`, `DB_PASSWORD` and optionally `DB_URL` in the IntelliJ Run Configuration environment.

Spring Boot uses `spring.jpa.hibernate.ddl-auto=update`, so it creates the `transactions` table.

Optional demo records: execute `database/sample-data.sql` after the first backend start.

### Docker
From the project root:
```bash
docker compose up -d
```
This starts MySQL on `localhost:3306`, database `expense_tracker`, root password `root`.

## 2. Backend — IntelliJ
Open the `backend` folder in IntelliJ. Let Maven import the project, select JDK 21, then run:
`src/main/java/com/govind/expensetracker/ExpenseTrackerApplication.java`

API: `http://localhost:8080`
Health: `http://localhost:8080/actuator/health`

Terminal alternative if Maven is installed:
```bash
cd backend
mvn spring-boot:run
```

## 3. Frontend — Android Studio / VS Code
Open `frontend`.

The archive intentionally omits generated Flutter platform folders. Run once:
```bash
cd frontend
flutter create .
flutter pub get
flutter devices
flutter run
```

Start an Android emulator from Android Studio.

### Android HTTP permission
Because this local project uses `http://` during development, open `frontend/android/app/src/main/AndroidManifest.xml` after `flutter create .` and add this attribute to the `<application>` tag:

```xml
android:usesCleartextTraffic="true"
```

Also make sure this permission exists directly under `<manifest>`:

```xml
<uses-permission android:name="android.permission.INTERNET" />
```

### API URL
Android Emulator uses:
```text
http://10.0.2.2:8080/api/v1
```
For Windows/Desktop change `frontend/lib/core/constants/api_constants.dart` to:
```dart
static const String baseUrl = 'http://localhost:8080/api/v1';
```
For a physical phone, use the PC's LAN IPv4 address, e.g. `http://192.168.1.10:8080/api/v1`, and allow port 8080 through Windows Firewall.

## 4. API endpoints
| Method | Endpoint | Purpose |
|---|---|---|
| GET | `/api/v1/transactions` | List transactions |
| GET | `/api/v1/transactions/{id}` | Get one |
| POST | `/api/v1/transactions` | Create |
| PUT | `/api/v1/transactions/{id}` | Update |
| DELETE | `/api/v1/transactions/{id}` | Delete |
| GET | `/api/v1/transactions/meta/categories` | Categories |
| GET | `/api/v1/dashboard?month=YYYY-MM` | Dashboard |

Example POST:
```json
{
  "type": "EXPENSE",
  "category": "Food",
  "title": "Groceries",
  "amount": 1500.00,
  "transactionDate": "2026-09-27",
  "note": "Weekly groceries"
}
```

## Architecture
```text
Flutter UI → Riverpod → Dio → Spring REST Controller → Service → JPA/Hibernate → MySQL
```

## Suggested portfolio upgrades
JWT authentication and per-user data, budgets, recurring transactions, search/date filters, CSV/PDF export, dark mode, notifications, Dockerized deployment, AWS RDS/EC2.
