import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';

const String DOMAIN = 'simplechat.laodev.info';
const String SOCKET = 'http://192.168.1.2:3000';

const String avatarUrl = 'https://' + DOMAIN + '/uploads/ic_avatar.png';

const appSettingInfo = {
  'isNearby': false,
  'isVideoStory': false,
  'isChat': false,
  'isApp': false,
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