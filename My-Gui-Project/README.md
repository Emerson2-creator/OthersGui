# My GUI Project

This project is designed to provide a structured approach to creating graphical user interfaces (GUIs) using Lua. It consists of two main components: raw GUI code and an optimized library for easier access to GUI functionalities.

## Project Structure

```
my-gui-project
├── src
│   ├── raw-gui
│   │   └── gui-code.lua        # Contains the complete raw GUI code.
│   ├── library
│   │   └── gui-library.lua     # Contains the optimized GUI library.
├── package.json                # npm configuration file.
├── tsconfig.json               # TypeScript configuration file.
└── README.md                   # Project documentation.
```

## Components

### Raw GUI Code

- **File:** `src/raw-gui/gui-code.lua`
- **Description:** This file contains the complete structure and functionality of the GUI components. It can be imported using a `loadstring` for dynamic execution.

### GUI Library

- **File:** `src/library/gui-library.lua`
- **Description:** This file provides a smaller, optimized version of the GUI code. It simplifies access to the functionalities defined in the raw GUI code, making it easier to implement GUI features in your applications.

## Installation

To get started with this project, clone the repository and install the necessary dependencies:

```bash
npm install
```

## Usage

To use the GUI components, you can load the raw GUI code using `loadstring` and utilize the library for simplified access to the functionalities.

## Contributing

Contributions are welcome! Please feel free to submit a pull request or open an issue for any suggestions or improvements.

## License

This project is licensed under the MIT License. See the LICENSE file for more details.