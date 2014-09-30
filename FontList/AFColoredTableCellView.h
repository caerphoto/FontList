//
//  AFColoredTableCellView.h
//  FontList
//
//  Created by Andrew Farrell on 30/09/2014.
//  Copyright (c) 2014 Andrew Farrell. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface AFColoredTableCellView : NSView

@property (assign) NSColor *textColor;
@property (assign) NSColor *backgroundFill;
@property (assign) NSString *font;
@property (assign) CGFloat fontSize;
@property (assign) NSString *text;

@end
