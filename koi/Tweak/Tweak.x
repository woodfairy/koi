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
	// This is a very dirty hack to get the current bundle ID. If you have a better way, please tell me!
	NSString *bundleId = [[[NSString stringWithFormat:@"%@", [arg1 icon]] componentsSeparatedByString:@"bundleID: "] objectAtIndex:1];
	bundleId = [bundleId substringToIndex:[bundleId length] - 1];
	NSLog(@"bundle id: %@", bundleId);
	UIImage *image = [UIImage _applicationIconImageForBundleIdentifier:bundleId format:2 scale:[UIScreen mainScreen].scale];
	NSLog(@"UIImage %@", image);
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
