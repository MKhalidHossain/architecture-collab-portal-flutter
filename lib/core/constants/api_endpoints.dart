import 'package:flutter/foundation.dart';

base class ApiEndpoints {
  static const String socketUrl = _RemoteServer.socketUrl;

  static const String baseUrl = _RemoteServer.baseUrl;

  /// ### post
  static const String login = _Auth.login;

  static const String signup = _Auth.signup;

  static const String logout = _Auth.logout;

  static const String me = _Auth.me;
  static const String updateProfile = _Auth.updateProfile;

  static const String verifyCode = _Auth.verifyCode;

  static const String verifyEmail = _Auth.verifyEmail;

  //static const String registerVerify = _Auth.registerVerify;

  //static const String resetPassword = _Auth.resetPassword;

  static const String forgetPassword = _Auth.forgetPassword;

  static const String changePassword = _Auth.changePassword;

  static const String resetPassword = _Auth.resetPassword;

  static const String createNewPassword = _Auth.resetPassword;

  /// ### post
  static const String refreshToken = _Auth.refreshToken;

  // ---------------------- Client Portal -----------------------------
  /// ### get
  static const String clientPortalDashboard = _ClientPortal.dashboard;
  static const String getClientDocuments = _ClientPortal.getClientDocuments;
  static const String getClientApprovals = _ClientPortal.getClientApprovals;
  static const String clientPortalSearch = _ClientPortal.search;
  static String updateClientApproval(String approvalId) =>
      _ClientPortal.updateClientApproval(approvalId);

  // ---------------------- Team Portal -----------------------------
  /// ### get
  static const String teamMemberDashboard = _TeamPortal.dashboard;
  static const String getTeamMemberDocuments =
      _TeamPortal.getTeamMemberDocuments;
  static const String getTeamApprovals = _TeamPortal.approvals;
  static const String teamPortalSearch = _TeamPortal.search;

  // ---------------------- Projects -----------------------------
  /// ### get
  static const String getProjects = _Project.projects;
  static String getProjectById(String projectId) =>
      _Project.projectById(projectId);
  static const String getFinances = _Finance.getFinances;

  // ---------------------- Tasks -----------------------------
  /// ### post/get
  static const String createTask = _Tasks.tasks;
  static String getProjectTasks(String projectId) =>
      _Tasks.projectTasks(projectId);
  static String submitTask(String taskId) => _Tasks.submitTask(taskId);

  // ---------------------- Documents -----------------------------
  /// ### get
  static String getProjectDocuments(String projectId) =>
      _Documents.projectDocuments(projectId);

  // ---------------------- Settings -----------------------------
  /// ### get/put
  static const String settings = _Settings.settings;

  //------------interest----------------
  /// ### get
  static const String getInterests = _Interest.getallInterests;

  //----------------verification----------------
  /// ### post
  static const String verification = _Verification.verification;

  //-----------------badges----------------
  static const String getMyBadges = _Badges.getMyBadges;
  static const String allBadges = _Badges.allBadges;
  static const String giveBadges = _Badges.giveBadges;

  //---------------report----------------

  /// ### post
  static const String sendReport = _Report.sendReport;

  //------------notification----------------
  /// ### get
  static const String getAllNotifications = _Notification.getAllNotifications;
  static const String marksRead = _Notification.marksRead;
  static const String markAllRead = _Notification.markAllRead;
  static String deleteNotification(String notificationId) =>
      _Notification.deleteNotification(notificationId);

  /// ### post
  // static const String readAllNotifications = _Notification.readAllNotifications;

  /// ### patch
  static String markNotificationAsRead({required String notificationId}) =>
      _Notification.markNotificationAsRead(notificationId);

  // static const String markAllRead = '$_notificationRoute/read-all';
  // static const String deleteNotification = '$_notificationRoute/$notificationId';
  /// ### patch
  // static const String markAllRead = _Notification.markAllAsRead;

  // ---------------------- USER -----------------------------

  /// ### get
  static String getuserbyId(String id) => _User.getuserbyId(id);

  /// ### get
  static const String getCurrentProfile = _User.getCurrentProfile;

  /// ### put
  static const String editProfile = _User.editProfile;

  /// ### put
  static const String uploadProfileAvatar = _User.uploadProfileAvatar;

  /// ### get
  static const String history = _User.history;

  /// ### get
  static const String allUser = _User.allUser;

  static const String setVisibility = _User.setVisibility;

  static const String status = _User.status;

  // ---------------------- RIDE -----------------------------
  /// ### post
  static const String createRide = _Ride.createRide;
  static String updateRide(String id) => _Ride.updateRide(id);
  static String leaveRide(String id) => _Ride.leaveRide(id);
  static String finishRide(String id) => _Ride.finishRide(id);
  static String getRideById(String id) => _Ride.getRideById(id);
  static String joinRide(String id) => _Ride.joinRide(id);
  static String voteForKick(String id) => _Ride.voteForKick(id);
  static String deleteRide(String id) => _Ride.deleteRide(id);
  static const String filterRide = _Ride.filterRide;

  // ---------------------- Booking -----------------------------
  static String getAllBookingsForARide(String rideId) =>
      _Booking.getAllBookingsForARide(rideId);
  static const String getMyBookings = _Booking.getMyBookings;

  // ---------------------- Message -----------------------------
  /// ### Get
  static const String getAllChat = _Message.getAllChat;

  /// ### Get
  static String getMessages(String chatId) => _Message.getMessages(chatId);

  static String getSingleChat(String chatId) => _Message.getSingleChat(chatId);

  /// ### Post
  static String sendMessage(String chatId) => _Message.sendMessage(chatId);

  /// ### Put
  static String messageRead(String messageId) =>
      _Message.messageRead(messageId);

  /// ### Put
  static String editMessage(String messageId) =>
      _Message.editMessage(messageId);

  /// ### Delete
  static String deleteMessage(String messageId) =>
      _Message.deleteMessage(messageId);

  ////////////
  ///
  static String getUselAllChat(String chatId) =>
      _Message.getUselallChat(chatId);

  ///////////
  ///
  static String timeExtend(String chatId) => _Message.timeExtend(chatId);

  // ---------------------- Chats -----------------------------
  /// ### post/get
  static const String chats = _Chats.chats;
}

