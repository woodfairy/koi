#import <UIKit/UIKit.h>
#import <Cephei/HBPreferences.h>

HBPreferences* preferences;

extern BOOL enabled;

NSString* alphaValue = @"0.4";

@interface _UIContextMenuContainerView : UIView
@end

@interface SBIconController : UIViewController
-(id)containerViewForPresentingContextMenuForIconView:(id)arg1 ;
@end

@interface SBIconView : UIView
-(id)applicationBundleIdentifier ;
-(id)_iconImageView;
@end

@interface SBIconImageView : UIView
-(id)_currentOverlayImage;
@end

@interface UIImage(MyCategory)
+(id)_applicationIconImageForBundleIdentifier:(id)arg1 format:(int)arg2 scale:(double)arg3 ;
@end