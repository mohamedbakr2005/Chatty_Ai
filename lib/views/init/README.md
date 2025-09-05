# Init Screen & Bottom Navigation

This directory contains the implementation of the main app screen with bottom navigation for the e-commerce app.

## Structure

```
init/
├── cubit/
│   ├── bottom_nav_cubit.dart      # Bottom navigation business logic
│   └── bottom_nav_state.dart      # Bottom navigation state
├── widgets/
│   └── bottom_nav_bar.dart        # Bottom navigation bar widget
├── init_screen.dart               # Main init screen
└── README.md                      # This documentation
```

## Features

### Init Screen
- **Screen Management**: Handles switching between different app screens
- **Bottom Navigation**: Integrates with bottom navigation bar
- **State Management**: Uses cubit for navigation state

### Bottom Navigation Bar
- **5 Tabs**: Home, Search, Saved, Cart, Account
- **Active States**: Visual feedback for selected tab
- **Icons**: Different icons for active and inactive states
- **Labels**: Text labels below each icon
- **Responsive Design**: Adapts to different screen sizes

## Navigation Tabs

1. **Home (Index 0)**: Main discover screen with products
2. **Search (Index 1)**: Search functionality (placeholder)
3. **Saved (Index 2)**: Saved/favorites screen (placeholder)
4. **Cart (Index 3)**: Shopping cart screen (placeholder)
5. **Account (Index 4)**: User account screen (placeholder)

## State Management

The bottom navigation uses BLoC pattern with Cubit:

- **BottomNavCubit**: Handles tab switching logic
- **BottomNavState**: Contains current tab index

## Usage

The init screen is the main entry point after login. It automatically shows the Home screen and provides bottom navigation to access other app sections.

## Customization

- Colors are defined in `lib/core/constants/app_colors.dart`
- Icons can be customized in the `BottomNavBar` widget
- Screen switching logic is in the `_buildBody` method 