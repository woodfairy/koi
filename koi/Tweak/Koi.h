#import <UIKit/UIKit.h>
#import <Cephei/HBPreferences.h>
#import <QuartzCore/QuartzCore.h>
#import <Kitten/libKitten.h>

HBPreferences* preferences;
libKitten* nena;

extern BOOL enabled;

NSString* alphaValue = @"0.5";


@interface _UIContextMenuContainerView : UIView
- (id)dismissalHandler;
@end

@interface SBIconController : UIViewController
- (id)containerViewForPresentingContextMenuForIconView:(id)iconView;
- (void)_forceTouchControllerWillPresent:(id)arg1;
@end

@interface SBIconView : UIView
- (id)_iconImageView;
- (id)folder;
- (void)activateShortcut:(id)item withBundleIdentifier:(NSString*)bundleID forIconView:(id)iconView;
@end

@interface SBFolder : NSObject
-(NSArray *)icons;
@end

@interface UIImage (Koi)
+ (id)_applicationIconImageForBundleIdentifier:(id)arg1 format:(int)arg2 scale:(double)arg3;
@end

@interface _UIPreviewPlatterPresentationController : UIPresentationController
- (void)_handleDismissalTapGesture:(id)arg1;
@end

