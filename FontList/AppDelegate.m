//
//  AppDelegate.m
//  FontList
//
//  Created by Andrew Farrell on 21/09/2014.
//  Copyright (c) 2014 Andrew Farrell. All rights reserved.
//

#import "AppDelegate.h"
#import "AFColoredTableCellView.h"
#import "RegExCategories.h"

const NSUInteger MIN_SIZE = 16;

@interface AppDelegate ()

@property (weak) IBOutlet NSWindow *window;
@end

@implementation AppDelegate

@synthesize filterText;
@synthesize previewText;
@synthesize fontSize;
@synthesize fontFamilies;
@synthesize filteredFontFamilies;

- (void)loadSettings {
    // Load various saved settings (or use defaults)
    NSUserDefaults *settings = [NSUserDefaults standardUserDefaults];

    previewText = [settings stringForKey:@"previewText"];
    if (previewText == nil) {
        previewText = @"The quick brown fox jumps over the lazy dog";
    } else {
        self.previewTextField.stringValue = previewText;
    }

    filterText = [settings stringForKey:@"filterText"];
    if (filterText == nil) {
        filterText = @"";
    } else {
        self.filterField.stringValue = filterText;
    }

    fontSize = [settings integerForKey:@"fontSize"];
    if (fontSize == 0) {
        fontSize = [self.fontSizeField integerValue];
    } else {
        self.fontSizeField.integerValue = fontSize;
        self.fontSizeStepper.integerValue = fontSize;
    }

    if ([settings boolForKey:@"bold"]) {
        self.chkBold.state = NSOnState;
    }
    if ([settings boolForKey:@"italic"]) {
        self.chkItalic.state = NSOnState;
    }

    NSData *colorData = [settings dataForKey:@"backgroundColor"];
    if (colorData != nil) {
        self.backgroundColorWell.color = (NSColor *)[NSUnarchiver unarchiveObjectWithData:colorData];
    }

    colorData = [settings dataForKey:@"textColor"];
    if (colorData != nil) {
        self.textColorWell.color = (NSColor *)[NSUnarchiver unarchiveObjectWithData:colorData];
    }
}

- (void)saveSettings {
    NSUserDefaults *settings = [NSUserDefaults standardUserDefaults];
    if ([self.filterField.stringValue isEqualToString:@""]) {
        [settings removeObjectForKey:@"filterText"];
    } else {
        [settings setObject:self.filterField.stringValue forKey:@"filterText"];
    }

    if ([self.previewTextField.stringValue isEqualToString:@""]) {
        [settings removeObjectForKey:@"previewText"];
    } else {
        [settings setObject:self.previewTextField.stringValue forKey:@"previewText"];
    }

    [settings setInteger:self.fontSizeStepper.integerValue forKey:@"fontSize"];
    [settings setBool:(self.chkItalic.state == NSOnState) forKey:@"italic"];
    [settings setBool:(self.chkBold.state == NSOnState) forKey:@"bold"];

    NSData *colorData = [NSArchiver archivedDataWithRootObject:self.backgroundColorWell.color];
    [settings setObject:colorData forKey:@"backgroundColor"];
    colorData = [NSArchiver archivedDataWithRootObject:self.textColorWell.color];
    [settings setObject:colorData forKey:@"textColor"];
}

- (NSInteger)listIndexFromFontName:(NSString *)fontName {
    if (fontName == nil) {
        return -1;
    }

    for (NSUInteger index = 0; index < self.filteredFontFamilies.count; index += 1) {
        if ([self.filteredFontFamilies[index] isEqualToString:fontName]) {
            return index;
        }
    }
    return -1;
}


- (void)updatePanelWithFontName:(NSString *)fontName {
    NSFont *font;
    BOOL familyOnly = (self.chkSyncPreview.state == NSOffState);

    if (fontName == nil) {
        fontName = self.detailedPreviewEditor.font.familyName;
    }

    if (familyOnly) {
        font = [[NSFontManager sharedFontManager] convertFont:self.detailedPreviewEditor.font toFamily:fontName];
    } else {
        font = [self fontFromCurrentStateWithName:fontName];
    }

    self.detailedPreviewEditor.font = font;
    self.previewPanel.title = fontName;

    if (!familyOnly) {
        self.detailedPreviewEditor.textColor = self.textColorWell.color;
        self.detailedPreviewEditor.backgroundColor = self.backgroundColorWell.color;
    }
}

