# 🎬 Flutter Movie Booking App

A modern and intuitive movie ticket booking application built with Flutter, featuring seamless VNPay payment integration and a beautiful user interface.

---

## 🖼️ Demo  

<p align="center">
  <img src="https://github.com/user-attachments/assets/2ed8e4bd-fe49-4ee6-8f2d-4d95c625bc1f" alt="Planify Logo" width="240" />
</p>

✨ **Live Demo**: 👉 [Try Movie Booking Ticket App Here](https://appetize.io/app/b_wzl5vb67h7b2dcz5tc56lbgooe)   
✨ **Testing**: 👉 [Test Cases](https://docs.google.com/spreadsheets/d/1ivgbjOkaAaSoMcsg-EtfUXUSMQ39BH34bU7LGw5rRVQ/edit?gid=778336934#gid=778336934)   

**Test Account** :  
Email: tranphuchuynh1@gmail.com  
Password: 123456789aA@

---

## 📱 Screenshots

<div align="center">
  <table>
    <tr>
      <td align="center">
        <img src="https://github.com/user-attachments/assets/f6e0fe94-2418-4cb3-9ea0-51d909dbcdb5" width="300" alt="Login Screen"/>
        <br><b>Login Screen</b>
      </td>
      <td align="center">
        <img src="https://github.com/user-attachments/assets/11637f38-967a-4e7e-a7c0-be4d24d4310f" width="300" alt="Register Screen"/>
        <br><b>Register Screen</b>
      </td>
    </tr>
    <tr>
      <td align="center">
        <img src="https://github.com/user-attachments/assets/a212a6e5-d58a-4546-aea7-42accc374788" width="300" alt="Home Screen"/>
        <br><b>Home Screen</b>
      </td>
      <td align="center">
        <img src="https://github.com/user-attachments/assets/81be7d9d-e0eb-4295-826c-5874f5f3326c" width="300" alt="Movie Detail"/>
        <br><b>Movie Detail</b>
      </td>
    </tr>
    <tr>
      <td align="center">
        <img src="https://github.com/user-attachments/assets/d0cd1e33-b24a-44bb-89c1-76baf9a7d58c" width="300" alt="Seat Selection"/>
        <br><b>Seat Selection</b>
      </td>
      <td align="center">
        <img src="https://github.com/user-attachments/assets/99c76b71-ed3c-4ea5-9f4c-d2cc14ceb972" width="300" alt="Payment Screen"/>
        <br><b>Payment Screen</b>
      </td>
    </tr>
    <tr>
      <td align="center">
        <img src="https://github.com/user-attachments/assets/118010c7-a247-49cd-a427-6bf61990f1a0" width="300" alt="My Tickets"/>
        <br><b>My Tickets</b>
      </td>
      <td align="center">
        <img src="https://github.com/user-attachments/assets/3b6a8903-837c-4416-b529-555094adb200" width="300" alt="Search Screen"/>
        <br><b>Search Screen</b>
      </td>
    </tr>
    <tr>
      <td align="center">
        <img src="https://github.com/user-attachments/assets/321c7d27-3698-4ca8-94c4-66b34610dc17" width="300" alt="History Screen"/>
        <br><b>History Screen</b>
      </td>
      <td align="center">
        <img src="https://github.com/user-attachments/assets/fb4a555e-88ff-4ac0-898d-523b4150a7de" width="300" alt="Profile Screen"/>
        <br><b>Profile Screen</b>
      </td>
    </tr>
  </table>
</div>

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
- **Smooth Animations** - Enhanced user experience with shimmer effects and skeleton loaders
- **Offline Caching** - Cached images for better performance
- **Multi-language Support** - Vietnamese and English localization with app_localizations
- **Custom Theming** - Consistent design system with centralized theme configuration

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

The app follows **Feature-Based Architecture** with **BLoC Pattern** for state management, organized by features for better scalability and maintainability:

```
lib/
├── main.dart
├── theme.dart
├── core/                           # Core utilities and shared components
│   ├── constants/                  # App-wide constants
│   ├── data/                      # Fake/sample data
│   ├── dio/                       # HTTP client configuration
│   ├── models/                    # Data models and DTOs
│   │   ├── auth/                 # Authentication models
│   │   └── payment/              # Payment-related models
│   ├── routes/                   # App routing configuration
│   └── widgets/                  # Reusable UI components
├── features/                      # Feature-based modules
│   ├── auth/                     # Authentication feature
│   │   ├── bloc/                # State management
│   │   ├── controllers/         # Business logic & API services
│   │   └── screens/             # UI screens
│   ├── home_movie/              # Home & movie listing
│   ├── detail_movie/            # Movie details
│   ├── search_movie/            # Movie search functionality
│   ├── select_seat_movie/       # Seat selection
│   ├── payment/                 # Payment processing
│   ├── my_ticket_movie/         # Ticket management
│   ├── ticket_history/          # Booking history
│   └── profile_screen/          # User profile management
├── localization/                 # Multi-language support
└── utils/                       # Utility functions
```

### Architecture Benefits:
- **Feature-Based Structure**: Each feature is self-contained with its own BLoC, controllers, and screens
- **Separation of Concerns**: Clear separation between UI, business logic, and data layers
- **Scalability**: Easy to add new features without affecting existing code
- **Maintainability**: Each feature module can be developed and tested independently
- **BLoC Pattern**: Consistent state management across all features

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
- **VNPay Integration** - Vietnamese payment gateway through WebView
- **Secure Payment Processing** - Handled via payment callback URLs
- **Real-time Payment Status** - Immediate booking confirmation
- **Payment History** - Complete transaction records

## 🚀 Getting Started

### Prerequisites
- Flutter SDK (>=3.0.0)
- Dart SDK (>=3.0.0)
- Android Studio / VS Code
- Android/iOS device or emulator

### Installation

1. **Clone the repository**
   ```bash
   git clone https://github.com/yourusername/tranphuchuynh1-movie-booking-ticket.git
   cd tranphuchuynh1-movie-booking-ticket
   ```

2. **Install dependencies**
   ```bash
   flutter pub get
   ```

3. **Generate code for models and API services**
   ```bash
   dart run build_runner build --delete-conflicting-outputs
   ```

4. **Configure native splash screen**
   ```bash
   dart run flutter_native_splash:create
   ```

5. **Run the app**
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

The app integrates with a custom movie booking API using **Retrofit** with **Dio** client for type-safe HTTP requests:

### API Architecture
```dart
// Core Dio client configuration
@RestApi(baseUrl: "https://your-api-base-url.com/api/")
abstract class ApiService {
  // Authentication
  @POST("/auth/login")
  Future<LoginResponse> login(@Body() LoginRequest request);
  
  @POST("/auth/register") 
  Future<RegisterResponse> register(@Body() RegisterRequest request);
  
  // Movies
  @GET("/movies")
  Future<BaseResponse<List<MovieModel>>> getMovies();
  
  @GET("/movies/{id}")
  Future<MovieModel> getMovieDetail(@Path("id") String movieId);
  
  @GET("/movies/search")
  Future<BaseResponse<List<MovieModel>>> searchMovies(@Query("query") String query);
  
  // Showtimes & Seats
  @GET("/movies/{movieId}/showtimes")
  Future<List<ShowtimeModel>> getShowtimes(@Path("movieId") String movieId);
  
  @POST("/bookings")
  Future<TicketModel> createBooking(@Body() BookingRequest request);
  
  // Payment
  @POST("/payments/vnpay/create")
  Future<PaymentUrlResponse> createVNPayPayment(@Body() PaymentRequest request);
  
  @GET("/payments/callback")
  Future<PaymentCallbackResponse> handlePaymentCallback(@Queries() Map<String, dynamic> params);
  
  // Tickets
  @GET("/tickets")
  Future<List<TicketModel>> getUserTickets();
  
  @GET("/tickets/history")
  Future<List<TicketModel>> getTicketHistory();
}
```

### Service Layer Organization
Each feature has its own service layer:
- **AuthService** - User authentication and registration
- **MovieService** - Movie data and search
- **DetailMovieService** - Individual movie details
- **SelectSeatMovieService** - Seat availability and selection
- **BookingService** - Ticket booking and payment
- **TicketMovieService** - Active tickets management
- **TicketService** - Booking history

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
- GitHub: [@tranphuchuynh1](https://github.com/tranphuchuynh1)
- LinkedIn: [PhúcHuynhJr]([www.linkedin.com/in/phúchuynhjr-undefined-287081326](https://www.linkedin.com/in/ph%C3%BAchuynhjr-undefined-287081326/))
- Email: tranphuchuynh1@gmail.com

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
