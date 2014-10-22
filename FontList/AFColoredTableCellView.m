//
//  AFColoredTableCellView.m
//  FontList
//
//  Created by Andrew Farrell on 30/09/2014.
//  Copyright (c) 2014 Andrew Farrell. All rights reserved.
//

#import "AFColoredTableCellView.h"

@implementation AFColoredTableCellView

@synthesize previewText = _previewText;
@synthesize previewFont = _previewFont;
NSColor *nsTextColor;

- (CGColorRef)textColor {
    return nsTextColor.CGColor;
}

- (void)setTextColor:(CGColorRef)newColor {
    nsTextColor = [NSColor colorWithCGColor:newColor];
}

- (NSFont *)previewFont {
    return _previewFont;
}

- (void)setPreviewFont:(NSFont *)theFont {
    // IMPORTANT: ensure font is set BEFORE preview text, so that glyph subsitution works properly.
    CGFloat size = theFont.pointSize;

    // Create a font descriptor that specifies 'Andale Mono' as a fallback font.
    NSFontDescriptor *fodFallback = [NSFontDescriptor fontDescriptorWithName: @"AndaleMono" size: size];

    NSDictionary *dctCascade = [NSDictionary dictionaryWithObject: [NSArray arrayWithObject:fodFallback]
                                                           forKey: NSFontCascadeListAttribute];
    NSFontDescriptor *fodNew = [theFont.fontDescriptor fontDescriptorByAddingAttributes: dctCascade];
    _previewFont = [NSFont fontWithDescriptor: fodNew size: size];
}

- (NSString *)previewText {
    return _previewText;
}

- (void)setPreviewText:(NSString *)theText {
    // Replace missing glyphs in string with white squares (which has been checked to exist in the fallback font's glyph set, but might also be present in the target font).
    NSUInteger textLength = theText.length;
    unichar chars[textLength];
    [theText getCharacters:chars range:NSMakeRange(0, textLength)];
    CGGlyph glyphs[textLength];
    CTFontGetGlyphsForCharacters((CTFontRef)self.previewFont, chars, glyphs, textLength);
    for (NSUInteger idx = 0; idx < textLength; idx += 1) {
        if (glyphs[idx] == 0) {
            chars[idx] = 0x25A1; // '□' - WHITE SQUARE
        }
    }
    _previewText = [NSString stringWithCharacters:chars length:textLength];
}

- (void)drawRect:(NSRect)dirtyRect {
    NSRect bounds = self.bounds;
    NSPoint textOrigin = NSMakePoint(bounds.origin.x + 5, bounds.origin.y);

    // NOTE: the descender is almost always negative.
    textOrigin.y = ((bounds.size.height - self.previewFont.pointSize) / 2) + self.previewFont.descender + 2;
    NSDictionary *attributes = [NSDictionary dictionaryWithObjectsAndKeys:
                                self.previewFont, NSFontAttributeName,
                                nsTextColor, NSForegroundColorAttributeName,
                                nil];

    [self.previewText drawAtPoint:textOrigin withAttributes:attributes];
}

@end
