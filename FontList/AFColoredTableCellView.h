//
//  AFColoredTableCellView.h
//  FontList
//
//  Created by Andrew Farrell on 30/09/2014.
//  Copyright (c) 2014 Andrew Farrell. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface AFColoredTableCellView : NSView

@property (weak) NSColor *textColor;
@property NSFont *previewFont;
@property NSString *text;

@end
