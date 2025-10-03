# MATLAB Numerical Computing Exercises

This repository contains solutions for MATLAB numerical computing exercises, with both MATLAB and Python implementations where applicable.

### Python Environment

1. **Using uv (recommended):**
   ```bash
   uv sync
   uv run pytest 1/tests.py
   ```

### MATLAB

1. Open MATLAB in the project directory
2. Navigate to the exercise folder (e.g., `cd 1` or `cd 2`)
3. Run tests: `tests` (for the respective test file)
4. Run examples: `examples`

## Running Tests

### Python Tests
```bash
# Run Python tests
uv run pytest 1/tests.py -v

# Run specific test class
uv run pytest 1/tests.py::TestFL1 -v
```

### MATLAB Tests
```matlab
% In MATLAB, navigate to exercise directory
cd 1
tests  % Runs all tests for exercise 1

cd ../2
tests  % Runs all tests for exercise 2
```

## Notes

- New solutions are added weekly