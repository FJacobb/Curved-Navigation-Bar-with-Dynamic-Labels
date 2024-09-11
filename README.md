
# 🌀 Curved Navigation Bar with Dynamic Labels

A highly customizable **Curved Navigation Bar** widget for Flutter, featuring dynamic label animations and a seamless curved design. This widget is built to be easily integrated into any Flutter project.

## 📦 How to Install

### 1. Add to `pubspec.yaml`
To install this package, add it to your `pubspec.yaml` under `dependencies`:

```yaml
dependencies:
  curved_navigation_bar_dynamic: 
    git:
      url: https://github.com/FJacobb/curved_navigation_bar_dynamic.git
```

Then, run the following command in your terminal to fetch the package:

```bash
flutter pub get
```

### 2. Import the Package
Now, you can import it into your Dart code:

```dart
import 'package:curved_navigation_bar_dynamic/curved_navigation_bar_dynamic.dart';
```

## 🔧 Usage

You can easily integrate the **Curved Navigation Bar** with labels by using the following code snippet in your Flutter project:

```dart
import 'package:flutter/material.dart';
import 'package:curved_navigation_bar_dynamic/curved_navigation_bar_dynamic.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: _getPage(_selectedIndex), // Your page widget
      ),
      bottomNavigationBar: CurvedNavigationBar(
        items: <Widget>[
          Icon(Icons.home),
          Icon(Icons.search),
          Icon(Icons.shopping_cart),
          Icon(Icons.person),
        ],
        labels: [
          Text('Home'),
          Text('Search'),
          Text('Cart'),
          Text('Profile'),
        ],
        color: Colors.white,
        buttonBackgroundColor: Colors.blue,
        backgroundColor: Colors.black,
        labelColor: Colors.blueAccent,
        animationDuration: Duration(milliseconds: 300),
        onTap: (index) {
          setState(() {
            _selectedIndex = index;
          });
        },
      ),
    );
  }

  Widget _getPage(int index) {
    switch (index) {
      case 0:
        return HomePage(); // Replace with your pages
      case 1:
        return SearchPage();
      case 2:
        return CartPage();
      case 3:
        return ProfilePage();
      default:
        return HomePage();
    }
  }
}
```

### Key Customization Options:

- **Items:** Add icons or widgets as navigation items.
- **Labels:** Customize label text for each item.
- **Color:** Change the background, icon, and label colors.
- **Animation:** Control animation curves and durations for label transitions.
- **Opacity:** Labels will fade in/out smoothly depending on selection.

## 🚨 Important Notes

- The number of `labels` must match the number of `items`.
- Custom animations are built into the navigation bar for smooth transitions.

## 📋 Requirements

- Flutter SDK
- Dart SDK

## 🛠️ Development

Feel free to fork the project, make improvements, and submit pull requests. Contributions are always welcome!

## 🤝 Contributions

If you'd like to contribute, please fork the repository and submit a pull request or open an issue with suggestions or improvements.

## 📄 License

This project is licensed under the MIT License
## 📧 Contact

For any queries or support, feel free to reach out:

- LinkedIn: [Festus Jacob](https://www.linkedin.com/in/festus-j-4460601b9/)
- GitHub: [FJacobb](https://github.com/FJacobb)

