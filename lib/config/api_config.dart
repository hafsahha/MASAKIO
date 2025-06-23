// Configuration file untuk API endpoints
// Ubah IS_LOCAL ke false untuk menggunakan production server

const bool IS_LOCAL = false; // Set ke false untuk production

const String LOCAL_BASE_URL = 'http://localhost:3000';
const String PRODUCTION_BASE_URL = 'https://masakio.up.railway.app';

// Get base URL based on environment
String get baseUrl => IS_LOCAL ? LOCAL_BASE_URL : PRODUCTION_BASE_URL;

// Endpoint URLs
String get cardRecipeUrl => baseUrl;
String get reviewsUrl => '$baseUrl/';
String get authUrl => baseUrl;
String get wishlistUrl => '$baseUrl/wishlist';
String get recipeUrl => '$baseUrl/recipe';
String get tipsUrl => '$baseUrl/tips';
