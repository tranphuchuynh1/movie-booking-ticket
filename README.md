# 🎬 Flutter Movie Booking App

A modern and intuitive movie ticket booking application built with Flutter, featuring seamless VNPay payment integration and a beautiful user interface.

## 📱 Screenshots

<!-- Add your app screenshots here -->
<div align="center">
  <img src="screenshots/home_screen.png" width="200" alt="Home Screen"/>
  <img src="screenshots/movie_detail.png" width="200" alt="Movie Detail"/>
  <img src="screenshots/seat_selection.png" width="200" alt="Seat Selection"/>
  <img src="screenshots/payment.png" width="200" alt="Payment"/>
</div>

*Add your app screenshots in a `screenshots/` folder*

## ✨ Features

### 🔐 Authentication
- **User Registration** - Create new account with validation
- **Login System** - Secure user authentication
- **Profile Management** - Update user information and preferences

### 🎭 Movie Experience
- **Browse Movies** - Discover latest and popular movies
- **Movie Details** - Comprehensive information, trailers, and ratings
- **Advanced Search** - Find movies by title, genre, or actor
- **Movie Trailers** - Watch trailers with YouTube integration

### 🎟️ Booking System
- **Interactive Seat Selection** - Visual seat map with real-time availability
- **Multiple Show Times** - Choose from various screening times
- **Ticket Management** - View and manage booked tickets
- **QR Code Generation** - Digital tickets with QR codes for easy verification

### 💳 Payment Integration
- **VNPay Integration** - Secure Vietnamese payment gateway
- **WebView Payment** - Seamless in-app payment experience
- **Payment History** - Track all transactions and bookings

### 🎨 User Experience
- **Responsive Design** - Beautiful UI that works on all screen sizes
- **Smooth Animations** - Enhanced user experience with shimmer effects
- **Offline Caching** - Cached images for better performance
- **Multi-language Support** - Localization ready

## 🛠️ Tech Stack

### Core Framework
- **Flutter** - Google's UI toolkit for building beautiful apps
- **Dart** - Programming language optimized for UI development

### State Management
- **Flutter Bloc** - Predictable state management library
- **Equatable** - Simplify equality comparisons

### Networking & API
- **Dio** - Powerful HTTP client for Dart
- **Retrofit** - Type-safe HTTP client generator
- **JSON Annotation** - JSON serialization support

### UI/UX Libraries
- **Google Fonts** - Beautiful typography
- **Flutter SVG** - SVG rendering support
- **Font Awesome Flutter** - Comprehensive icon library
- **Shimmer** - Loading animations
- **Carousel Slider** - Image carousels and sliders
- **Cached Network Image** - Efficient image loading and caching

### Functionality
- **Go Router** - Declarative routing solution
- **Shared Preferences** - Local data persistence
- **URL Launcher** - Launch URLs and external apps
- **WebView Flutter** - In-app web content
- **YouTube Player Flutter** - Embedded YouTube videos
- **QR Flutter** - QR code generation
- **Image Picker** - Camera and gallery access
- **App Links** - Deep linking support

### Development Tools
- **Build Runner** - Code generation
- **JSON Serializable** - Automatic JSON serialization
- **Flutter Native Splash** - Custom splash screens

## 🏗️ Architecture

The app follows **Clean Architecture** principles with **BLoC Pattern** for state management:

```
lib/
├── core/
│   ├── constants/
│   ├── errors/
│   ├── network/
│   └── utils/
├── data/
│   ├── datasources/
│   ├── models/
│   └── repositories/
├── domain/
│   ├── entities/
│   ├── repositories/
│   └── usecases/
├── presentation/
│   ├── bloc/
│   ├── pages/
│   └── widgets/
└── main.dart
```

## 📱 App Screens

### 🏠 Home Screen
- Featured movies carousel
- Popular movies grid
- Categories and genres
- Search functionality

### 🎬 Movie Detail Screen
- Movie poster and information
- Cast and crew details
- Trailer integration
- Showtimes and booking button

