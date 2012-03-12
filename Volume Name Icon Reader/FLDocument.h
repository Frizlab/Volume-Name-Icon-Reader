/*
 * FLDocument.h
 * Volume Name Icon Reader
 *
 * Created by François LAMBOLEY on 3/12/12.
 * Copyright (c) 2012 Frost Land. All rights reserved.
 */

#import <Cocoa/Cocoa.h>

@interface FLDocument : NSDocument

@property(retain) NSImage *image;
@property(retain) IBOutlet NSImageView *imageView;

@end
