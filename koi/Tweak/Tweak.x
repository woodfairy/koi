#import "Koi.h"

BOOL enabled;
BOOL isFolder = NO;

_UIContextMenuContainerView* contextMenuContainerView = nil;
UIImage* currentBundleIconImage = nil;

%group Koi

%hook _UIContextMenuContainerView

- (void)willMoveToWindow:(UIWindow *)newWindow {

	contextMenuContainerView = self;

	if (!isFolder) {
		[UIView animateWithDuration:1.0 animations:^{
			[self setBackgroundColor:[[nena secondaryColor:currentBundleIconImage] colorWithAlphaComponent:[alphaValue doubleValue]]];
		} completion:NULL];
	}

	%orig;
	
}

%end


%hook SBIconController

- (id)containerViewForPresentingContextMenuForIconView:(id)iconView {

	if (![iconView folder]) {
		isFolder = NO;
		NSString* bundleIdentifier = [[[NSString stringWithFormat:@"%@", [iconView icon]] componentsSeparatedByString:@"bundleID: "] objectAtIndex:1];
		bundleIdentifier = [bundleIdentifier substringToIndex:[bundleIdentifier length] - 1];
		currentBundleIconImage = [UIImage _applicationIconImageForBundleIdentifier:bundleIdentifier format:2 scale:[UIScreen mainScreen].scale];
	} else {
		isFolder = YES;
	}

	isFolder = !![iconView folder];
	
	return %orig;

}

%end


%hook _UIPreviewPlatterPresentationController

- (void)_handleDismissalTapGesture:(id)arg1 {

	if (contextMenuContainerView)
		[contextMenuContainerView setBackgroundColor:nil];

	%orig;

}

%end

%end

%ctor {

	preferences = [[HBPreferences alloc] initWithIdentifier:@"0xcc.woodfairy.koi"];
	nena = [[libKitten alloc] init];

	[preferences registerBool:&enabled default:nil forKey:@"Enabled"];

	[preferences registerObject:&alphaValue default:@"0.5" forKey:@"alpha"];

	if (enabled) {
		%init(Koi);
	}

}
