#import <UIKit/UIKit.h>
#import <Cephei/HBPreferences.h>

HBPreferences* preferences;

extern BOOL enabled;

NSString* alphaValue = @"0.4";

@interface _UIContextMenuContainerView : UIView
-(id)dismissalHandler;
@end

@interface SBIconController : UIViewController
-(id)containerViewForPresentingContextMenuForIconView:(id)iconView ;
@end

@interface SBIconView : UIView
-(id)applicationBundleIdentifier ;
-(id)_iconImageView;
-(id)folder;
@end

@interface SBIconImageView : UIView
-(id)_currentOverlayImage;
@end

@interface UIImage(MyCategory)
+(id)_applicationIconImageForBundleIdentifier:(id)arg1 format:(int)arg2 scale:(double)arg3 ;
@end

@interface _UIPreviewPlatterPresentationController : UIPresentationController
-(void)_handleDismissalTapGesture:(id)arg1 ;
@end