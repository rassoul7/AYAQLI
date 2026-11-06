import 'package:flutter/material.dart';

enum SessionState { none, guest, signedIn }

enum AppTab { search, learn, profile }

enum PlaybackSpeed {
  x1('1×', 1.0),
  x075('0.75×', 0.75),
  x05('0.5×', 0.5);

  final String label;
  final double value;
  const PlaybackSpeed(this.label, this.value);

  PlaybackSpeed get next => switch (this) {
        PlaybackSpeed.x1 => PlaybackSpeed.x075,
        PlaybackSpeed.x075 => PlaybackSpeed.x05,
        PlaybackSpeed.x05 => PlaybackSpeed.x1,
      };
}

/// Global app state: session, preferences, and the "currently playing verse"
/// so the mini player can stay in sync across screens. Review/session-local
/// state (SRS queue progress, search query) stays local to its screen.
class AppState extends ChangeNotifier {
  SessionState session = SessionState.none;
  String? userEmail;

  ThemeMode themeMode = ThemeMode.system;
  String language = 'fr'; // 'fr' | 'en'
  String favoriteReciter = 'alafasy';

  AppTab currentTab = AppTab.search;

  // Audio (shared across Search results, Detail, and the mini player).
  String? playingVerseId;
  String? playingVerseLabel; // "Al-Baqarah 2:286"
  String? playingConcept;
  bool isPlaying = false;
  int activeWordIndex = 0;
  bool loop = false;
  PlaybackSpeed speed = PlaybackSpeed.x1;

  /// Set by whichever screen starts playback; lets the mini player open the
  /// right Detail screen without the state layer needing to know verse types.
  VoidCallback? onOpenPlayingVerseDetail;

  void signInWithEmail(String email) {
    session = SessionState.signedIn;
    userEmail = email;
    notifyListeners();
  }

  void continueAsGuest() {
    session = SessionState.guest;
    notifyListeners();
  }

  void signOut() {
    session = SessionState.none;
    userEmail = null;
    currentTab = AppTab.search;
    stopPlayback();
    notifyListeners();
  }

  void setTab(AppTab tab) {
    currentTab = tab;
    notifyListeners();
  }

  void setThemeMode(ThemeMode mode) {
    themeMode = mode;
    notifyListeners();
  }

  void setLanguage(String lang) {
    language = lang;
    notifyListeners();
  }

  void setFavoriteReciter(String slug) {
    favoriteReciter = slug;
    notifyListeners();
  }

  void startPlayback({
    required String verseId,
    required String label,
    String? concept,
    VoidCallback? onOpenDetail,
  }) {
    playingVerseId = verseId;
    playingVerseLabel = label;
    playingConcept = concept;
    onOpenPlayingVerseDetail = onOpenDetail;
    isPlaying = true;
    activeWordIndex = 0;
    notifyListeners();
  }

  void togglePlayPause() {
    if (playingVerseId == null) return;
    isPlaying = !isPlaying;
    notifyListeners();
  }

  void setActiveWordIndex(int index) {
    activeWordIndex = index;
    notifyListeners();
  }

  void toggleLoop() {
    loop = !loop;
    notifyListeners();
  }

  void cycleSpeed() {
    speed = speed.next;
    notifyListeners();
  }

  void stopPlayback() {
    playingVerseId = null;
    playingVerseLabel = null;
    playingConcept = null;
    isPlaying = false;
    activeWordIndex = 0;
    notifyListeners();
  }
}
