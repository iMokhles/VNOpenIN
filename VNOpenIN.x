//
//  VNOpenIN.x
//  VNOpenIN
//
//  Created by iMokhles on 10.09.2015.
//  Copyright (c) 2015 iMokhles. All rights reserved.
//

#import "VNOpenINHelper.h"

static BOOL origMoreFunction = NO;

@interface VNRemoteVideoPlayerItemLoader : NSObject
- (NSString *)localVideoPath;
@end

@interface VNPost : NSObject
- (NSURL *)thumbnailUrl;
- (NSString *)caption;
- (VNRemoteVideoPlayerItemLoader *)playerItemLoader;
@end

@interface VNPostCell : UICollectionViewCell
- (VNPost *)post;
- (void)shareButtonWasTapped:(id)arg1;
- (void)originalMoreSheet;
- (void)newMoreSheet;
@end


%hook VNPostCell
- (void)shareButtonWasTapped:(id)arg1 {
	if (!origMoreFunction) {
		UIAlertController *altC = [UIAlertController alertControllerWithTitle:@"VNOpenIN" message:nil preferredStyle:UIAlertControllerStyleActionSheet];
		UIAlertAction *newShareAction = [UIAlertAction actionWithTitle:@"Save/Share Video" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
		    [self newMoreSheet];
		}];
		UIAlertAction *origShareAction = [UIAlertAction actionWithTitle:@"Share" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
			[self originalMoreSheet];
		}];
		UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
		            
		}];
		[altC addAction:newShareAction];
		[altC addAction:origShareAction];
		[altC addAction:cancelAction];
		UIPopoverPresentationController *popover = altC.popoverPresentationController;
		if (popover){
			popover.sourceView = [VNOpenINHelper mainVNOpenINViewController].view;
			popover.sourceRect = CGRectMake([VNOpenINHelper mainVNOpenINViewController].view.frame.size.width/2, [VNOpenINHelper mainVNOpenINViewController].view.frame.size.height/4, 0, 0);
			popover.permittedArrowDirections = UIPopoverArrowDirectionAny;
		}
		[[VNOpenINHelper mainVNOpenINViewController] presentViewController:altC animated:YES completion:nil];
	} else {
		origMoreFunction = NO;
		%orig;
	}
}
%new
- (void)originalMoreSheet {
	origMoreFunction = YES;
	[self shareButtonWasTapped:nil];
}
%new
- (void)newMoreSheet {
	dispatch_async(dispatch_get_main_queue(), ^{
		[[VNOpenINHelper mainVNOpenINViewController].view showActivityViewWithLabel:@"Preparing"];
    });
	origMoreFunction = NO;
	NSURL *thumURL = self.post.thumbnailUrl;
	// NSArray *urlArray = [thumURL.absoluteString componentsSeparatedByCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@"mp4"]];
	NSString *subString = [thumURL.absoluteString substringWithRange: NSMakeRange(0, [thumURL.absoluteString rangeOfString: @"mp4"].location)];
	NSString *grabbedString = subString;
	NSString *urlString = [NSString stringWithFormat:@"%@mp4", grabbedString];
	NSURL *videoURL = [NSURL URLWithString:urlString];
	NSData *videoData = [NSData dataWithContentsOfURL:videoURL];
	if (videoData) {
		NSString  *filePath = [NSString stringWithFormat:@"%@/%@", [VNOpenINHelper vnopen_DocumentsPath], [NSString stringWithFormat:@"%@.mp4", self.post.caption]];
		[videoData writeToFile:filePath atomically:YES];
		double delayInSeconds = 0.5;
		dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, delayInSeconds * NSEC_PER_SEC);
		dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
			[VNOpenINHelper vnopen_shareFile:filePath];
			[[VNOpenINHelper mainVNOpenINViewController].view hideActivityView];
		});
	} else {
		double delayInSeconds = 0.5;
		dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, delayInSeconds * NSEC_PER_SEC);
		dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
			[VNOpenINHelper vnopen_shareFile:self.post.playerItemLoader.localVideoPath];
			[[VNOpenINHelper mainVNOpenINViewController].view hideActivityView];
		});
	}
}

%end
