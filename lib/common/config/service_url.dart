class ServiceUrl {
  static String _baseUrl = 'http://192.168.0.103:8080/v1';
  static String loginUrl = _baseUrl + '/test/login';
  static String buildingListUrl = _baseUrl + '/building';
  static String firstLoginUpdateUrl = _baseUrl + '/first-login-update';
  static String categoryUrl = _baseUrl + '/category';
  static String uploadImageUrl = _baseUrl + '/image';
  static String detailUrl = _baseUrl + '/detail';
  static String userUrl = _baseUrl + '/user';
  static String avatarUrl = _baseUrl + '/avatar';
  static String listUrl = _baseUrl + '/list';
  static String profileUrl = _baseUrl + '/profile';
  static String starUrl = _baseUrl + '/star';
  static String exchangeUrl = _baseUrl + '/exchange';

  static String briefUrl = _baseUrl + '/brief';
  static String userBriefUrl = briefUrl + '/user';
  static String detailBriefUrl = briefUrl + '/detail';
}
