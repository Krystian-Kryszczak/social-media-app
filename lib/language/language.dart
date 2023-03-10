import 'dart:developer';

import 'package:flutter/widgets.dart';

import '../../io/storage/local_storage.dart';

class Language extends ChangeNotifier {
  // -------------------------------------------------- //
  static String getLangPhrase(Phrase phrase) => _LanguageData.getLanguageMap(_LanguageData.selectedLang)[phrase]??'';
  static Lang get selectedLang => _LanguageData._selectedLang;
  static void changeLanguage(Lang language) {
    _LanguageData._selectedLang = language;
    _LanguageData.setLanguage(language);
    log('Language has been changed to ${language.name}');
  }
  static Future<void> setUp() async => _LanguageData.setUp();
  // -------------------------------------------------- //
  String getTranslation(Phrase phrase) => _LanguageData.getLanguageMap(_LanguageData.selectedLang)[phrase]??'';
}
enum Phrase {
  // Common
  hello,
  whatsUp,
  ok,
  error,
  menu,
  more,
  unknown,
  lackOfInfo,
  // Operations //
  add,
  edit,
  create,
  publish,
  filter,
  addCaption,
  tagPeople,
  addLocation,
  advancedSettings,
  // Operations results //
  watchSuccessfullyUploaded,
  watchUploadFailed,
  lookSuccessfullyUploaded,
  lookUploadFailed,
  // Comments //
  comments,
  writeComment,
  theMostRelevant,
  theLatest,
  allComments,
  // Media //
  media,
  video,
  videos,
  image,
  images,
  audio,
  audios,
  // Exhibit //
  live,
  lives,
  //
  groups,
  pages,
  //
  watch,
  films,
  saved,
  reels,
  events,
  //
  weather,
  rules,
  //
  stories,
  // Watch //
  subscribe,
  subscriptions,
  // Publish //
  createPost,
  addToStory,
  addRelation,
  // Searching //
  search,
  searchFriends,
  // Messenger //
  messenger,
  chats,
  connections,
  activeUsers,
  newMessage,
  typeMessage,
  createGroupChat,
  createVideoCall,
  proposed, from, to,
  enterNameAndSurnameOrGroupName,
  active, lastActive,
  // SingInScreen // 
  signIn,
  enterYourEmail,
  enterYourPassword,
  pleaseEnterYourEmail,
  pleaseEnterValidEmail,
  pleaseEnterYourPassword,
  rememberMe,
  signInButton,
  notRegisteredYet,
  createAnAccount,
  accountActivation,
  activateAccountInfo,
  enterActivationCode,
  invalidActivationCode,
  activate,
  // SingInScreen - Errors //
  wrongLoginData,
  // RegisterScreen //
  register,
  name, surname,
  pleaseEnterYourName,
  pleaseEnterYourSurname,
  registerButton,
  alreadyRegistered,
  // RegisterScreen - Errors //
  registerFailed,
  registerConflict,
  // Auth //
  logout,
  switchUser,
  // Profile //
  yourProfile,
  profile,
  profileHome,
  profileVideo,
  profileShorts,
  profileImages,
  profilePosts,
  profileMusic,
  profileChannels,
  profileInformation,
  // Music //
  music,
  explore,
  library,
  // Exhibit Details //
  views,
  second,
  seconds,
  minute,
  minutes,
  hour,
  hours,
  day,
  days,
  week,
  weeks,
  month,
  months,
  year,
  years,
  momentAgo,
  ago,
  thousands,
  millions,
  billions,
  created,
  published,
  lastUpdate,
  // Gallery //
  gallery,
  selectImages,
  // Permissions //
  permissionDenied,
  givePermission,
  // Processing //
  loading,
  noAvailablePosts,
  noAvailableWatches,
  noAvailableFiles,
  // Forms //
  selectItem,
  // Create Overlays //
  publishOverlay,
  watchOverlay,
  lookOverlay,
  relationOverlay,
  reelOverlay,
  shutterOverlay, // similar to snapchat
  // New //
  newWatch,
  newLook,
  // Settings //
  settings,
  language,
  themeMode,
  // Choices //
  selected,
  // Languages //
  english,
  polish,
  // Complexity //
  advanced,
  // Rarity //
  common,
  rare,
  // Activities //
  share,
  // ThemeMode //
  light, dark, system,
  // Other //
  helpCenter,
  security,
  reportProblem,
  // Semantic Labels //
  showMenu,
  // Errors //
  itNotHaveUrlToShare,
}
class _Languages {
  static const Map<Phrase, String> english = {
    // Common
    Phrase.hello: 'Hello',
    Phrase.whatsUp: 'What\'s up?',
    Phrase.ok: 'OK',
    Phrase.error: 'Error',
    Phrase.menu: 'Menu',
    Phrase.more: 'More',
    Phrase.unknown: 'Unknown',
    Phrase.lackOfInfo: 'Lack of information.',
    // Operations //
    Phrase.add: 'Add',
    Phrase.edit: 'Edit',
    Phrase.create: 'Create',
    Phrase.publish: 'Publish',
    Phrase.filter: 'Filter',
    Phrase.addCaption: 'Add caption...',
    Phrase.tagPeople: 'Tag people',
    Phrase.addLocation: 'Add location',
    Phrase.advancedSettings: 'Advanced settings',
    // Operations results //
    Phrase.watchSuccessfullyUploaded: 'The video has been successfully uploaded.',
    Phrase.watchUploadFailed: 'Video upload failed.',
    Phrase.lookSuccessfullyUploaded: 'The image has been successfully uploaded.',
    Phrase.lookUploadFailed: 'Image upload failed.',
    // Watch //
    Phrase.subscribe: 'Subscribe',
    Phrase.subscriptions: 'Subscriptions',
    // Publish //
    Phrase.createPost: 'Create post',
    Phrase.stories: 'Stories',
    Phrase.search: 'Search',
    Phrase.searchFriends: 'Search friends',
    Phrase.addToStory: 'Add to Story',
    Phrase.addRelation: 'Add relations',
    // Comments //
    Phrase.comments: 'Comments',
    Phrase.writeComment: 'Write a comment',
    Phrase.theMostRelevant: 'The most relevant',
    Phrase.theLatest: 'The latest',
    Phrase.allComments: 'All comments',
    // Media //
    Phrase.media: 'Media',
    Phrase.video: 'Video',
    Phrase.videos: 'Videos',
    Phrase.image: 'Image',
    Phrase.images: 'Images',
    Phrase.audio: 'Audio',
    Phrase.audios: 'Audio',
    // Exhibit //
    Phrase.watch: 'Watch',
    Phrase.live: 'Live',
    Phrase.lives: 'Lives',
    Phrase.groups: 'Groups',
    Phrase.pages: 'Pages',
    Phrase.films: 'Films',
    Phrase.saved: 'Saved',
    Phrase.reels: 'Reels',
    Phrase.events: 'Events',
    //
    Phrase.weather: 'Weather',
    Phrase.rules: 'Rules',
    // Messenger
    Phrase.messenger: 'Messenger',
    Phrase.chats: 'Chats',
    Phrase.connections: 'Connections',
    Phrase.activeUsers: 'Active users',
    Phrase.newMessage: 'New message',
    Phrase.typeMessage: 'Type message',
    Phrase.createGroupChat: 'Create Group Chat',
    Phrase.createVideoCall: 'Create Video Call',
    Phrase.proposed: 'Proposed',
    Phrase.from: 'From',
    Phrase.to: 'To',
    Phrase.enterNameAndSurnameOrGroupName: 'Enter name and surname or group name',
    Phrase.active: 'Active',
    Phrase.lastActive: 'Active {?} ago',
    // SingInScreen // 
    Phrase.signIn: 'Sign in',
    Phrase.enterYourEmail: 'Enter your email',
    Phrase.enterYourPassword: 'Enter your password',
    Phrase.pleaseEnterYourEmail: 'Please enter your email',
    Phrase.pleaseEnterValidEmail: 'Please enter a valid email',
    Phrase.pleaseEnterYourPassword: 'Please enter your password',
    Phrase.rememberMe: 'Remember me',
    Phrase.signInButton: 'Sign in',
    Phrase.notRegisteredYet: 'Not registered yet?',
    Phrase.createAnAccount: 'Create an account',
    // SingInScreen - Errors //
    Phrase.wrongLoginData: 'Wrong username or password!',
    // RegisterScreen //
    Phrase.register: 'Register',
    Phrase.name: 'Name',
    Phrase.surname: 'Surname',
    Phrase.pleaseEnterYourName: 'Please enter your name',
    Phrase.pleaseEnterYourSurname: 'Please enter your surname',
    Phrase.registerButton: 'Register',
    Phrase.alreadyRegistered: 'Already registered?',
    // RegisterScreen - Errors //
    Phrase.registerFailed: 'Something went wrong! Account not was created!',
    Phrase.registerConflict: 'Account with this email already exists.',
    // Auth //
    Phrase.logout: 'Logout',
    Phrase.switchUser: 'Switch user',
    // Account Activation //
    Phrase.accountActivation: 'Account activation',
    Phrase.activateAccountInfo: 'Activation code has been sent to your email: ',
    Phrase.enterActivationCode: 'Enter your activation code',
    Phrase.invalidActivationCode: 'The given code is invalid. Try again!',
    Phrase.activate: 'Activate',
    // Profile //
    Phrase.yourProfile: 'Your profile',
    Phrase.profile: 'Profile',
    Phrase.profileHome: 'Home',
    Phrase.profileVideo: 'Video',
    Phrase.profileShorts: 'Shorts',
    Phrase.profileImages: 'Images',
    Phrase.profilePosts: 'Posts',
    Phrase.profileMusic: 'Music',
    Phrase.profileChannels: 'Channels',
    Phrase.profileInformation: 'Information',
    // Music //
    Phrase.music: 'Music',
    Phrase.explore: 'Explore',
    Phrase.library: 'Library',
    // Exhibit Details //
    Phrase.views: 'views',
    Phrase.second: 'a second',
    Phrase.seconds: 'seconds',
    Phrase.minute: 'a minute',
    Phrase.minutes: 'minutes',
    Phrase.hour: 'a hour',
    Phrase.hours: 'hours',
    Phrase.day: 'a day',
    Phrase.days: 'days',
    Phrase.week: 'a week',
    Phrase.weeks: 'weeks',
    Phrase.month: 'a month',
    Phrase.months: 'months',
    Phrase.year: 'a year',
    Phrase.years: 'years',
    Phrase.momentAgo: 'a moment ago',
    Phrase.ago: 'ago',
    Phrase.thousands: 'k',
    Phrase.millions: 'mill',
    Phrase.billions: 'bil.',
    Phrase.created: 'Created',
    Phrase.published: 'Published',
    Phrase.lastUpdate: 'Last update',
    // Gallery //
    Phrase.gallery: 'Gallery',
    Phrase.selectImages: 'Choice images',
    // Permissions //
    Phrase.permissionDenied: 'Permission denied!',
    Phrase.givePermission: 'Give permission',
    // Processing //
    Phrase.loading: 'Loading',
    Phrase.noAvailablePosts: 'No available posts.',
    Phrase.noAvailableWatches: 'No available videos.',
    Phrase.noAvailableFiles: 'No available files.',
    // Forms //
    Phrase.selectItem: 'Select item',
    // Create Overlays //
    Phrase.publishOverlay: 'Publish',
    Phrase.watchOverlay: 'Video',
    Phrase.relationOverlay: 'Relation',
    Phrase.reelOverlay: 'Reel',
    Phrase.shutterOverlay: 'Shutter',
    Phrase.lookOverlay: 'Image',
    // New //
    Phrase.newLook: 'New image',
    Phrase.newWatch: 'New video',
    // Settings //
    Phrase.settings: 'Settings',
    Phrase.language: 'Language',
    Phrase.themeMode: 'ThemeMode',
    // Choices //
    Phrase.selected: 'Selected',
    // Languages //
    Phrase.english: 'English',
    Phrase.polish: 'Polish (Polski)',
    // Complexity //
    Phrase.advanced: 'Advanced',
    // Rarity //
    Phrase.common: 'Common',
    Phrase.rare: 'Rare',
    // Activities //
    Phrase.share: 'Share',
    // ThemeMode //
    Phrase.light: 'Light', Phrase.dark: 'Dark', Phrase.system: 'System',
    // Other //
    Phrase.helpCenter: 'Help Center',
    Phrase.security: 'Security',
    Phrase.reportProblem: 'Report a problem',
    // Semantic Labels //
    Phrase.showMenu: 'Show menu',
    // Errors //
    Phrase.itNotHaveUrlToShare: 'There is no url to share',
  };
  static const Map<Phrase, String> polish = {
    // Common
    Phrase.hello: 'Witaj',
    Phrase.whatsUp: 'Co s??ycha???',
    Phrase.ok: 'OK',
    Phrase.error: 'Wyst??pi?? b????d',
    Phrase.menu: 'Menu',
    Phrase.more: 'Wi??cej',
    Phrase.unknown: 'Nieznany',
    Phrase.lackOfInfo: 'Brak informacji.',
    // Operations //
    Phrase.add: 'Dodaj',
    Phrase.edit: 'Edytuj',
    Phrase.create: 'Stw??rz',
    Phrase.publish: 'Opublikuj',
    Phrase.filter: 'Filtr',
    Phrase.addCaption: 'Dodaj opis...',
    Phrase.tagPeople: 'Oznacz osoby',
    Phrase.addLocation: 'Dodaj lokalizacj??',
    Phrase.advancedSettings: 'Ustawienia zaawansowane',
    // Operations results //
    Phrase.watchSuccessfullyUploaded: 'Video zosta??o pomy??lnie wys??ane.',
    Phrase.watchUploadFailed: 'Wyst??pi?? b????d podczas wysy??ania video!',
    Phrase.lookSuccessfullyUploaded: 'Zdj??cie zosta??o pomy??lnie wys??ane.',
    Phrase.lookUploadFailed: 'Wyst??pi?? b????d podczas wysy??ania zdj??cia!',
    // Watch //
    Phrase.subscribe: 'Subskrybuj',
    Phrase.subscriptions: 'Subskrybcji',
    // Publish //
    Phrase.createPost: 'Utw??rz post',
    Phrase.stories: 'Stories',
    Phrase.search: 'Szukaj',
    Phrase.searchFriends: 'Szukaj znajomych',
    Phrase.addToStory: 'Dodaj do story',
    Phrase.addRelation: 'Dodaj relacj??',
    // Comments //
    Phrase.comments: 'Komentarze',
    Phrase.writeComment: 'Dodaj komentarz',
    Phrase.theMostRelevant: 'Najtrafniejsze',
    Phrase.theLatest: 'Najnowsze',
    Phrase.allComments: 'Wszystkie komentarze',
    // Media //
    Phrase.media: 'Media',
    Phrase.video: 'Video',
    Phrase.videos: 'Video',
    Phrase.image: 'Obraz',
    Phrase.images: 'Obrazy',
    Phrase.audio: 'Audio',
    Phrase.audios: 'Audio',
    // Exhibit //
    Phrase.watch: 'Watch',
    Phrase.live: 'Transmisja na ??ywo',
    Phrase.lives: 'Transmisje na ??ywo',
    Phrase.groups: 'Grupy',
    Phrase.pages: 'Strony',
    Phrase.films: 'Filmy',
    Phrase.saved: 'Zapisane',
    Phrase.reels: 'Rolki',
    Phrase.events: 'Wydarzenia',
    //
    Phrase.weather: 'Pogoda',
    Phrase.rules: 'Regulamin i zasady',
    // Messenger
    Phrase.messenger: 'Messenger',
    Phrase.chats: 'Czaty',
    Phrase.connections: 'Po????czenia',
    Phrase.activeUsers: 'Aktywnie osoby',
    Phrase.newMessage: 'Nowa wiadomo????',
    Phrase.typeMessage: 'Wpisz wiadomo????',
    Phrase.createGroupChat: 'Utw??rz czat grupowy',
    Phrase.createVideoCall: 'Utw??rz rozmow?? wideo',
    Phrase.proposed: 'Proponowane',
    Phrase.from: 'Od',
    Phrase.to: 'Do',
    Phrase.active: 'Aktywny',
    Phrase.lastActive: 'Aktywny {?} temu',
    // SingInScreen // 
    Phrase.signIn: 'Logowanie',
    Phrase.enterYourEmail: 'Wpisz adres email',
    Phrase.enterYourPassword: 'Wpisz has??o',
    Phrase.pleaseEnterYourEmail: 'Prosz?? wpisz sw??j adres email',
    Phrase.pleaseEnterValidEmail: 'Prosz?? wpisz poprawny adres email',
    Phrase.pleaseEnterYourPassword: 'Prosz?? podaj swoje has??o',
    Phrase.rememberMe: 'Zapami??taj mnie',
    Phrase.signInButton: 'Zaloguj',
    Phrase.notRegisteredYet: 'Nie masz jeszcze konta?',
    Phrase.createAnAccount: 'Stw??rz nowe konto',
    // SingInScreen - Errors //
    Phrase.wrongLoginData: 'Z??a nazwa u??ytkownika lub has??o!',
    // RegisterScreen //
    Phrase.register: 'Zarejestruj si??',
    Phrase.name: 'Imi??',
    Phrase.surname: 'Nazwisko',
    Phrase.pleaseEnterYourName: 'Prosz?? podaj swoje imi??',
    Phrase.pleaseEnterYourSurname: 'Prosz?? podaj swoje nazwisko',
    Phrase.registerButton: 'Utw??rz konto',
    Phrase.alreadyRegistered: 'Posiadasz ju?? konto?',
    // RegisterScreen - Errors //
    Phrase.registerFailed: 'Co?? posz??o ??le, rejestracja nieudana!',
    Phrase.registerConflict: 'Konto z takim adresem email ju?? istnieje!',
    // Auth //
    Phrase.logout: 'Wyloguj si??',
    Phrase.switchUser: 'Zmie?? u??ytkownika',
    // Account Activation //
    Phrase.accountActivation: 'Aktywacja konta',
    Phrase.activateAccountInfo: 'Kod aktywacyjny zosta?? wys??any na Tw??j adres e-mail: ',
    Phrase.enterActivationCode: 'Podaj sw??j kod aktywacyjny',
    Phrase.invalidActivationCode: 'Podany kod jest niepoprawny. Spr??buj ponownie!',
    Phrase.activate: 'Aktywuj',
    // Profile //
    Phrase.yourProfile: 'Tw??j profil',
    Phrase.profile: 'Profil',
    Phrase.profileHome: 'G????wna',
    Phrase.profileVideo: 'Video',
    Phrase.profileShorts: 'Shorty',
    Phrase.profileImages: 'Zdj??cia',
    Phrase.profilePosts: 'Posty',
    Phrase.profileMusic: 'Muzyka',
    Phrase.profileChannels: 'Kana??y',
    Phrase.profileInformation: 'Informacje',
    // Music //
    Phrase.music: 'Muzyka',
    Phrase.explore: 'Odkrywaj',
    Phrase.library: 'Biblioteka',
    // Exhibit Details //
    Phrase.views: 'wy??wietle??',
    Phrase.second: 'sekunda',
    Phrase.seconds: 'sekund',
    Phrase.minute: 'minuta',
    Phrase.minutes: 'minut',
    Phrase.hour: 'godzina',
    Phrase.hours: 'godzin',
    Phrase.day: 'dzie??',
    Phrase.days: 'dni',
    Phrase.week: 'tydzie??',
    Phrase.weeks: 'tygodnie',
    Phrase.month: 'miesi??c',
    Phrase.months: 'miesi??ce',
    Phrase.year: 'rok',
    Phrase.years: 'lata',
    Phrase.momentAgo: 'przed chwil??',
    Phrase.ago: 'temu',
    Phrase.thousands: 'ty??.',
    Phrase.millions: 'mln',
    Phrase.billions: 'mld',
    Phrase.created: 'Utworzony',
    Phrase.published: 'Opublikowany',
    Phrase.lastUpdate: 'Ostatnia aktualizacja',
    // Gallery //
    Phrase.gallery: 'Galeria',
    Phrase.selectImages: 'Wybierz zdj??cia',
    // Permissions //
    Phrase.permissionDenied: 'Brak uprawnie??!',
    Phrase.givePermission: 'Upowa??nij',
    // Processing //
    Phrase.loading: '??adowanie',
    // Forms //
    Phrase.selectItem: 'Wybierz',
    Phrase.noAvailablePosts: 'Brak dost??pnych post??w.',
    Phrase.noAvailableWatches: 'Brak dost??pnych materia????w video.',
    Phrase.noAvailableFiles: 'Brak dost??pnych plik??w.',
    // Create Overlays //
    Phrase.publishOverlay: 'Opublikuj',
    Phrase.watchOverlay: 'Wideo',
    Phrase.relationOverlay: 'Relacja',
    Phrase.reelOverlay: 'Rolka',
    Phrase.shutterOverlay: 'Migawka',
    Phrase.lookOverlay: 'Zdj??cie',
    // New //
    Phrase.newLook: 'Nowe zdj??cie',
    Phrase.newWatch: 'Nowe video',
    // Settings //
    Phrase.settings: 'Ustawienia',
    Phrase.language: 'J??zyk',
    Phrase.themeMode: 'Motyw',
    // Choices //
    Phrase.selected: 'Wybrano',
    // Languages //
    Phrase.english: 'Angielski (English)',
    Phrase.polish: 'Polski',
    // Complexity //
    Phrase.advanced: 'Zaawansowane',
    // Rarity //
    Phrase.common: 'Pospolite',
    Phrase.rare: 'Rzadkie',
    // Activities //
    Phrase.share: 'Udost??pnij',
    // ThemeMode //
    Phrase.light: 'Jasny', Phrase.dark: 'Ciemny', Phrase.system: 'System',
    // Other //
    Phrase.helpCenter: 'Centrum pomocy',
    Phrase.security: 'Bezpiecze??stwo',
    Phrase.reportProblem: 'Zg??o?? problem',
    // Semantic Labels //
    Phrase.showMenu: 'Poka?? menu',
    // Errors //
    Phrase.itNotHaveUrlToShare: 'Brak adresu url do udost??pnienia!',
  };
}
enum Lang {
  // -------------------------------------------------- //
  english(langPhrase: Phrase.english),
  polish(langPhrase: Phrase.polish);
  // -------------------------------------------------- //
  final Phrase langPhrase;
  const Lang({required this.langPhrase});
  // -------------------------------------------------- //
  String getLangPhrase(Phrase phrase) => _LanguageData.getLanguageMap(this)[phrase]??'';
}
class _LanguageData {
  // -------------------------------------------------- //
  static const String langKey = 'language';
  static const Lang defaultLang = Lang.polish;
  // -------------------------------------------------- //
  static Lang _selectedLang = defaultLang;
  static Lang get selectedLang => _selectedLang;
  // -------------------------------------------------- //
  static String getLangPhrase(Phrase phrase) => getLanguageMap(selectedLang)[phrase]??'';
  static Future<String> getSelectedLangName() async => LocalStorage.readString(key: langKey).then((value) => value ?? _selectedLang.toString());
  static Future<Lang> getLangFromString(String languageName) async => Lang.values.firstWhere((lang) => languageName==lang.name, orElse: ()=>Lang.polish);
  static Future<bool> setLanguage(Lang language) async => LocalStorage.writeString(key: langKey, value: language.name);
  // -------------------------------------------------- //
  static Map<Phrase, String> getLanguageMap(Lang lang) => lang==Lang.polish ? _Languages.polish : _Languages.english;
  // -------------------------------------------------- //
  static Future<void> setUp() async => LocalStorage.readString(key: langKey).then((saved){if (saved!=null) getLangFromString(saved).then((def) => _selectedLang = def);});
}
