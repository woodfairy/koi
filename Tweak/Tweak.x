#import "Koi.h"

BOOL enabled;

_UIContextMenuContainerView* contextMenuContainerView = nil;
UIColor *currentBundleColor = nil;


%group Koi

%hook _UIContextMenuContainerView

- (id)init {

	contextMenuContainerView = self;
	return %orig;

}

- (void)willMoveToWindow:(UIWindow *)newWindow {

	[UIView animateWithDuration:1.0 animations:^{
		[self setBackgroundColor:currentBundleColor];
	} completion:NULL];
	%orig;

}

%end


%hook SBIconController

- (id)containerViewForPresentingContextMenuForIconView:(SBIconView *)iconView {

	SBFolder *folder = [iconView folder];
	NSString *bundleIdentifier;

	if (folder) {
		if ([[folder icons] count] && [[folder icons] objectAtIndex:0])
			bundleIdentifier = [[[folder icons] objectAtIndex:0] applicationBundleID];
	} else {
		bundleIdentifier = [[iconView icon] applicationBundleID];
	}

	UIImage *image;
	
	if (bundleIdentifier) {
		image = 
			[UIImage _applicationIconImageForBundleIdentifier:bundleIdentifier format:2 scale:[UIScreen mainScreen].scale];
	} else {
		// alternatively fall back to currently displayed low-res icon image if there is no bundle
		SBIconImageView *view = [iconView currentImageView];
		if (view)
			image = [view displayedImage];
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

	if(contextMenuContainerView)
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
