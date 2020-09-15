#import <UIKit/UIKit.h>
#import <Cephei/HBPreferences.h>

HBPreferences* preferences;

extern BOOL enabled;

NSString* alphaValue = @"0.2";


@interface _UIContextMenuContainerView : UIView
-(id)dismissalHandler;
-(UIColor*)getLittensMagicColor:(UIImage*)image;
@end

@interface SBIconController : UIViewController
-(id)containerViewForPresentingContextMenuForIconView:(id)iconView ;
-(void)_forceTouchControllerWillPresent:(id)arg1 ;
@end

@interface SBIconView : UIView
-(id)_iconImageView;
-(id)folder;
@end

@interface UIImage(Koi)
+(id)_applicationIconImageForBundleIdentifier:(id)arg1 format:(int)arg2 scale:(double)arg3 ;
@end

@interface _UIPreviewPlatterPresentationController : UIPresentationController
-(void)_handleDismissalTapGesture:(id)arg1 ;
@end

