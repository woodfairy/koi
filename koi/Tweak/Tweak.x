#import <QuartzCore/QuartzCore.h>
#import "Koi.h"

BOOL enabled;
BOOL isFolder = NO;

_UIContextMenuContainerView *contextMenuContainerView = nil;
UIImage *currentBundleIconImage = nil;

struct pixel {
    unsigned char r, g, b, a;
};

%group Koi


%hook _UIContextMenuContainerView
- (void)willMoveToWindow:(UIWindow *)newWindow
{
	// this reference is needed by the GestureRecognizer hook, ARC will clean up (hopefully)
	contextMenuContainerView = self;
	if(!isFolder) {
		[UIView animateWithDuration:1.0 animations:^{
			// >>> PUT YOUR COLOR CALCULATION HERE :D
			self.backgroundColor = [[self getLittensMagicColor:currentBundleIconImage] colorWithAlphaComponent:[alphaValue doubleValue]];
		} completion:NULL];
	}

	%orig;
}

%new // THIS IS A PSEUDO METHOD 
- (UIColor*) getLittensMagicColor:(UIImage*)image
{
    return [UIColor colorWithRed:229/255.0f green:39/255.0f blue:45/255.0f];
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
		//There is the UIImage, now use libkitten in the hook above :D
		currentBundleIconImage = [UIImage _applicationIconImageForBundleIdentifier:bundleIdentifier format:2 scale:[UIScreen mainScreen].scale];
		NSLog(@"UIImage %@", currentBundleIconImage);
	} else {
		isFolder = YES;
		// what are we going to do for folders? :D
		NSLog(@"IconView is a folder. Bailing out.");
	}

	isFolder = !![iconView folder];
	
	return %orig;
}

-(void)_forceTouchControllerWillPresent:(id)arg1 {
	NSLog(@"forceTouchControllerWillPresent arg1 %@", arg1);
	%orig;
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
