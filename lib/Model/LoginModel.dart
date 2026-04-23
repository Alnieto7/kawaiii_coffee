class LoginResponse {
  final bool? success;
  final String? message;
  final String? token;

  LoginResponse({
    this.success,
    this.message,
    this.token,
  });

  // Fungsi untuk mengubah JSON (Map) dari API menjadi Object Dart
  factory LoginResponse.fromJson(Map<String, dynamic> json) {
    return LoginResponse(
      success: json['success'] ?? true, // Sesuaikan dengan response API-mu
      message: json['message'] ?? '',
      // Menangkap key 'token' atau 'access_token' agar lebih aman
      token: json['token'] ?? json['access_token'], 
    );
  }

  // Fungsi opsional jika kamu butuh mengirim data ini kembali sebagai JSON
  Map<String, dynamic> toJson() {
    return {
      'success': success,
      'message': message,
      'token': token,
    };
  }
}