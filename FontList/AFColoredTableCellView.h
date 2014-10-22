//
//  AFColoredTableCellView.h
//  FontList
//
//  Created by Andrew Farrell on 30/09/2014.
//  Copyright (c) 2014 Andrew Farrell. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface AFColoredTableCellView : NSView

@property CGColorRef textColor;
@property NSFont *previewFont;
@property NSString *previewText;

- (NSString *)previewText;
- (void)setPreviewText:(NSString *)theText;
- (NSFont *)previewFont;
- (void)setPreviewFont:(NSFont *)theFont;

@end
