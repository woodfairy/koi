#import "Koi.h"

BOOL enabled;
BOOL changeColor = NO;
_UIContextMenuContainerView *contextMenuContainerView = nil;


%group Koi


%hook _UIContextMenuContainerView
- (void)didMoveToWindow 
{
	%orig;
	contextMenuContainerView = self;
	if(changeColor) {
		[self setBackgroundColor:[[UIColor purpleColor] colorWithAlphaComponent:[alphaValue doubleValue]]];
	}
}
%end // hook _UIContextMenuContainerView


%hook SBIconController
-(id)containerViewForPresentingContextMenuForIconView:(id)iconView 
{
	
	NSLog(@"IconView %@", iconView);
	if(![iconView folder]) {
		changeColor = YES;
		// This is a very dirty hack to get the current bundle ID. If you have a better way, please tell me!
		NSString *bundleId = [[[NSString stringWithFormat:@"%@", [iconView icon]] componentsSeparatedByString:@"bundleID: "] objectAtIndex:1];
		bundleId = [bundleId substringToIndex:[bundleId length] - 1];
		NSLog(@"bundle id: %@", bundleId);
		UIImage *image = [UIImage _applicationIconImageForBundleIdentifier:bundleId format:2 scale:[UIScreen mainScreen].scale];
		NSLog(@"UIImage %@", image);
	} else {
		changeColor = NO;
		NSLog(@"IconView is a folder. Bailing out.");
	}
	
	return %orig;
}
%end // hook SBIconController


%hook _UIPreviewPlatterPresentationController
-(void)_handleDismissalTapGesture:(id)arg1 
{
	if(contextMenuContainerView) {
		[contextMenuContainerView setBackgroundColor:nil];
	}
	%orig;
}
%end // hook _UIPreviewPlatterPresentationController


%end // group Koi

%ctor 
{
	preferences = [[HBPreferences alloc] initWithIdentifier:@"0xcc.woodfairy.koi"];
	[preferences registerBool:&enabled default:nil forKey:@"Enabled"];
	[preferences registerObject:&alphaValue default:@"0.4" forKey:@"alpha"];
	if (enabled) {
		%init(Koi);
	}
}
