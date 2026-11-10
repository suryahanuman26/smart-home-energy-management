# ⚡ Smart Home Energy Management System

A production-grade, sustainable smart home energy monitoring and optimization application built with **Flutter**, **Provider**, and **fl_chart**. Designed with a premium **Dark Navy**, **Crisp White**, and **Electric Green** interface, the application empowers homeowners to actively track power loads, toggle smart appliances, monitor real-time electricity bills in Indian Rupees (₹), and directly advance the **United Nations Sustainable Development Goals (SDG 7, 12, and 13)**.

---

## 📋 Table of Contents
1. [Overview & Objectives](#-overview--objectives)
2. [UN SDG Integration](#-un-sdg-integration)
3. [Core Features by Screen](#-core-features-by-screen)
4. [Mathematical Formulation & Calculations](#-mathematical-formulation--calculations)
5. [Architecture & Folder Structure](#-architecture--folder-structure)
6. [State Management (Provider)](#-state-management-provider)
7. [Appliance Specifications & Demo Data Matrix](#-appliance-specifications--demo-data-matrix)
8. [Design System & Theme](#-design-system--theme)
9. [Installation & Setup](#-installation--setup)
10. [Execution & Build Commands](#-execution--build-commands)
11. [Automated Testing Suite](#-automated-testing-suite)
12. [Hardware Integration Disclaimer](#-hardware-integration-disclaimer)

---

## 🎯 Overview & Objectives

Household electricity consumption frequently suffers from opacity, unmanaged standby phantom loads, and simultaneous peak-demand spikes that strain regional utility grids and increase carbon footprints. 

The **Smart Home Energy Management System** provides:
- **Instant Load Transparency:** Real-time visibility into instantaneous wattage and daily unit (kWh) consumption.
- **Direct Remote Actuation:** Seamless ON/OFF appliance switching with immediate state reflection.
- **Predictive Billing Analytics:** Real-time billing projections in ₹ based on configurable electricity tariffs.
- **Consumption Attribution:** Breakdown of consumption by room, category, and appliance share.
- **Intelligent Grid Insights:** Proactive peak-load alerts, appliance optimization tips, and carbon offset tracking.

---

## 🌍 UN SDG Integration

The application integrates sustainability education into everyday domestic energy management:

| SDG Goal | Target Focus | System Impact |
|:---|:---|:---|
| **SDG 7: Affordable & Clean Energy** | Ensure access to reliable, sustainable, modern energy. | Mitigates high-load spikes on municipal grids, facilitating seamless integration of renewable solar/wind generation without blackout risks. |
| **SDG 12: Responsible Consumption** | Ensure sustainable consumption patterns. | Eliminates standby vampire loads and optimizes daily runtime of heavy heating and cooling appliances. |
| **SDG 13: Climate Action** | Combat climate change and greenhouse gas emissions. | Quantifies carbon emissions avoided (0.82 kg CO₂/kWh conserved) and presents equivalent trees planted. |

---

## 📱 Core Features by Screen

### Screen 1: Splash Screen
- Smooth pulse animation featuring the **Smart Energy** circular gradient badge.
- App Title: **Smart Energy**.
- Tagline: *"Manage Energy, Build a Greener Future"*.
- Asynchronous preloading of persistent storage and hardware profiles.

### Screen 2: Dashboard (Home)
- **Greeting & Live Context:** User greeting, home unit label, and live simulation status badge.
- **Hero Energy Card:** Live active draw (W), today's total kWh, estimated daily bill (₹), and energy saving percentage badge.
- **Global Rapid Controls:** One-touch *"Turn All OFF"* and *"Eco Optimize"* (sheds heavy loads $\ge 1000\text{W}$).
- **4-Grid Metrics:** Connected appliances ratio, projected monthly billing, daily carbon footprint (kg CO₂), and tree offset equivalents.
- **24-Hour Load Curve:** Interactive mini chart showing typical household hourly energy consumption.
- **Quick Appliance Switches:** Instant toggle access for the highest priority devices.
- **SDG Explorer Banner:** Direct link to interactive UN SDG impact modules.

### Screen 3: Device Management
- Filter appliances by room: **All**, **Living Room**, **Master Bedroom**, **Kitchen**, **Utility Area**, **Bathroom**.
- Individual cards for all 7 required smart home appliances:
  1. **Lights** (Living Room LED Array)
  2. **Fans** (High-Efficiency BLDC Fan)
  3. **Air Conditioner** (Inverter Dual AC 1.5T)
  4. **Television** (Smart 4K OLED TV 55")
  5. **Refrigerator** (Frost-Free 340L Inverter)
  6. **Washing Machine** (EcoWash 8kg Front Load)
  7. **Water Heater** (Smart Geyser 25L)
- Live wattage draw, daily estimated kWh, room badge, status indicator, and responsive ON/OFF switch.
- **Interactive Device Detail Sheet:** Adjust scheduled operating hours per appliance, view daily/monthly costs, and inspect energy conservation recommendations.

### Screen 4: Energy Analytics
- **Dynamic Timeframe Selector:** [Daily (24 Hours) | Weekly (7 Days) | Monthly (6 Months)].
- **High-Precision Charts (`fl_chart`):** Smooth interactive curves with touch tooltips detailing kWh and ₹ at each coordinate.
- **Appliance Consumption Breakdown:** Interactive donut/pie chart displaying the percentage share of each device against total household consumption.
- **Tabular Appliance Audit:** Granular breakdown with daily kWh and estimated running costs.

### Screen 5: Energy Insights
- **Top Consumer Hero:** Identifies the highest consuming appliance with cost attribution and runtime statistics.
- **Active Grid Alerts:** Real-time warning triggered when heavy appliances (AC + Water Heater) run concurrently.
- **Dynamic Action Cards:** Recommendations with one-tap resolution buttons (e.g., turn off idle lights, switch off geyser).
- **Potential Monthly Savings Calculator:** Quantifies ₹ and kWh savings from trimming non-essential appliance runtime.
- **UN SDG Deep-Dive:** Comprehensive architectural analysis on SDG 7, 12, and 13.

### Screen 6: Settings & Preferences
- **Electricity Tariff Slider:** Real-time adjustable tariff rate (₹3.00 to ₹15.00 per kWh; default ₹7.50). Changes dynamically propagate to all dashboard values and charts.
- **Theme Mode Selector:** Smoothly switch between Dark Navy (default) and Light Mode.
- **Notification Toggles:** High-consumption alerts ($\gt 2200\text{W}$) and autonomous Eco Mode.
- **User Profile Management:** Edit user name, email, home label, and smart meter serial ID.
- **Reset Demo Data:** Safely restore default demo appliance profiles and configurations.

---

## 🧮 Mathematical Formulation & Calculations

The application strictly implements the required physical energy and billing formulas:

### 1. Energy Consumption (kWh)
$$\text{Energy (kWh)} = \frac{\text{Power (Watts)} \times \text{Operating Hours}}{1000}$$

### 2. Estimated Electricity Bill (₹)
$$\text{Estimated Cost (₹)} = \text{Total Energy (kWh)} \times \text{Electricity Tariff (₹/kWh)}$$

### 3. Active Instantaneous Power Load (Watts)
$$\text{Total Active Load (W)} = \sum_{i \in \text{Devices}} \begin{cases} \text{PowerRating}_i, & \text{if Device}_i \text{ is ON} \\ 0, & \text{if Device}_i \text{ is OFF} \end{cases}$$

### 4. Projected Monthly Electricity Bill
$$\text{Projected Monthly Cost (₹)} = \left(\text{Daily Energy (kWh)} \times 30\right) \times \text{Tariff Rate (₹/kWh)}$$

### 5. Carbon Footprint (kg CO₂)
$$\text{CO}_2 \text{ Emissions (kg)} = \text{Total Energy (kWh)} \times 0.82 \text{ kg CO}_2\text{/kWh}$$

---

## 🏗 Architecture & Folder Structure

Clean, modular, and separation-of-concerns architecture:

```
smart_home_energy/
├── android/                             # Android native configuration
│   ├── app/
│   │   ├── build.gradle
│   │   └── src/main/AndroidManifest.xml
│   ├── build.gradle
│   └── settings.gradle
├── web/                                 # Flutter Web platform host
│   ├── index.html                       # Styled HTML5 loader with electric green theme
│   └── manifest.json                    # PWA metadata
├── lib/
│   ├── main.dart                        # Application bootstrap & SharedPreferences init
│   ├── app.dart                         # MultiProvider setup & Theme routing
│   ├── models/
│   │   ├── device_model.dart            # Appliance entity, JSON serialization, default list
│   │   └── energy_model.dart            # Analytics, Insights, UserProfile & SDG models
│   ├── providers/
│   │   ├── device_provider.dart         # Appliance state, toggling, active load aggregation
│   │   ├── energy_provider.dart         # Billing calculations, historical datasets, insights
│   │   └── settings_provider.dart       # Tariff rates, theme toggle, profile settings
│   ├── services/
│   │   ├── energy_calculation_service.dart # Pure calculation formulas & data generators
│   │   └── storage_service.dart         # SharedPreferences abstraction & persistence
│   ├── screens/
│   │   ├── splash_screen.dart           # Animated splash branding
│   │   ├── main_screen.dart             # IndexedStack navigation host
│   │   ├── dashboard_screen.dart        # Screen 2: Dashboard with active metrics
│   │   ├── devices_screen.dart          # Screen 3: Complete appliance management
│   │   ├── analytics_screen.dart        # Screen 4: Interactive charts & breakdown
│   │   ├── insights_screen.dart         # Screen 5: Smart alerts & SDG insights
│   │   └── settings_screen.dart         # Screen 6: Tariff & preference configuration
│   ├── widgets/
│   │   ├── bottom_navigation.dart       # Modern custom 5-tab bar
│   │   ├── consumption_chart.dart       # Interactive fl_chart Line & Bar charts
│   │   ├── device_card.dart             # Appliance card with animated glowing state
│   │   ├── device_detail_sheet.dart     # Interactive bottom sheet for schedule tuning
│   │   ├── energy_summary_card.dart     # Hero gradient energy summary
│   │   ├── quick_stats_grid.dart        # 4-card metric grid
│   │   └── sdg_banner_card.dart         # UN SDG highlight & bottom sheet
│   └── utils/
│       ├── app_theme.dart               # Dark Navy & Light Material 3 themes
│       └── constants.dart               # Colors, constants, keys & SDG data
├── test/
│   ├── device_provider_test.dart        # Unit tests for toggling & load updates
│   ├── energy_calculation_service_test.dart # Unit tests for kWh & cost formulas
│   └── settings_provider_test.dart      # Unit tests for tariff & theme persistence
├── pubspec.yaml                         # Dependencies and assets
├── analysis_options.yaml                # Strict Flutter lint rules
└── README.md                            # Comprehensive documentation
```

---

## ⚡ State Management (Provider)

Global state is orchestrated via `Provider` using clean separation:
- **`SettingsProvider`:** Manages user profile, tariff rates ($₹/\text{kWh}$), theme preference, and eco settings. Persists changes via `StorageService`.
- **`DeviceProvider`:** Maintains the list of smart appliances. Toggling an appliance immediately recalculates `totalActiveLoadWatts`, `activeDevicesCount`, and persists state to `SharedPreferences`.
- **`EnergyProvider`:** Powered by `ChangeNotifierProxyProvider2<DeviceProvider, SettingsProvider, EnergyProvider>`. It dynamically generates hourly curves, 7-day history, 6-month trends, and dynamic insights whenever device states or electricity tariffs change.

> **Zero `setState` for Global State:** Local widget state is strictly reserved for ephemeral UI (such as active filter chips and touched chart spots); all data mutations flow through Provider.

---

## 📊 Appliance Specifications & Demo Data Matrix

The application includes 7 predefined, realistic smart-home appliances:

| Appliance Name | Room | Rated Power (W) | Daily Hours | Daily Energy (kWh) | Monthly Cost @ ₹7.50 | Initial State |
|:---|:---|:---:|:---:|:---:|:---:|:---:|
| **Living Room Lights** | Living Room | 45 W | 6.0 hrs | 0.27 kWh | ₹60.75 | **ON** |
| **Ceiling BLDC Fan** | Master Bedroom | 35 W | 9.0 hrs | 0.32 kWh | ₹72.00 | **ON** |
| **Air Conditioner 1.5T** | Master Bedroom | 1,450 W | 6.5 hrs | 9.43 kWh | ₹2,121.75 | **OFF** |
| **Television 4K OLED** | Living Room | 120 W | 4.0 hrs | 0.48 kWh | ₹108.00 | **ON** |
| **Refrigerator 340L** | Kitchen | 180 W | 24.0 hrs (Duty Cycle) | 4.32 kWh | ₹972.00 | **ON** |
| **Washing Machine 8kg** | Utility Area | 500 W | 1.5 hrs | 0.75 kWh | ₹168.75 | **OFF** |
| **Water Heater Geyser** | Bathroom | 2,000 W | 1.0 hr | 2.00 kWh | ₹450.00 | **OFF** |

---

## 🎨 Design System & Theme

| Token | Dark Navy Theme (Default) | Light Theme | Purpose |
|:---|:---|:---|:---|
| **Background** | `#090E17` (Deep Dark Navy) | `#F4F7FB` (Light Slate) | Canvas scaffold |
| **Card Surface** | `#162238` (Navy Surface) | `#FFFFFF` (Pure White) | Appliance & metric cards |
| **Primary Accent** | `#00E676` (Electric Green) | `#00E676` (Electric Green) | Active toggles, badges, graphs |
| **Secondary Accent** | `#00E5FF` (Energy Cyan/Teal) | `#06B6D4` (Teal) | Forecasts, cost values, secondary |
| **Alert Warning** | `#F59E0B` (Amber) | `#F59E0B` (Amber) | High load warnings ($\gt 2200\text{W}$) |
| **Alert Danger** | `#EF4444` (Crimson) | `#EF4444` (Crimson) | Peak grid alerts, master OFF |
| **Card Border Radius** | `18.0 px` | `18.0 px` | Smooth modern corner curves |

---

## 🚀 Installation & Setup

### Prerequisites
- [Flutter SDK](https://flutter.dev/docs/get-started/install) (`>= 3.10.0`)
- [Dart SDK](https://dart.dev/get-dart) (`>= 3.0.0`)
- Android Studio / VS Code with Flutter extension
- Google Chrome (for Flutter Web)

### Dependencies (`pubspec.yaml`)
```yaml
dependencies:
  flutter:
    sdk: flutter
  provider: ^6.1.2
  fl_chart: ^0.68.0
  shared_preferences: ^2.3.2
  intl: ^0.19.0

dev_dependencies:
  flutter_test:
    sdk: flutter
  flutter_lints: ^4.0.0
```

### Installation Steps
```bash
# 1. Clone or navigate to the project directory
cd smart_home_energy

# 2. Fetch dependencies
flutter pub get

# 3. Analyze code quality (0 errors, 0 warnings)
flutter analyze
```

---

## 💻 Execution & Build Commands

### 1. Run on Connected Device / Emulator
```bash
flutter run
```

### 2. Run on Flutter Web (Chrome)
```bash
flutter run -d chrome
```

### 3. Build Production Android APK
```bash
flutter build apk --release
# Generated APK located at: build/app/outputs/flutter-apk/app-release.apk
```

### 4. Build Production Web Application
```bash
flutter build web --release
# Deployment output located at: build/web/
```

---

## 🧪 Automated Testing Suite

The project includes unit tests for device state toggling, load calculations, and energy formulas:

```bash
flutter test
```

### Test Coverage Highlights
- `test/energy_calculation_service_test.dart`:
  - Validates `Power * Hours / 1000` with diverse wattages.
  - Validates `Energy (kWh) * Tariff Rate (₹)` billing calculation.
  - Validates selective active load summation ($W$).
  - Validates energy savings percentage ($40\%$ reduction from baseline).
  - Validates carbon footprint ($0.82\text{ kg CO}_2/\text{kWh}$).
- `test/device_provider_test.dart`:
  - Validates loading of 7 initial appliances.
  - Validates active load addition when toggling ON.
  - Validates active load subtraction when toggling OFF.
  - Validates *Turn All OFF* and *Turn All ON*.
  - Validates heavy-load shedder (*Eco Optimize* turning off $\ge 1000\text{W}$).
- `test/settings_provider_test.dart`:
  - Validates real-time tariff updates and listener notifications.
  - Validates dark/light theme switching.
  - Validates demo data reset mechanism.

---

## ⚠️ Hardware Integration Disclaimer

> **Notice:** This application operates in **Simulated Demo Mode**. Power, energy usage, and cost projections are dynamically computed based on realistic physical electrical engineering ratings and typical residential duty cycles. The system does not claim direct physical IoT hardware integration or utility smart-meter communication.
