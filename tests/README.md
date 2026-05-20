# Tests for ThinkPad T430 OS

Automated testing framework to ensure system stability and compatibility.

## Test Categories

### 1. Unit Tests
Tests for individual components:
- Kernel modules
- System services
- Configuration files
- Scripts and utilities

Run: `./run-unit-tests.sh`

### 2. Integration Tests
Tests for component interactions:
- Boot process
- Service dependencies
- Hardware initialization
- Network configuration

Run: `./run-integration-tests.sh`

### 3. Hardware Compatibility Tests
Verifies hardware support:
- CPU features detection
- GPU acceleration
- Audio codec
- Network adapters
- Storage controllers
- Input devices

Run: `./run-hardware-tests.sh`

### 4. Performance Regression Tests
Ensures performance doesn't degrade:
- Boot time measurements
- Application launch times
- File operation speeds
- Network throughput

Run: `./run-performance-tests.sh`

### 5. Installation Tests
Validates installer functionality:
- Fresh installation
- Upgrade scenarios
- Partition handling
- Bootloader configuration

Run: `./run-install-tests.sh`

## Continuous Integration

The test suite integrates with CI/CD pipelines:

```bash
# Run all tests
./run-all-tests.sh

# Generate coverage report
./generate-coverage.sh

# Export results in JUnit format
./export-results.sh
```

## Test Results

Results are stored in `test-results/` directory:
- `latest/` - Most recent test run
- `archive/` - Historical results
- `logs/` - Detailed logs

## Writing New Tests

Test template:
```bash
#!/bin/bash
# test-example.sh

source test-lib.sh

test_description "Example test"

test_begin "Test case 1"
    # Test code here
    result=$(some_command)
    assert_equals "expected" "$result"
test_end

test_summary
```

## Requirements

- Bash 4.0+
- Coreutils
- Optional: qemu (for VM testing)
- Optional: docker (for containerized tests)