### 💺 Seat Selection Screen
- Interactive cinema layout
- Real-time seat availability
- Seat type indicators (regular, VIP, couple)
- Price calculation

### 🎫 My Tickets Screen
- Active and past bookings
- QR codes for ticket verification
- Booking details and status

### 🔍 Search Screen
- Movie search with filters
- Genre-based filtering
- Real-time search results

### 📝 History Screen
- Complete booking history
- Payment transaction records
- Downloadable receipts

### 👤 Profile Screen
- User information management
- App settings and preferences
- Logout functionality

### 💳 Payment Screen
- VNPay integration
- Secure payment processing
- Payment confirmation

## 🚀 Getting Started

### Prerequisites
- Flutter SDK (>=3.0.0)
- Dart SDK (>=3.0.0)
- Android Studio / VS Code
- Android/iOS device or emulator

### Installation

1. **Clone the repository**
   ```bash
   git clone https://github.com/yourusername/flutter-movie-booking.git
   cd flutter-movie-booking
   ```

2. **Install dependencies**
   ```bash
   flutter pub get
   ```

3. **Generate code**
   ```bash
   flutter packages pub run build_runner build
   ```

4. **Run the app**
   ```bash
   flutter run
   ```

### Configuration

1. **API Configuration**
   - Update API base URL in `lib/core/constants/app_constants.dart`
   - Add your movie database API key

2. **VNPay Configuration**
   - Configure VNPay merchant credentials
   - Update payment URLs in configuration files

## 🔧 API Integration

The app integrates with a custom movie booking API that provides:

- **Movie Data** - Movies, showtimes, theaters
- **User Management** - Authentication and profiles
- **Booking System** - Seat reservation and management
- **Payment Processing** - VNPay integration for secure payments

### Key API Endpoints
```dart
@RestApi(baseUrl: "https://your-api-base-url.com/api/")
abstract class MovieApiService {
  @GET("/movies")
  Future<MovieResponse> getMovies();
  
  @GET("/movies/{id}")
  Future<MovieDetail> getMovieDetail(@Path("id") String movieId);
  
  @POST("/bookings")
  Future<BookingResponse> createBooking(@Body() BookingRequest request);
  
  @POST("/payments/vnpay")
  Future<PaymentResponse> processVNPayment(@Body() PaymentRequest request);
}
```

## 🎨 Design System

### Color Palette
- **Primary**: Movie theater red/gold theme
- **Secondary**: Dark backgrounds for movie atmosphere
- **Accent**: Highlight colors for CTAs and selections

### Typography
- **Google Fonts** integration
- Responsive font sizes
- Consistent text hierarchy

## 📱 Platform Support

- ✅ **Android** (API 21+)
- ✅ **iOS** (iOS 12.0+)
- 🔄 **Web** (Progressive enhancement)

## 🧪 Testing

```bash
# Run unit tests
flutter test

# Run integration tests
flutter test integration_test/
```

## 📦 Build & Deployment

### Android
```bash
# Build APK
flutter build apk --release

# Build App Bundle
flutter build appbundle --release
```

### iOS
```bash
# Build iOS
flutter build ios --release
```

## 🤝 Contributing

1. Fork the repository
2. Create your feature branch (`git checkout -b feature/AmazingFeature`)
3. Commit your changes (`git commit -m 'Add some AmazingFeature'`)
4. Push to the branch (`git push origin feature/AmazingFeature`)
5. Open a Pull Request

## 📄 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## 👨‍💻 Developer

**Your Name**
- GitHub: [@yourusername](https://github.com/yourusername)
- LinkedIn: [Your LinkedIn](https://linkedin.com/in/yourprofile)
- Email: your.email@example.com

## 🙏 Acknowledgments

- Flutter team for the amazing framework
- VNPay for payment gateway integration
- Movie database API providers
- Open source community for the incredible packages

---

<div align="center">
  <p>Made with ❤️ and Flutter</p>
  <p>⭐ Star this repo if you found it helpful!</p>
</div>

