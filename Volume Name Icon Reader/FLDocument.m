/*
 * FLDocument.m
 * Volume Name Icon Reader
 *
 * Created by François LAMBOLEY on 3/12/12.
 * Copyright (c) 2012 Frost Land. All rights reserved.
 */

#import "FLDocument.h"

@implementation FLDocument

- (NSString *)windowNibName
{
	return @"FLDocument";
}

- (BOOL)readFromData:(NSData *)data ofType:(NSString *)typeName error:(NSError **)outError
{
	if (data.length < 5) {
		NSLog(@"Invalid file format: file length < 5");
		return NO;
	}
	
	const uint8_t *bytes = data.bytes;
	
	if (bytes[0] != 1) {
		NSLog(@"Invalid file format: first byte != 1");
		return NO;
	}
	
	/* Width and height are big endian */
	uint16_t w = (bytes[1] << 8) + bytes[2];
	uint16_t h = (bytes[3] << 8) + bytes[4];
	
	if (data.length != 5 + w*h) {
		NSLog(@"Invalid file format: file length != 5 + w*h (= %u)", 5 + w*h);
		return NO;
	}
	
	/* Retina Macs support @2x images (.disk_label_2x) */
	if (h != 12 && h != 24) {
		NSLog(@"Warning: probably invalid volume label: unexpected height %u", h);
	}
	
	bytes += 5;
	NSBitmapImageRep *bitmap = [[NSBitmapImageRep alloc] initWithBitmapDataPlanes:NULL
																	   pixelsWide:w pixelsHigh:h
																	bitsPerSample:8
																  samplesPerPixel:1
																		 hasAlpha:NO
																		 isPlanar:YES
																   colorSpaceName:NSCalibratedWhiteColorSpace
																	  bytesPerRow:w
																	 bitsPerPixel:8];
	uint8_t *imgData = bitmap.bitmapData;
	
	for (size_t i = 0; i < w*h; ++i) {
		switch (bytes[i]) {
			case 0x00: imgData[i] = 239; break;
			case 0xf6: imgData[i] = 223; break;
			case 0xf7: imgData[i] = 207; break;
			case 0x2a: imgData[i] = 191; break;
			case 0xf8: imgData[i] = 175; break;
			case 0xf9: imgData[i] = 159; break;
			case 0x55: imgData[i] = 143; break;
			case 0xfa: imgData[i] = 127; break;
			case 0xfb: imgData[i] = 111; break;
			case 0x80: imgData[i] = 95; break;
			case 0xfc: imgData[i] = 79; break;
			case 0xfd: imgData[i] = 63; break;
			case 0xab: imgData[i] = 47; break;
			case 0xfe: imgData[i] = 31; break;
			case 0xff: imgData[i] = 15; break;
			case 0xd6: imgData[i] = 0; break;
			default: imgData[i] = 255;
		}
	}

	NSImage *img = [[NSImage alloc] init];
	[img addRepresentation:bitmap];
	self.image = img;
	
	return YES;
}

- (void)alert:(NSString *)msg
{
	NSAlert *alert = [[NSAlert alloc] init];
	alert.messageText = msg;
	[alert runModal];
}

- (void)export:(id)sender
{
	NSSavePanel *panel = [NSSavePanel savePanel];
	panel.allowedFileTypes = @[@"png"];
	[panel beginSheetModalForWindow:self.windowForSheet completionHandler:^(NSInteger result) {
		if (result == NSFileHandlingPanelOKButton) {
			NSData *data = [self.image.representations.lastObject representationUsingType:NSPNGFileType properties:nil];
	 		if (!data || ![data writeToURL:panel.URL atomically:YES]) {
	 	 		[self alert:NSLocalizedString(@"Failed to write PNG.", "")];
			}
		}
	}];
}

- (void)copy:(id)sender
{
	NSPasteboard *pasteboard = [NSPasteboard generalPasteboard];
	[pasteboard clearContents];
	if (![pasteboard writeObjects:@[self.image]]) {
		[self alert:NSLocalizedString(@"Failed to write image to pasteboard.", "")];
	}
}

@end
