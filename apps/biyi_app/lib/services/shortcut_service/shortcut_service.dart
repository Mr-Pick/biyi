import 'package:biyi_app/services/local_db/local_db.dart';
import 'package:hotkey_manager/hotkey_manager.dart';
import 'package:uni_platform/uni_platform.dart';

abstract mixin class ShortcutListener {
  void onShortcutKeyDownShowOrHide();
  void onShortcutKeyDownHide();
  void onShortcutKeyDownExtractFromScreenSelection();
  void onShortcutKeyDownExtractFromScreenCapture();
  void onShortcutKeyDownExtractFromClipboard();
  void onShortcutKeyDownTranslateInputContent();
  void onShortcutKeyDownSubmitWithMateEnter();
}

class ShortcutService {
  ShortcutService._();

  /// The shared instance of [ShortcutService].
  static final ShortcutService instance = ShortcutService._();

  ShortcutListener? _listener;

  Configuration get _configuration => localDb.configuration;

  void setListener(ShortcutListener? listener) {
    _listener = listener;
  }

  Future<void> start() async {
    await hotKeyManager.unregisterAll();
    await hotKeyManager.register(
      _configuration.shortcutInputSettingSubmitWithMetaEnter,
      keyDownHandler: (_) {
        _listener?.onShortcutKeyDownSubmitWithMateEnter();
      },
    );
    await hotKeyManager.register(
      _configuration.shortcutShowOrHide,
      keyDownHandler: (_) {
        _listener?.onShortcutKeyDownShowOrHide();
      },
    );
    await hotKeyManager.register(
      _configuration.shortcutHide,
      keyDownHandler: (_) {
        _listener?.onShortcutKeyDownHide();
      },
    );
    await hotKeyManager.register(
      _configuration.shortcutExtractFromScreenSelection,
      keyDownHandler: (_) {
        _listener?.onShortcutKeyDownExtractFromScreenSelection();
      },
    );
    if (!UniPlatform.isLinux) {
      await hotKeyManager.register(
        _configuration.shortcutExtractFromScreenCapture,
        keyDownHandler: (_) {
          _listener?.onShortcutKeyDownExtractFromScreenCapture();
        },
      );
    }
    await hotKeyManager.register(
      _configuration.shortcutExtractFromClipboard,
      keyDownHandler: (_) {
        _listener?.onShortcutKeyDownExtractFromClipboard();
      },
    );
    if (!UniPlatform.isLinux) {
      await hotKeyManager.register(
        _configuration.shortcutTranslateInputContent,
        keyDownHandler: (_) {
          _listener?.onShortcutKeyDownTranslateInputContent();
        },
      );
    }
  }

  void stop() {
    hotKeyManager.unregisterAll();
  }
}
