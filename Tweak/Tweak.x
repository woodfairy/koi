#import "Koi.h"

BOOL enabled;

_UIContextMenuContainerView* contextMenuContainerView = nil;
UIColor *currentBundleColor = nil;


%group Koi
/*
%hook _UIContextMenuActionsListView

- (void)willMoveToWindow:(UIWindow *)newWindow {
	if ([self.subviews count] && [self.subviews objectAtIndex:0] && [([self.subviews objectAtIndex:0]).subviews count])
		[[([self.subviews objectAtIndex:0]).subviews objectAtIndex:0] setBackgroundColor:currentBundleColor];
	%orig;
}
%end
*/
%hook _UIContextMenuContainerView

- (id)init {
	contextMenuContainerView = self;
	return %orig;
}

- (void)willMoveToWindow:(UIWindow *)newWindow {
	if (currentBundleColor)
		[UIView animateWithDuration:1.0 animations:^{
			[self setBackgroundColor:currentBundleColor];
		} completion:NULL];
	%orig;
}

%end


%hook SBIconController

- (id)containerViewForPresentingContextMenuForIconView:(SBIconView *)iconView {
	currentBundleColor = nil; // reset current color first, there's no guarantee we will find a new one for current view
	SBFolder *folder = [iconView folder];
	NSString *bundleIdentifier;

	UIImage *image; // pointer to target image of icon for which we will generate the color

	if (folder) {
		if ([[folder icons] count] && [[folder icons] objectAtIndex:0])
			bundleIdentifier = [[[folder icons] objectAtIndex:0] applicationBundleID];
	} else {
		bundleIdentifier = [[iconView icon] applicationBundleID];
	}

	SBIconImageView *iconImageView = [iconView currentImageView];

	if (!image && iconImageView && [iconImageView respondsToSelector:@selector(displayedImage)]) {
		// use the cached image from memory, the fastest way
		image = [iconImageView displayedImage];
	}

	if (!image && bundleIdentifier) {
		// fall back to loading icon using a bundle identifier
		// (this will be used for folders)
		image = [UIImage _applicationIconImageForBundleIdentifier:bundleIdentifier format:2 scale:[UIScreen mainScreen].scale];
	}

	if (!image) {
		// still nothing, we will try to capture the UIView to an image
		// that's a fallback for iOS 14 widgets mainly
		UIGraphicsBeginImageContext(CGSizeMake(iconView.frame.size.width, iconView.frame.size.height));
		// below two lines are interchangeable
    	[iconView drawViewHierarchyInRect:CGRectMake(0, 0, iconView.frame.size.width, iconView.frame.size.height) afterScreenUpdates:YES]; // the resulting images look smoother for eye, but might actually be worse for color calculation
    	//[iconView.layer renderInContext:UIGraphicsGetCurrentContext()]; // the resulting images are more pixelated, but colors are sharper
    	image = UIGraphicsGetImageFromCurrentImageContext();
    	UIGraphicsEndImageContext();
		//UIImageWriteToSavedPhotosAlbum(image, nil, nil, nil); // was used for tests
	}

	if (!image)
		return %orig;

	currentBundleColor =
		[[nena secondaryColor:image] colorWithAlphaComponent:[alphaValue doubleValue]];
	
	return %orig;

}

%end

%hook SBIconView 

- (void)activateShortcut:(id)item withBundleIdentifier:(NSString*)bundleID forIconView:(id)iconView {

	if (contextMenuContainerView)
		[contextMenuContainerView setBackgroundColor:nil];

	%orig;

}

%end


%hook _UIPreviewPlatterPresentationController

- (void)_handleDismissalTapGesture:(id)arg1 {

	if (contextMenuContainerView)
		[contextMenuContainerView setBackgroundColor:nil];

	%orig;

}

%end

%hook SBHIconManager

- (void)setEditing:(BOOL)arg1 {
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