- (void)updateUI {
    if (self.chkSyncPreview.state == NSOnState) {
        [self updatePanelWithFontName:nil];
    }
    [self.mainListView reloadData];

    [self saveSettings];
}

- (void)fetchFontFamilies {
    NSFontManager *manager = [NSFontManager sharedFontManager];
    NSArray *unsortedSysFonts = [manager availableFontFamilies];

    fontFamilies = [unsortedSysFonts sortedArrayUsingSelector:@selector(caseInsensitiveCompare:)];
    filteredFontFamilies = [fontFamilies mutableCopy];
}

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification {
    [self fetchFontFamilies];
    [self loadSettings];
    [self applyFilters];

    [self.mainListView setBackgroundColor:self.backgroundColorWell.color];

    [self.mainListView setDelegate:(id)self];
    [self.mainListView setDataSource:(id)self];
    [self.mainListView setDoubleAction:@selector(takeFontNameFrom:)];
}

- (void)applicationWillTerminate:(NSNotification *)aNotification {
    [self saveSettings];
    fontFamilies = nil;
}

- (NSString *)styleStringFromFlags:(NSUInteger)flags {
    NSString *result;

    switch (flags) {
        case 0:
            result = @"";
            break;
        case 1:
            result = @"\n✓ Italic";
            break;
        case 2:
            result = @"\n✓ Bold";
            break;
        case 3:
            result = @"\n✓ Bold, Italic";
            break;
        case 4:
            result = @"\n✓ BoldItalic";
            break;
        case 5:
            result = @"\n✓ Italic, BoldItalic";
            break;
        case 6:
            result = @"\n✓ Bold, BoldItalic";
            break;
        case 7:
            result = @"\n✓ Bold, Italic, BoldItalic";
            break;
        default:
            result = @" ?";
    }

    return result;
}

- (NSUInteger)styleFlagsForFontName:(NSString *)fontName {
    NSUInteger styleFlags = 0;
    NSFontManager *fm = [NSFontManager sharedFontManager];
    NSArray *styles = [fm availableMembersOfFontFamily:fontName];

    for (NSArray *style in styles) {
        if ([style[1] isEqualToString:@"Italic"]) {
            styleFlags |= 1;
            continue;
        }
        if ([style[1] isEqualToString:@"Bold"]) {
            styleFlags |= 2;
            continue;
        }
        if ([style[1] isEqualToString:@"Bold Italic"]) {
            styleFlags|= 4;
        }
    }

    return styleFlags;
}

- (void)applyFilters {
    // Remeber which font was selected before changing filters, so it can be re-selected (probably with a different index) afterwards.
    NSString *selectedFontName;
    NSInteger index = self.mainListView.selectedRow;
    if (index != -1) {
        selectedFontName = [[self.filteredFontFamilies objectAtIndex:index] copy];
    }

    NSUInteger filterFlags = 0;

    if (self.chkItalic.state == NSOnState) {
        filterFlags |= 1;
    }
    if (self.chkBold.state == NSOnState) {
        filterFlags |= 2;
    }

    // A font with Bold and Italic is not the same as one with Bold Italic.
    if (filterFlags == 3) {
        filterFlags = 4;
    }

    if ([filterText isEqualToString:@""]) {
        [filteredFontFamilies removeAllObjects];
        for (id fontName in fontFamilies) {
            NSUInteger styleFlags = [self styleFlagsForFontName:fontName];
            if (filterFlags == 0 || (styleFlags & filterFlags) != 0) {
                [filteredFontFamilies addObject:fontName];
            }
        }
    } else {
        Rx *regex = [filterText toRxIgnoreCase:YES];

        [filteredFontFamilies removeAllObjects];
        for (id fontName in fontFamilies) {
            NSUInteger styleFlags = [self styleFlagsForFontName:fontName];
            if ([fontName isMatch:regex]) {
                if (filterFlags == 0 || (styleFlags & filterFlags) != 0) {
                    [filteredFontFamilies addObject:fontName];
                }
            }
        }
    }

    [self updateUI];

    index = [self listIndexFromFontName:selectedFontName];
    if (index != -1) {
        [self.mainListView selectRowIndexes:[NSIndexSet indexSetWithIndex:index] byExtendingSelection:NO];
        [self.mainListView scrollRowToVisible:index];
    }
}

