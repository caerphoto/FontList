//
//  PopupController.m
//  FontList
//
//  Created by Andrew Farrell on 21/10/2014.
//  Copyright (c) 2014 Andrew Farrell. All rights reserved.
//

#import "PopupController.h"

@interface PopupController ()

@end

@implementation PopupController

@synthesize font = _font;
@synthesize textColor = _textColor;
@synthesize backgroundColor = _backgroundColor;

- (void)windowDidLoad {
    [super windowDidLoad];
}

- (NSFont *)font {
    return _font;
}

- (void)setFont:(NSFont *)font {
    NSMutableString *title;
    NSFontManager *fm = [NSFontManager sharedFontManager];
    self.editor.font = font;

    title = [font.familyName mutableCopy];

    if (([fm traitsOfFont:font] & NSBoldFontMask) != 0) {
        [title appendString:@" Bold"];
    }

    if (([fm traitsOfFont:font] & NSItalicFontMask) != 0) {
        [title appendString:@" Italic"];
    }

    CGFloat roundedSize = (CGFloat)round(font.pointSize * 10) / 10;

    [title appendString:[NSString stringWithFormat:@", %gpt", roundedSize]];

    self.popupPreview.title = title;

    _font = self.editor.font;
}

- (NSColor *)textColor {
    return _textColor;
}

- (void)setTextColor:(NSColor *)textColor {
    self.editor.textColor = textColor;
    _textColor = self.editor.textColor;
}

- (NSColor *)backgroundColor {
    return _backgroundColor;
}

- (void)setBackgroundColor:(NSColor *)backgroundColor {
    self.editor.backgroundColor = backgroundColor;
    _backgroundColor = self.editor.backgroundColor;
}

@end
