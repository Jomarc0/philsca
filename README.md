# Portable Center of Gravity Computing Device

A production-ready Flutter application for real-time aircraft weight & balance
monitoring, built with Material 3, Clean Architecture, and Provider state
management.

## Tech Stack

| Concern            | Choice              |
|---------------------|---------------------|
| Framework            | Flutter 3+ (null safety) |
| State Management     | Provider            |
| Routing              | go_router            |
| Fonts                | Google Fonts (Poppins) |
| Bluetooth (future)   | flutter_blue_plus (architecture only — no live ESP32 connection yet) |
| Local Storage        | shared_preferences   |
| Animations            | flutter_animate       |
| Progress Indicators   | percent_indicator     |

## Getting Started

```bash
flutter pub get
flutter run
```

Requires Flutter 3.0+ and Dart 3.0+.

## Project Structure

```
lib/
  main.dart                  # Entry point, MultiProvider setup
  app.dart                   # MaterialApp.router + go_router config + bottom-nav shell
  core/
    constants/                # Colors, strings, sizing tokens
    theme/                    # Material 3 ThemeData
    widgets/                  # Shared reusable widgets
    helpers/
  models/                     # SensorModel, WeightModel, HistoryModel, AircraftModel, CgStatus
  providers/                  # DashboardProvider, BluetoothProvider, CgProvider, HistoryProvider
  services/                   # BluetoothService, CgCalculatorService, HistoryService, StorageService
  screens/
    splash/
    dashboard/
    live_monitoring/
    cg_visualizer/
    weight_distribution/
    history/
assets/
  images/
  icons/
  fonts/
```

## Screens

1. **Splash** — dark aviation-themed splash, auto-navigates to Dashboard after 3s.
2. **Dashboard** — connection status, today's SAFE/WARNING/UNSAFE status, total
   weight, center of gravity, aircraft status, and aircraft info.
3. **Live Monitoring** — real-time sensor list (Pilot, Passenger, Rear
   Passenger, Cargo, Fuel, Baggage) with a bottom summary bar (total weight,
   CG, refresh, connect/disconnect).
4. **CG Visualizer** — aircraft top-view with an animated marker showing
   current CG position relative to forward/aft limits.
5. **Weight Distribution** — a responsive Station / Weight / Arm / Moment
   table with totals and a SAFE/WARNING/UNSAFE badge.
6. **History** — searchable, pull-to-refresh list of past calculations
   (20+ mock records seeded on first launch), with an export action.

## Weight & Balance Formulas

```
Moment = Weight × Arm
CG     = Total Moment / Total Weight
```

Status thresholds (configurable per-aircraft via `AircraftModel`):

- **SAFE** — `forwardLimit ≤ CG ≤ aftLimit` and CG is more than 1.0 in from
  either limit
- **WARNING / NEAR LIMIT** — CG is within 1.0 in of a limit but still inside it
- **UNSAFE** — CG is outside `[forwardLimit, aftLimit]`

All calculation logic lives in `CgCalculatorService`, which is a pure
function with no UI or state dependencies, so it can be unit tested in
isolation.

## Bluetooth / ESP32 Integration

`BluetoothDeviceService` currently simulates connection state and exposes a
broadcast `Stream<Map<String, double>>` for sensor readings. It intentionally
does **not** talk to real hardware yet. To wire up the real ESP32 device:

1. Implement BLE scanning/connection using `flutter_blue_plus` inside
   `BluetoothDeviceService.connect()`.
2. Subscribe to the relevant BLE characteristic and call `emitReading(...)`
   with parsed sensor values whenever new data arrives.
3. `CgProvider` can then be updated to listen to that stream (via
   `BluetoothProvider`) and call `updateSensorWeight(...)` for each reading,
   with no changes required in any screen/UI code.

## Notes

- Mock data is used throughout (dashboard figures, sensor readings, and 24
  generated history records) so the app is fully explorable without hardware.
- The UI mockup also depicted a Learning Hub, Aircraft Information detail
  page, Calibration screen, and About Device screen. Those weren't part of
  the core functional spec for this build but the folder structure
  (`screens/learning_hub`, `screens/aircraft_info`, `screens/calibration`,
  `screens/about`) is scaffolded and ready — happy to build those out next if
  you'd like the full 10-screen set.