- (NSFont *)fontFromCurrentStateWithName:(NSString *)fontName {
    NSFontManager *fm = [NSFontManager sharedFontManager];
    NSFont *font = [NSFont fontWithName:fontName size:(CGFloat)fontSize];

    if (self.chkItalic.state == NSOnState) {
        font = [fm convertFont:font toHaveTrait:NSItalicFontMask];
    }
    if (self.chkBold.state == NSOnState) {
        font = [fm convertFont:font toHaveTrait:NSBoldFontMask];
    }

    return font;
}

- (IBAction)takeFontNameFrom:(id)sender {
    NSString *newFontName = [filteredFontFamilies objectAtIndex:[sender clickedRow]];
    [self updatePanelWithFontName:newFontName];
    [self.previewPanel makeKeyAndOrderFront:self];
}

- (IBAction)synchronizePreview:(id)sender {
    if ([(NSButton *)sender state] == NSOnState) {
        NSString *fontName = [filteredFontFamilies objectAtIndex:[self.mainListView selectedRow]];
        [self updatePanelWithFontName:fontName];
    }
}

- (IBAction)reloadFonts:(id)sender {
    [self fetchFontFamilies];
    [self applyFilters];
    [self updateUI];
}

- (IBAction)takeFilterFrom:(id)sender {
    filterText = [sender stringValue];
    [self applyFilters];
}

- (IBAction)takePreviewTextFrom:(id)sender {
    NSString *newText = [sender stringValue];
    if (newText != nil && [newText length] == 0) {
        newText = [self.previewTextField.cell placeholderString];
    }
    previewText = newText;

    [self updateUI];
}

- (IBAction)takeFontSizeFrom:(id)sender {
    NSInteger newValue = [sender integerValue];

    if ([[sender identifier] isEqualToString:@"FontSizeField"]) {
        self.fontSizeStepper.integerValue = newValue;
    } else {
        self.fontSizeField.integerValue = newValue;
    }

    fontSize = newValue;

    [self updateUI];
}

- (IBAction)takeColorFrom:(NSColorWell *)sender {
    if ([sender.identifier isEqualToString:@"BackgroundColor"]) {
        [self.mainListView setBackgroundColor:self.backgroundColorWell.color];
    }

    [self updateUI];
}

- (IBAction)styleFilterWasChangedBy:(id)sender {
    [self applyFilters];
}

- (NSInteger)numberOfRowsInTableView:(NSTableView *)mainFontList {
    NSUInteger count = [filteredFontFamilies count];
    self.statusBar.stringValue = [NSString stringWithFormat:@"%lu fonts", (unsigned long)count];
    return count;
}

- (CGFloat)tableView:(NSTableView *)tableView heightOfRow:(NSInteger)row {
    if (fontSize > MIN_SIZE) {
        return fontSize * 1.8;
    } else {
        return MIN_SIZE * 1.8;
    }
}

- (NSView *)tableView:(NSTableView *)tableView viewForTableColumn:(NSTableColumn *)tableColumn row:(NSInteger)row {

    NSString *fontName = [filteredFontFamilies objectAtIndex:row];

    if ([tableColumn.identifier isEqualToString:@"NameColumn"]) {
        NSTableCellView *result = [tableView makeViewWithIdentifier:tableColumn.identifier owner:self];
        NSUInteger styleFlags = [self styleFlagsForFontName:fontName];
        result.textField.stringValue = [fontName stringByAppendingString:[self styleStringFromFlags:styleFlags]];
        return result;

    } else {
        AFColoredTableCellView *result = [tableView makeViewWithIdentifier:tableColumn.identifier owner:self];
        result.textColor = self.textColorWell.color;
        result.previewFont = [self fontFromCurrentStateWithName:fontName];
        result.previewText = previewText;

        return result;
    }

    return nil;
}

@end
