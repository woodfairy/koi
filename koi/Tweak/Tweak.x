#import "Koi.h"

BOOL enabled;

%group Koi

%hook _UIContextMenuContainerView

- (void)didMoveToWindow {

	%orig;
	NSLog(@"didMoveToWindow");
	[self setBackgroundColor:[[UIColor purpleColor] colorWithAlphaComponent:[alphaValue doubleValue]]];

}

%end

%hook SBIconController
-(id)containerViewForPresentingContextMenuForIconView:(id)arg1 {
	NSLog(@"IconView %@", arg1);
	NSLog(@"bundle ID: %@", [arg1 applicationBundleIdentifier]);
	return %orig;
}
%end

%end

%ctor {

	preferences = [[HBPreferences alloc] initWithIdentifier:@"0xcc.woodfairy.koi"];

	[preferences registerBool:&enabled default:nil forKey:@"Enabled"];

	[preferences registerObject:&alphaValue default:@"0.4" forKey:@"alpha"];

	if (enabled) {
		%init(Koi);
	}

}