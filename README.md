# MATLAB Numerical Computing Exercises

This repository contains solutions for MATLAB numerical computing exercises, with both MATLAB and Python implementations where applicable.

## Exercise 1 - Machine Numbers

**Status: Complete** (both MATLAB and Python implementations)

This exercise focuses on floating-point representation and machine numbers. Solutions are added weekly as new problems are assigned.

### Files:
- `fl1.m` / `machine_numbers.py` - Core functions for machine number operations
- `fl2.m`, `fl3.m`, `fl4.m` - Additional MATLAB implementations
- `examples.m` / `examples.py` - Usage examples
- `tests.m` / `tests.py` - Comprehensive test suites

## Exercise 2 - Linear Systems

**Status: Complete** (both MATLAB and Python implementations)

Gaussian elimination and linear system solving methods with pivoting strategies.

### Files:
- `gaussel1.m` / `gaussel1.py` - Basic Gaussian elimination
- `gaussel2.m` / `gaussel2.py` - Gaussian elimination with partial/full pivoting
- `gaussel3.m` / `gaussel3.py` - Matrix inverse and LU decomposition
- `examples.m` / `examples.py` - Usage examples and demonstrations
- `tests.m` / `tests.py` - Comprehensive test suites

## Setup and Usage

### Python Environment

1. **Using uv (recommended):**
   ```bash
   uv sync
   uv run pytest 1/tests.py  # Exercise 1 tests
   uv run pytest 2/tests.py  # Exercise 2 tests
   ```

2. **Using pip:**
   ```bash
   pip install -e .
   pytest 1/tests.py  # Exercise 1 tests
   pytest 2/tests.py  # Exercise 2 tests
   ```

### MATLAB

1. Open MATLAB in the project directory
2. Navigate to the exercise folder (e.g., `cd 1` or `cd 2`)
3. Run tests: `tests` (for the respective test file)
4. Run examples: `examples`

## Running Tests

### Python Tests
```bash
# Run all Python tests for both exercises
uv run pytest -v

# Run tests for specific exercise
uv run pytest 1/tests.py -v  # Exercise 1: Machine numbers
uv run pytest 2/tests.py -v  # Exercise 2: Gaussian elimination

# Run specific test class
uv run pytest 1/tests.py::TestFL1 -v
uv run pytest 2/tests.py::TestGaussel1 -v
```

### Python Examples
```bash
# Run interactive examples
cd 1 && uv run python examples.py  # Exercise 1 examples
cd 2 && uv run python examples.py  # Exercise 2 examples

# Or run individual functions
cd 2 && uv run python gaussel1.py  # Basic Gaussian elimination demo
cd 2 && uv run python gaussel2.py  # Pivoting strategies demo
cd 2 && uv run python gaussel3.py  # Matrix inverse demo
```

### MATLAB Tests
```matlab
% In MATLAB, navigate to exercise directory
cd 1
tests  % Runs all tests for exercise 1

cd ../2
tests  % Runs all tests for exercise 2
```

## Development

This project uses:
- **Python**: pytest for testing, black for formatting, mypy for type checking
- **MATLAB**: Built-in testing framework
- **Git**: Version control with GitHub Actions for automated testing

### Pre-commit Hooks

Pre-commit hooks are configured to run on Python files only:
- Code formatting with Black (automatically fixes code style)
- Type checking with Mypy (strict mode)
- Basic file checks (trailing whitespace, end of file)

Install and setup:
```bash
uv run pre-commit install
```

**Note**: The mypy hook runs in strict mode and may show type errors that need to be addressed for full compliance. The code formatting with Black will automatically fix style issues.

## Notes

- Both exercises contain MATLAB and Python implementations for comprehensive learning
- Exercise 1: Machine numbers and floating-point arithmetic
- Exercise 2: Linear systems and Gaussian elimination with various pivoting strategies
- All Python code follows strict formatting and type checking standards
- Functions are designed to be equivalent between MATLAB and Python versions