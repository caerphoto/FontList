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

- (NSString *)previewText {
    return _previewText;
}

- (void)setPreviewText:(NSString *)theText {
    // NOTE: it's vital to set the preview font before the text, otherwise the glyph substitution won't be accurate.
    // Replace missing glyphs in string with white squares (which has been checked to exist in the fallback font's glyph set).
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

- (NSFont *)previewFont {
    return _previewFont;
}

- (void)setPreviewFont:(NSFont *)theFont {
    CGFloat size = theFont.pointSize;

    // Create a font descriptor that specifies 'Andale Mono' as a fallback font.
    NSFontDescriptor *fodFallback = [NSFontDescriptor fontDescriptorWithName: @"AndaleMono" size: size];

    NSDictionary *dctCascade = [NSDictionary dictionaryWithObject: [NSArray arrayWithObject:fodFallback]
                                                           forKey: NSFontCascadeListAttribute];
    NSFontDescriptor *fodNew = [theFont.fontDescriptor fontDescriptorByAddingAttributes: dctCascade];
    _previewFont = [NSFont fontWithDescriptor: fodNew size: size];
}

- (void)drawRect:(NSRect)dirtyRect {
    // Draw preview text more or less vertically centred.
    CGFloat size = self.previewFont.pointSize;
    NSRect bounds = [self bounds];
    NSPoint textOrigin = NSMakePoint(bounds.origin.x, bounds.origin.y);

    // A bit of a margin.
    textOrigin.x += 5;

    // NOTE: the descender is almost always negative.
    textOrigin.y = ((bounds.size.height - size) / 2) + self.previewFont.descender + 2;



    NSDictionary *attributes = [NSDictionary dictionaryWithObjectsAndKeys:
                                self.previewFont, NSFontAttributeName,
                                self.textColor, NSForegroundColorAttributeName,
                                nil];

    [self.previewText drawAtPoint:textOrigin withAttributes:attributes];
}

@end
