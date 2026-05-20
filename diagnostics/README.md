# Diagnostics Tools for ThinkPad T430 OS

Hardware diagnostics and system health monitoring tools specifically for the ThinkPad T430.

## Available Tools

### 1. Hardware Health Check
```bash
./hardware-check.sh
```
Checks:
- CPU temperature and throttling status
- Battery health and wear level
- SSD/HDD SMART status
- RAM integrity
- Fan operation

### 2. ThinkPad Specific Tests
```bash
./thinkpad-tests.sh
```
Tests:
- TrackPoint functionality
- Touchpad responsiveness
- Function keys (Fn+F1-F12)
- Keyboard backlight
- Display brightness levels
- Audio speakers and microphone
- WiFi and Bluetooth
- USB ports
- VGA/DisplayPort outputs
- SD card reader

### 3. Performance Benchmarks
```bash
./benchmark.sh
```
Measures:
- CPU single/multi-core performance
- Memory bandwidth
- Disk read/write speeds
- Graphics performance (OpenGL)
- Network throughput

### 4. Power Consumption Analysis
```bash
./power-analysis.sh
```
Analyzes:
- Current power draw
- Battery discharge rate
- Component power usage
- Power saving recommendations

## Output Reports

All tools generate reports in:
- Text format: `~/diagnostics/report.txt`
- HTML format: `~/diagnostics/report.html` (for sharing)
- JSON format: `~/diagnostics/report.json` (for automated analysis)

## Automated Testing

Run full diagnostic suite:
```bash
./run-all-diagnostics.sh
```

This runs all tests and generates a comprehensive report with:
- Pass/fail status for each component
- Performance scores
- Recommendations for issues found
- Comparison with expected values for T430

## Troubleshooting Common Issues

### Battery Not Charging
Run: `./battery-diagnose.sh`

### Overheating
Run: `./thermal-analysis.sh`

### Slow Performance
Run: `./performance-diagnose.sh`

### WiFi Issues
Run: `./network-diagnose.sh`