//arrow360degree@gmail.com

class _RemoteServer {
  static const String socketUrl =
      'https://backend-dana-bozzetto-7q5g.onrender.com';

  static const String baseUrl =
      'https://backend-dana-bozzetto-7q5g.onrender.com/api';
}

class _LocalHostWifi {
  // static const String socketUrl = 'http://localhost:5000';
  // static const String baseUrl = 'http://10.10.5.94:5000/api';
}

class _Auth {
  @protected
  static const String _authRoute = '${ApiEndpoints.baseUrl}/auth';
  static const String login = '$_authRoute/login';
  static const String signup = '$_authRoute/register';
  static const String logout = '$_authRoute/logout';
  static const String me = '$_authRoute/me';
  static const String updateProfile = '$_authRoute/profile';
  static const String forgetPassword = '$_authRoute/forgot-password';
  static const String refreshToken = '$_authRoute/refresh';
  static const String verifyCode = '$_authRoute/verify-otp';
  static const String verifyEmail = '$_authRoute/verify-email';
  //static const String registerVerify = '$_authRoute/verify-otp';
  static const String changePassword = '$_authRoute/password';
  static const String resetPassword = '$_authRoute/reset-password';
}

//------------------------------ Interest -----------------------------
class _Interest {
  static const String _interestRoute = '${ApiEndpoints.baseUrl}/interest';
  static const String getallInterests = '$_interestRoute/';
}

// ---------------------- Verification -----------------------------
class _Verification {
  static const String _verificationRoute =
      '${ApiEndpoints.baseUrl}/verification';
  static const String verification = '$_verificationRoute/create';
}

// ---------------------- Badges -----------------------------
class _Badges {
  static const String _badgesRoute = '${ApiEndpoints.baseUrl}/badges';
  static const String getMyBadges = '$_badgesRoute/all-badges';
  static const String allBadges = '$_badgesRoute/';
  static const String giveBadges = '$_badgesRoute/give';
}

// ---------------------- Report -----------------------------
class _Report {
  static const String _reportRoute = '${ApiEndpoints.baseUrl}/reports';
  static const String sendReport = '$_reportRoute/';
}

// ---------------------- Notification -----------------------------
class _Notification {
  static const String _notificationRoute =
      '${ApiEndpoints.baseUrl}/notifications';
  static const String getAllNotifications = _notificationRoute;
  static String markNotificationAsRead(String notificationId) =>
      '$_notificationRoute/$notificationId/read';
  // static const String readAllNotifications =
  //     '$_notificationRoute/mark-all-as-read';
  static const String marksRead = '$_notificationRoute/read-all';
  static const String markAllRead = '$_notificationRoute/read-all';
  static String deleteNotification(String notificationId) =>
      '$_notificationRoute/$notificationId';
}

// ---------------------- USER -----------------------------
class _User {
  static const String _userRoute = '${ApiEndpoints.baseUrl}/user';
  static String getuserbyId(String id) => '$_userRoute/single-user/$id';
  static const String getCurrentProfile = '$_userRoute/';
  static const String updateProfile = '$_userRoute/update-profile';

