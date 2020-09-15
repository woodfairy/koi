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
@end