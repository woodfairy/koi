#import "Koi.h"

BOOL enabled;

%group Koi

%hook SpringBoard

- (void)applicationDidFinishLaunching:(id)arg1 {

	%orig;

	NSLog(@"[KOI] loaded successfully");

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