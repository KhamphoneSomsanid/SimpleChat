import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';

const String DOMAIN = 'simplechat.laodev.info';
const String SOCKET = 'http://192.168.1.2:3000';

const String avatarUrl = 'https://' + DOMAIN + '/uploads/ic_avatar.png';

const appSettingInfo = {
  'isNearby': false,
  'isVideoStory': false,
  'isReplyComment': false,
  'isVoiceCall': false,
  'isVideoCall': false,
};

final tagMask = new MaskTextInputFormatter(
    mask: '###############', filter: {"#": RegExp(r'^[a-z0-9]')});

final phoneMask = new MaskTextInputFormatter(
    mask: '(###) ###-####', filter: {"#": RegExp(r'[0-9]')});
final expiryDateMask = new MaskTextInputFormatter(
    mask: '##/####', filter: {"#": RegExp(r'[0-9]')});
final digits4Mask =
new MaskTextInputFormatter(mask: '####', filter: {"#": RegExp(r'[0-9]')});
final cvvMask =
new MaskTextInputFormatter(mask: '###', filter: {"#": RegExp(r'[0-9]')});

const List<String> reviewIcons = [
  'assets/icons/ic_review_like.png',
  'assets/icons/ic_review_funny.png',
  'assets/icons/ic_review_love.png',
  'assets/icons/ic_review_angry.png',
  'assets/icons/ic_review_sad.png',
  'assets/icons/ic_review_wow.png',
];

const String notSupport = 'This feature is not supported yet.';
