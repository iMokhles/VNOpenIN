//
//  VNOpenINListController.m
//  VNOpenIN
//
//  Created by iMokhles on 10.09.2015.
//  Copyright (c) 2015 iMokhles. All rights reserved.
//

#import "VNOpenINHelper.h"

@implementation VNOpenINHelper

// Preferences
+ (NSString *)preferencesPath {
	return @"/User/Library/Preferences/com.imokhles.vnopenin.plist";
}

+ (CFStringRef)preferencesChanged {
	return (__bridge CFStringRef)@"com.imokhles.vnopenin.preferences-changed";
}

// UIWindow to present your elements
// u can show/hide it using ( setHidden: NO/YES )
+ (UIWindow *)mainVNOpenINWindow {
	return [[UIApplication sharedApplication] windows][0];
}

+ (UIViewController *)mainVNOpenINViewController {
	return self.mainVNOpenINWindow.rootViewController;
}

// Checking App Version
+ (BOOL)isAppVersionGreaterThanOrEqualTo:(NSString *)appversion {
	return [[[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleVersion"] compare:appversion options:NSNumericSearch] != NSOrderedAscending;
}
+ (BOOL)isAppVersionLessThanOrEqualTo:(NSString *)appversion {
	return [[[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleVersion"] compare:appversion options:NSNumericSearch] != NSOrderedDescending;
}

// Checking OS Version
+ (BOOL)isIOS83_OrGreater {
	return [[[UIDevice currentDevice] systemVersion] floatValue] >= 8.3;
}
+ (BOOL)isIOS80_OrGreater {
	return [[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0;
}
+ (BOOL)isIOS70_OrGreater {
	return [[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0;
}
+ (BOOL)isIOS60_OrGreater {
	return [[[UIDevice currentDevice] systemVersion] floatValue] >= 6.0;
}
+ (BOOL)isIOS50_OrGreater {
	return [[[UIDevice currentDevice] systemVersion] floatValue] >= 5.0;
}
+ (BOOL)isIOS40_OrGreater {
	return [[[UIDevice currentDevice] systemVersion] floatValue] >= 4.0;
}

// Checking Device Type
+ (BOOL)isIPhone6_Plus {
	return [self isIPhone] && [self screenMaxLength] == 736.0;
}
+ (BOOL)isIPhone6 {
	return [self isIPhone] && [self screenMaxLength] == 667.0;
}
+ (BOOL)isIPhone5 {
	return [self isIPhone] && [self screenMaxLength] == 568.0;
}
+ (BOOL)isIPhone4_OrLess {
	return [self isIPhone] && [self screenMaxLength] < 568.0;
}

// Checking Device Interface
+ (BOOL)isIPad {
	return UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad;
}
+ (BOOL)isIPhone {
	return UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone;
}

// Checking Device Retina
+ (BOOL)isRetina {
	if ([self isIOS80_OrGreater]) {
        return [UIScreen mainScreen].nativeScale>=2;
    }
	return [[UIScreen mainScreen] scale] >= 2.0;
}

// Checking UIScreen sizes
+ (CGFloat)screenWidth {
	return [[UIScreen mainScreen] bounds].size.width;
}
+ (CGFloat)screenHeight {
	return [[UIScreen mainScreen] bounds].size.height;
}

+ (CGFloat)screenMaxLength {
    return MAX([self screenWidth], [self screenHeight]);
}

+ (CGFloat)screenMinLength {
    return MIN([self screenWidth], [self screenHeight]);
}

+ (NSString *)vnopen_DocumentsPath {
	NSArray  *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
	NSString  *documentsDirectory = [paths objectAtIndex:0];
	return documentsDirectory;
}

+ (void)vnopen_shareFile:(NSString *)fileToShare {
	// dispatch_async(dispatch_get_main_queue(), ^{
	// 	[[self mainVNOpenINViewController].view showActivityViewWithLabel:@"Preparing"];
	// 	// [self.navigationController.view hideActivityViewWithAfterDelay:2];
 //        // [ProgressHUD show:@"Preparing File....."];
 //    });
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSURL *URL = [NSURL fileURLWithPath:fileToShare];
        TTOpenInAppActivity *openInAppActivity = [[TTOpenInAppActivity alloc] initWithView:[self mainVNOpenINViewController].view andRect:[self mainVNOpenINViewController].view.frame];
        UIActivityViewController *activityViewController = [[UIActivityViewController alloc] initWithActivityItems:@[URL] applicationActivities:@[openInAppActivity]];
        if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone) {
			openInAppActivity.superViewController = activityViewController;
			dispatch_async(dispatch_get_main_queue(), ^{
                [[self mainVNOpenINViewController] presentViewController:activityViewController animated:YES completion:NULL];
                // [ProgressHUD showSuccess:@"Finished....."];
                // [[self mainVNOpenINViewController].view hideActivityView];
            });
		}
			//if iPad
		else {
			// Change Rect to position Popover
			openInAppActivity.superViewController = activityViewController;
			UIPopoverController *popup = [[UIPopoverController alloc] initWithContentViewController:activityViewController];
			dispatch_async(dispatch_get_main_queue(), ^{
				[popup presentPopoverFromRect:CGRectMake([self mainVNOpenINViewController].view.frame.size.width/2, [self mainVNOpenINViewController].view.frame.size.height/4, 0, 0)inView:[self mainVNOpenINViewController].view permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
                // [ProgressHUD showSuccess:@"Finished....."];
                // [[self mainVNOpenINViewController].view hideActivityView];
            });
		}        
    });
}
+ (NSBundle *)vnopen_bundle {
	return [NSBundle bundleWithPath:@"/Library/Application Support/VNOpenIN/VNOpenIN.bundle"];
}
@end
