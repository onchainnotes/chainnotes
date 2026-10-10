// Ensures WalletCore C symbols used by Dart FFI are linked when using static CocoaPods linkage.
#import <WalletCore/TWString.h>

__attribute__((used))
static void flutter_trust_wallet_core_force_link(void) {
  const char empty[] = "";
  TWString* value = TWStringCreateWithUTF8Bytes(empty);
  if (value != NULL) {
    TWStringDelete(value);
  }
}
