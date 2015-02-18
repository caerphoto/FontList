//
//  PopupController.m
//  FontList
//
//  Created by Andrew Farrell on 21/10/2014.
//  Copyright (c) 2014 Andrew Farrell. All rights reserved.
//

#import "PopupController.h"

@interface PopupController ()
{
    @private
    NSArray *postScriptStyles;
}
@end

@implementation PopupController

@synthesize font = _font;
@synthesize textColor = _textColor;
@synthesize backgroundColor = _backgroundColor;


- (void)windowDidLoad {
    [super windowDidLoad];
    //[self.popupPreview setLevel:NSNormalWindowLevel];
    //self.popupPreview.excludedFromWindowsMenu = NO;
}

- (NSFont *)font {
    return _font;
}

- (NSArray *)postScriptNamesFromStyles:(NSArray *) styles {
    NSMutableArray *psNames = [[NSMutableArray alloc] init];

    for (NSArray *style in styles) {
        NSString *styleName = style[0];
        [psNames addObject:styleName];
    }
    return psNames;
}

- (NSArray *)styleNamesFromStyles:(NSArray *) styles {
    NSMutableArray *styleNames = [[NSMutableArray alloc] init];

    for (NSArray *style in styles) {
        NSString *styleName = style[1];
        [styleNames addObject:styleName];
    }
    return styleNames;
}

- (void)setFont:(NSFont *)font {
    NSFontManager *fm = [NSFontManager sharedFontManager];
    self.editor.font = font;
    NSArray *styles = [fm availableMembersOfFontFamily:font.familyName];
    NSArray *styleNames = [self styleNamesFromStyles:styles];
    NSInteger styleIndex = 0;

    // Store the PS names for later retrieval by index when user selects from fontStyle popup button.
    postScriptStyles = [self postScriptNamesFromStyles:styles];

    [self.fontStylePopup removeAllItems];
    [self.fontStylePopup addItemsWithTitles:styleNames];

    self.fontSize.integerValue = font.pointSize;
    self.fontSizeStepper.integerValue = self.fontSize.integerValue;

    self.popupPreview.title = font.familyName;

    /*
    if (([fm traitsOfFont:font] & NSBoldFontMask & NSItalicFontMask) != 0) {
        styleIndex = [styleNames indexOfObject:@"Bold Italic"];
    }

    if (([fm traitsOfFont:font] & NSBoldFontMask) != 0) {
        styleIndex = [styleNames indexOfObject:@"Bold"];
    }

    if (([fm traitsOfFont:font] & NSItalicFontMask) != 0) {
        styleIndex = [styleNames indexOfObject:@"Italic"];
    }
     */
    styleIndex = [postScriptStyles indexOfObject:font.fontName];
    [self.fontStylePopup selectItemAtIndex:styleIndex];

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

- (IBAction)takeFontStyleFrom:(id)sender {
    NSInteger i = self.fontStylePopup.indexOfSelectedItem;
    self.editor.font = [NSFont fontWithName:[postScriptStyles objectAtIndex:i] size:self.editor.font.pointSize];
}

- (IBAction)takeFontSizeFrom:(id)sender {
    NSInteger newValue = [sender integerValue];

    if ([[sender identifier] isEqualToString:@"field"]) {
        self.fontSizeStepper.integerValue = newValue;
    } else {
        self.fontSize.integerValue = newValue;
    }

    self.editor.font = [NSFont fontWithName:self.editor.font.fontName size: newValue];
}

@end
