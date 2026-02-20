#import <Foundation/Foundation.h>

#if __has_attribute(swift_private)
#define AC_SWIFT_PRIVATE __attribute__((swift_private))
#else
#define AC_SWIFT_PRIVATE
#endif

/// The resource bundle ID.
static NSString * const ACBundleID AC_SWIFT_PRIVATE = @"com.myapp.ios";

/// The "AccentColor" asset catalog color resource.
static NSString * const ACColorNameAccentColor AC_SWIFT_PRIVATE = @"AccentColor";

/// The "OnboardingCompatibility" asset catalog image resource.
static NSString * const ACImageNameOnboardingCompatibility AC_SWIFT_PRIVATE = @"OnboardingCompatibility";

/// The "OnboardingRoutine1" asset catalog image resource.
static NSString * const ACImageNameOnboardingRoutine1 AC_SWIFT_PRIVATE = @"OnboardingRoutine1";

/// The "OnboardingRoutine2" asset catalog image resource.
static NSString * const ACImageNameOnboardingRoutine2 AC_SWIFT_PRIVATE = @"OnboardingRoutine2";

/// The "OnboardingRoutine3" asset catalog image resource.
static NSString * const ACImageNameOnboardingRoutine3 AC_SWIFT_PRIVATE = @"OnboardingRoutine3";

/// The "OnboardingScanning" asset catalog image resource.
static NSString * const ACImageNameOnboardingScanning AC_SWIFT_PRIVATE = @"OnboardingScanning";

#undef AC_SWIFT_PRIVATE
