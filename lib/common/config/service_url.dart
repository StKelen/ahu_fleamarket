class ServiceUrl {
  static String _baseUrl = 'http://192.168.0.101:8080/v1';
  static String loginUrl = _baseUrl + '/login';
  static String buildingListUrl = _baseUrl + '/building';
  static String firstLoginUpdateUrl = _baseUrl + '/first-login-update';
  static String categoryUrl = _baseUrl + '/category';
  static String uploadImageUrl = _baseUrl + '/image';
  static String detailUrl = _baseUrl + '/detail';
  static String userUrl = _baseUrl + '/user';
  static String userBriefUrl = userUrl + '?type=brief';
  static String avatarUrl = _baseUrl + '/avatar';
  static String listUrl = _baseUrl + '/list';
}
