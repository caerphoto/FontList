//
//  AFColoredTableCellView.m
//  FontList
//
//  Created by Andrew Farrell on 30/09/2014.
//  Copyright (c) 2014 Andrew Farrell. All rights reserved.
//

#import "AFColoredTableCellView.h"

@implementation AFColoredTableCellView

- (void)drawRect:(NSRect)dirtyRect {
    NSRect bounds = [self bounds];
    NSPoint textOrigin = NSMakePoint(bounds.origin.x, bounds.origin.y);

    textOrigin.x += 5;

    // NOTE: the descender is almost always negative
    textOrigin.y = ((bounds.size.height - self.previewFont.pointSize) / 2) + self.previewFont.descender + 2;

    NSDictionary* attributes = [NSDictionary dictionaryWithObjectsAndKeys:
                                self.previewFont, NSFontAttributeName,
                                self.textColor, NSForegroundColorAttributeName,
                                nil];

    [self.text drawAtPoint:textOrigin withAttributes:attributes];
}

@end
