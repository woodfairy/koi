#import "Koi.h"

BOOL enabled;
BOOL isFolder = NO;
_UIContextMenuContainerView *contextMenuContainerView = nil;


%group Koi


%hook _UIContextMenuContainerView
- (void)didMoveToWindow 
{
	%orig;
	// this reference is needed by the GestureRecognizer hook, ARC will clean up (hopefully)
	contextMenuContainerView = self;
	if(!isFolder) {
		[self setBackgroundColor:[[UIColor purpleColor] colorWithAlphaComponent:[alphaValue doubleValue]]];
	}
}
%end // hook _UIContextMenuContainerView


%hook SBIconController
-(id)containerViewForPresentingContextMenuForIconView:(id)iconView 
{
	if(![iconView folder]) {
		isFolder = NO;
		// This is a very dirty hack to get the current bundle ID. If you have a better way, please tell me!
		NSString *bundleIdentifier = [[[NSString stringWithFormat:@"%@", [iconView icon]] componentsSeparatedByString:@"bundleID: "] objectAtIndex:1];
		bundleIdentifier = [bundleIdentifier substringToIndex:[bundleIdentifier length] - 1];
		NSLog(@"bundle id: %@", bundleIdentifier);

		// get the UIImage object by bundleIdentifier
		UIImage *image = [UIImage _applicationIconImageForBundleIdentifier:bundleIdentifier format:2 scale:[UIScreen mainScreen].scale];
		//There is the UIImage, now use libkitten :D
		NSLog(@"UIImage %@", image);
	} else {
		isFolder = YES;
		// what are we going to do for folders? :D
		NSLog(@"IconView is a folder. Bailing out.");
	}
	
	return %orig;
}
%end // hook SBIconController


%hook _UIPreviewPlatterPresentationController
-(void)_handleDismissalTapGesture:(id)arg1 
{
	// I hook into the GestureRecognizer in order to set the background color to nil to get rid of the visual annoyance when dismissing
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
