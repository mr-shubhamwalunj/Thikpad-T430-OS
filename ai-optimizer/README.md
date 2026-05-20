# AI Performance Optimizer for ThinkPad T430 OS

This module provides AI-driven performance optimization specifically tuned for the ThinkPad T430 hardware.

## Features

### 1. CPU Frequency Governor Tuning
Automatically adjusts CPU frequency based on workload patterns using machine learning.

### 2. Memory Management
- Intelligent swap usage prediction
- Application usage pattern learning
- Preloading frequently used applications

### 3. Thermal Management
- Learns your usage patterns to optimize fan curves
- Predictive thermal throttling prevention
- Battery health optimization

### 4. Storage Optimization
- SSD wear leveling optimization
- Intelligent file placement based on access patterns
- Read-ahead buffer tuning

## Usage

```bash
# Start the optimizer daemon
sudo ./ai-optimizer-daemon.sh

# View current optimization status
./ai-status.py

# Run manual optimization
./optimize-system.sh
```

## Configuration

Edit `/etc/t430-optimizer.conf` to customize:
- Aggressiveness of optimizations
- Power vs performance balance
- Learning rate for AI models

## Files

- `ai-optimizer-daemon.sh` - Background optimization service
- `optimize-system.sh` - Manual optimization script
- `ai-status.py` - Status monitoring tool
- `models/` - Trained ML models for T430 hardware
