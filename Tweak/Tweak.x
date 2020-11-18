#import "Koi.h"

BOOL enabled;

_UIContextMenuContainerView* contextMenuContainerView = nil;

%group Koi

%hook _UIContextMenuActionsListView

- (void)willMoveToWindow:(UIWindow *)newWindow {

	[[[([[self subviews] objectAtIndex:0]) subviews] objectAtIndex:0] setBackgroundColor:[currentBundleMenuColor colorWithAlphaComponent:[menuAlphaValue doubleValue]]];

	%orig;

}

%end

%hook _UIContextMenuContainerView

- (id)init {

	contextMenuContainerView = self;
	return %orig;

}

- (void)willMoveToWindow:(UIWindow *)newWindow {

	[UIView animateWithDuration:1.0 animations:^{
		[self setBackgroundColor:currentBundleBackgroundColor];
	} completion:nil];

	%orig;

}

%end


%hook SBIconController

- (id)containerViewForPresentingContextMenuForIconView:(SBIconView *)iconView {

	SBFolder* folder = [iconView folder];
	NSString* bundleIdentifier;

	if (folder) {
		if ([[folder icons] count] && [[folder icons] objectAtIndex:0])
			bundleIdentifier = [[[folder icons] objectAtIndex:0] applicationBundleID];
	} else {
		bundleIdentifier = [[iconView icon] applicationBundleID];
	}

	UIImage* image;
	
	if (bundleIdentifier) {
		image = [UIImage _applicationIconImageForBundleIdentifier:bundleIdentifier format:2 scale:[UIScreen mainScreen].scale];
	} else {
		// alternatively fall back to currently displayed low-res icon image if there is no bundle
		SBIconImageView* view = [iconView currentImageView];
		if (view) {
			if ([view respondsToSelector:@selector(displayedImage)]) {
				image = [view displayedImage];
			}
			
		}
	}

	if (!image) return %orig;

	if ([selectedBackgroundColorValue intValue] == 0)
		currentBundleBackgroundColor = [[nena backgroundColor:image] colorWithAlphaComponent:[ backgroundAlphaValue doubleValue]];
	else if ([selectedBackgroundColorValue intValue] == 1)
		currentBundleBackgroundColor = [[nena primaryColor:image] colorWithAlphaComponent:[ backgroundAlphaValue doubleValue]];
	else if ([selectedBackgroundColorValue intValue] == 2)
		currentBundleBackgroundColor = [[nena secondaryColor:image] colorWithAlphaComponent:[ backgroundAlphaValue doubleValue]];

	if ([selectedMenuColorValue intValue] == 0)
		currentBundleMenuColor = [[nena backgroundColor:image] colorWithAlphaComponent:[ backgroundAlphaValue doubleValue]];
	else if ([selectedMenuColorValue intValue] == 1)
		currentBundleMenuColor = [[nena primaryColor:image] colorWithAlphaComponent:[ backgroundAlphaValue doubleValue]];
	else if ([selectedMenuColorValue intValue] == 2)
		currentBundleMenuColor = [[nena secondaryColor:image] colorWithAlphaComponent:[ backgroundAlphaValue doubleValue]];
	
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

	preferences = [[HBPreferences alloc] initWithIdentifier:@"0xcc.woodfairy.koipreferences"];
	nena = [[libKitten alloc] init];

	[preferences registerBool:&enabled default:nil forKey:@"Enabled"];

	// Background
	[preferences registerObject:& backgroundAlphaValue default:@"0.5" forKey:@"backgroundAlpha"];
	[preferences registerObject:&selectedBackgroundColorValue default:@"2" forKey:@"selectedBackgroundColor"];

	// Menu
	[preferences registerObject:& menuAlphaValue default:@"1.0" forKey:@"menuAlpha"];
	[preferences registerObject:&selectedMenuColorValue default:@"1" forKey:@"selectedMenuColor"];

	if (enabled) {
		%init(Koi);
	}

}