  static const String editProfile = '$_userRoute/update-profile';
  static const String uploadProfileAvatar = '$_userRoute/upload-avatar';
  static const String history = '$_userRoute/history';
  static const String allUser = '$_userRoute/all-user';
  static const String setVisibility = '$_userRoute/visibility';
  static const String status = '$_userRoute/status';
}

// ---------------------- RIDE -----------------------------
class _Ride {
  static const String _rideRoute = '${ApiEndpoints.baseUrl}/ride';
  static const String createRide = _rideRoute;
  static String updateRide(String id) => "$_rideRoute/$id";
  static String leaveRide(String id) => "$_rideRoute/$id/leave";
  static String finishRide(String id) => "$_rideRoute/$id/filter";
  static const String filterRide = _rideRoute;
  static String getRideById(String id) => "$_rideRoute/$id";
  static String joinRide(String id) => "$_rideRoute/$id/join";
  static String voteForKick(String id) => "$_rideRoute/$id/kick";
  static String deleteRide(String id) => "$_rideRoute/$id";
}

class _Booking {
  static const String _bookingRoute = '${ApiEndpoints.baseUrl}/booking';
  static const String getMyBookings = "$_bookingRoute/my";
  static String getAllBookingsForARide(String rideId) =>
      "$_bookingRoute/ride/$rideId";
}

// ---------------------- MESSAGE -----------------------------
class _Message {
  static const String _messageRoute = '${ApiEndpoints.baseUrl}/chat';
  static const String _messagesRoute = '${ApiEndpoints.baseUrl}/messages';

  static const String getAllChat = "$_messageRoute/get-chat";

  static String getSingleChat(String chatId) =>
      "$_messageRoute/get-single-chat/$chatId";

  /// Get
  static String getMessages(String chatId) => "$_messagesRoute/$chatId";

  /// Post
  static String sendMessage(String chatId) => "$_messageRoute/send-message";

  /// Put
  static String messageRead(String messageId) =>
      "$_messageRoute/read/$messageId";

  /// Put
  static String editMessage(String messageId) => "$_messageRoute/$messageId";

  /// Delete
  static String deleteMessage(String messageId) => "$_messageRoute/$messageId";

  static String getUselallChat(String chatId) => "$_messageRoute/get-chat";

  static String timeExtend(String chatId) =>
      "$_messageRoute/extend-time/$chatId";
}

// ---------------------- Chats -----------------------------
class _Chats {
  static const String _chatsRoute = '${ApiEndpoints.baseUrl}/chats';
  static const String chats = _chatsRoute;
}

// ---------------------- Finance -----------------------------
class _Finance {
  static const String _financeRoute = '${ApiEndpoints.baseUrl}/finance';
  static const String getFinances = _financeRoute;
}

// ---------------------- Client Portal -----------------------------
class _ClientPortal {
  static const String _clientPortalRoute =
      '${ApiEndpoints.baseUrl}/client-portal';
  static const String dashboard = '$_clientPortalRoute/dashboard';
  static const String getClientDocuments = '$_clientPortalRoute/documents';
  static const String getClientApprovals = '$_clientPortalRoute/approvals';
  static const String search = '$_clientPortalRoute/search';
  static String updateClientApproval(String approvalId) =>
      '$_clientPortalRoute/approvals/$approvalId';
}

// ---------------------- Team Portal -----------------------------
class _TeamPortal {
  static const String _teamPortalRoute = '${ApiEndpoints.baseUrl}/team-portal';
  static const String dashboard = '$_teamPortalRoute/dashboard';
  static const String getTeamMemberDocuments = '$_teamPortalRoute/documents';
  static const String search = '$_teamPortalRoute/search';
  static const String approvals = '$_teamPortalRoute/approvals';
}

// ---------------------- Projects -----------------------------
class _Project {
  static const String _projectRoute = '${ApiEndpoints.baseUrl}/projects';
  static const String projects = '$_projectRoute/';
  static String projectById(String projectId) => '$_projectRoute/$projectId';
}

// ---------------------- Tasks -----------------------------
class _Tasks {
  static const String _tasksRoute = '${ApiEndpoints.baseUrl}/tasks';
  static const String tasks = _tasksRoute;
  static String projectTasks(String projectId) =>
      '$_tasksRoute/?projectId=$projectId';
  static String submitTask(String taskId) => '$_tasksRoute/$taskId/submit';
}

// ---------------------- Documents -----------------------------
class _Documents {
  static const String _documentsRoute = '${ApiEndpoints.baseUrl}/documents';
  static String projectDocuments(String projectId) =>
      '$_documentsRoute/project/$projectId';
}

// ---------------------- Settings -----------------------------
class _Settings {
  static const String settings = '${ApiEndpoints.baseUrl}/settings';
}
