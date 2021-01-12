class ChattingRoom {
  String _boardType; //게시판 종류
  String get boardType => _boardType;
  set boardType(String boardType) => _boardType = boardType;

  String _title; //게시글 제목
  String get title => _title;
  set title(String title) => _title = title;

  List _users; //채팅방 참여 유저
  List get users => _users;
  set users(List users) => _users = users;

  String _recentchattext; //최근 텍스트
  String get recentchattext => _recentchattext;
  set recentchattext(String recentchattext) => _recentchattext = recentchattext;

  String _recentchattime; //최근 채팅 시간
  String get recentchattime => _recentchattime;
  set recentchattime(String recentchattime) => _recentchattime = recentchattime;

  String _readcount; //읽지 않은 수
  String get readcount => _readcount;
  set readcount(String readcount) => _readcount = readcount;

  String _timestamp; //
  String get timestamp => _timestamp;
  set timestamp(String timestamp) => _timestamp = timestamp;
}
