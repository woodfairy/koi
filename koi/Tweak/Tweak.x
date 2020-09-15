#import "Koi.h"

BOOL enabled;

%group Koi

%hook _UIContextMenuContainerView

- (void)didMoveToWindow {

	%orig;

	[self setBackgroundColor:[UIColor purpleColor]];

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