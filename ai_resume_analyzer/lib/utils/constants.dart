class AppConstants {
  // Backend API base URL
  // static const String baseUrl = 'http://localhost:5000'; // For local web testing
  static const String baseUrl = 'http://192.168.29.89:5000'; // For live session

  // Endpoints
  static const String signupUrl = '$baseUrl/auth/signup';
  static const String loginUrl = '$baseUrl/auth/login';
  static const String analyzeUrl = '$baseUrl/analyze-resume';
  static const String historyUrl = '$baseUrl/analyze-resume/history';
  static const String profileUrl = '$baseUrl/analyze-resume/profile';
  static const String passwordUrl = '$baseUrl/analyze-resume/password';

  // Local storage keys
  static const String tokenKey = 'auth_token';
  static const String userNameKey = 'user_name';
  static const String userEmailKey = 'user_email';
  static const String userIdKey = 'user_id';
  static const String userPhoneKey = 'user_phone';
  static const String userLocationKey = 'user_location';
  static const String userProfilePicKey = 'user_profile_pic';


  // Popular job roles for quick selection
  static const List<String> popularJobRoles = [
    'Flutter Developer',
    'Android Developer',
    'iOS Developer',
    'Frontend Developer',
    'Backend Developer',
    'Full Stack Developer',
    'Data Scientist',
    'Machine Learning Engineer',
    'DevOps Engineer',
    'UI/UX Designer',
    'Product Manager',
    'Software Engineer',
  ];
}
