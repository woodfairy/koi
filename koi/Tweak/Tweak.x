#import "Koi.h"

BOOL enabled;

_UIContextMenuContainerView* contextMenuContainerView = nil;
UIColor *currentBundleColor = nil;

static NSString* koiParseSerializedObjectString(NSString *string) {
	NSLog(@"koiParseString %@", string);
	string = [[string componentsSeparatedByString:@"bundleID: "] objectAtIndex:1];
	return [string substringToIndex:[string length] - 1];
}



%group Koi

%hook _UIContextMenuContainerView

- (void)willMoveToWindow:(UIWindow *)newWindow {

	contextMenuContainerView = self;

	[UIView animateWithDuration:1.0 animations:^{
		[self setBackgroundColor:currentBundleColor];
	} completion:NULL];

	%orig;
	
}

%end


%hook SBIconController

- (id)containerViewForPresentingContextMenuForIconView:(id)iconView {

	SBFolder *folder = [iconView folder];
	NSString *bundleIdentifier;

	bundleIdentifier = 
		koiParseSerializedObjectString(
			[
				NSString stringWithFormat:@"%@", 
				!!folder ? [[folder icons] objectAtIndex:0] : [iconView icon]
			]
		);

	UIImage *image = 
		[UIImage _applicationIconImageForBundleIdentifier:bundleIdentifier format:2 scale:[UIScreen mainScreen].scale];

	currentBundleColor = 
		[[nena secondaryColor:image] colorWithAlphaComponent:[alphaValue doubleValue]];
	
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
