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
#import "PopupController.h"

const NSUInteger MIN_SIZE = 16;
NSUInteger taskCounter = 0;

@interface AppDelegate ()

@property (weak) IBOutlet NSWindow *window;
@end

@implementation AppDelegate

@synthesize filterText;
@synthesize previewText = _previewText;
@synthesize fontSize;
@synthesize fontFamilies;
@synthesize filteredFontFamilies;
@synthesize lstPreviewWindows;

- (void)setPreviewText:(NSString *)previewText {
    if (![_previewText isEqualToString:previewText]) {
        _previewText = previewText;

        if (self.previewTextTimer != nil) {
            [self.previewTextTimer invalidate];
            self.previewTextTimer = nil;
        }

        self.previewTextTimer = [NSTimer scheduledTimerWithTimeInterval: 0.7
            target: self
            selector:@selector(updateUI)
            userInfo: nil repeats:NO];
    }
}

- (NSString *)getPreviewText {
    if (self.previewTextField.stringValue.length == 0) {
        return nil;
    } else {
        return _previewText;
    }
}

- (void)loadSettings {
    // Load various saved settings (or use defaults)
    NSUserDefaults *settings = [NSUserDefaults standardUserDefaults];

    self.previewText = [settings stringForKey:@"previewText"];


    if (self.previewText != nil) {
        self.previewTextField.stringValue = self.previewText;
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

    if ([self.previewText isEqualToString:@""]) {
        [settings removeObjectForKey:@"previewText"];
    } else {
        [settings setObject:self.previewText forKey:@"previewText"];
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

    for (NSUInteger index = 0; index < self.mainListView.numberOfRows; index += 1) {
        if ([self.filteredFontFamilies[index] isEqualToString:fontName]) {
            return index;
        }
    }
    return -1;
}



- (void)updateUI {
    // Remeber which font was selected before changing filters, so it can be re-selected (probably with a different index) afterwards.
    NSString *selectedFontName;
    NSInteger index = self.mainListView.selectedRow;
    if (index != -1) {
        selectedFontName = [[self.mainListView viewAtColumn:1 row:index makeIfNecessary:NO] previewFont].familyName;
    }

    [self.mainListView reloadData];

    if (selectedFontName) {
        index = [self listIndexFromFontName:selectedFontName];
        if (index != -1) {
            [self.mainListView selectRowIndexes:[NSIndexSet indexSetWithIndex:index] byExtendingSelection:NO];
            [self.mainListView scrollRowToVisible:index];
        }
    }

    [self saveSettings];
}

- (void)fetchFontFamilies {
    NSFontManager *manager = [NSFontManager sharedFontManager];
    NSArray *unsortedSysFonts = [manager availableFontFamilies];

    fontFamilies = [unsortedSysFonts sortedArrayUsingSelector:@selector(caseInsensitiveCompare:)];
    filteredFontFamilies = [fontFamilies mutableCopy];
}

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification {
    [self.window makeFirstResponder:self.mainListView];

    [self fetchFontFamilies];
    [self loadSettings];
    [self applyFilters];

    [self.mainListView setBackgroundColor:self.backgroundColorWell.color];

    [self.aboutIcon setImage:[NSApp applicationIconImage]];
    //NSAttributedString *s = [NSAttributedString alloc];
    //[s initWithString:@"http://andyf.me"];

    self.lstPreviewWindows = [[NSMutableArray alloc] init];

    [self.mainListView setDelegate:(id)self];
    [self.mainListView setDataSource:(id)self];
    [self.mainListView setDoubleAction:@selector(showPopupPreviewFor:)];

}

- (void)applicationWillTerminate:(NSNotification *)aNotification {
    [self saveSettings];
    fontFamilies = nil;
}

- (BOOL)applicationShouldTerminateAfterLastWindowClosed:(NSApplication *)theApplication {
    return YES;
}

- (NSString *)styleStringFromFlags:(NSUInteger)flags {
    NSString *result;

    switch (flags) {
        case 0:
            result = @"";
            break;
        case 1:
            result = @"\ni";
            break;
        case 2:
            result = @"\nB";
            break;
        case 3:
            result = @"\nB, i";
            break;
        case 4:
            result = @"\nBi";
            break;
        case 5:
            result = @"\ni, Bi";
            break;
        case 6:
            result = @"\nB, Bi";
            break;
        case 7:
            result = @"\nB, i, Bi";
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
            styleFlags |= 4;
        }
    }

    return styleFlags;
}

- (void)applyFilters {
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

- (IBAction)showPopupPreviewFor:(id)sender {
    NSString *familyName = [filteredFontFamilies objectAtIndex:[sender clickedRow]];
    PopupController *newPopup = [[PopupController alloc] initWithWindowNibName:@"PopupPreview"];

    // Keep a reference to the window so it doesn't disappear when this function ends.
    [lstPreviewWindows addObject:newPopup];

    [newPopup showWindow:self];

    newPopup.font = [self fontFromCurrentStateWithName:familyName];
    newPopup.textColor = self.textColorWell.color;
    newPopup.backgroundColor = self.backgroundColorWell.color;
    newPopup.listIndex = lstPreviewWindows.count - 1;
    newPopup.windowList = lstPreviewWindows;

    [newPopup.popupPreview makeKeyAndOrderFront:self];

}

- (IBAction)reloadFonts:(id)sender {
    [self.reloadButton setEnabled:NO];
    [self.reloadButton setTransparent:YES];
    [self.reloadingSpinner startAnimation:NULL];

    [self fetchFontFamilies];
    [self applyFilters];

    [self.reloadingSpinner stopAnimation:NULL];
    [self.reloadButton setEnabled:YES];
    [self.reloadButton setTransparent:NO];
}

- (IBAction)viewInFontBook:(id)sender {
    [[NSWorkspace sharedWorkspace]launchApplication:@"Font Book"];
    NSString *familyName = [filteredFontFamilies objectAtIndex:self.mainListView.selectedRow];
    NSString *scriptSrc = @"\
tell application \"Font Book\"\n\
    set selected font families to { font family \"#\" }\n\
end tell";

    scriptSrc = [scriptSrc stringByReplacingOccurrencesOfString:@"#" withString:familyName];
    NSAppleScript *script = [[NSAppleScript alloc] initWithSource:scriptSrc];
    NSDictionary *compileError;
    NSDictionary *executeError;
    BOOL result;
    result = [script compileAndReturnError:&compileError];
    if (compileError) {
        NSLog(@"Error compiling. Script source:");
        NSLog([@"\n" stringByAppendingString:scriptSrc]);
        NSLog([compileError description]);
    } else {
        [script executeAndReturnError:&executeError];
        if (executeError) {
            NSLog(@"Error executing. Script Source:");
            NSLog([@"\n" stringByAppendingString:scriptSrc]);
            NSLog([executeError description]);

            NSAlert *alert = [[NSAlert alloc] init];
            NSString *errorMessage = @"There was a problem telling Font Book to show the selected font.";
            NSNumber *errorNumber = [executeError objectForKey:NSAppleScriptErrorNumber];
            if ([errorNumber integerValue] == -600) {
                errorMessage = [errorMessage stringByAppendingString:@"\n\nThis is a rare problem with System Events, and unfortunately there’s not much that can be done about it except restarting your Mac."];
            }
            [alert addButtonWithTitle:@"OK"];
            [alert setMessageText:@"Problem showing font"];
            [alert setInformativeText:errorMessage];
            [alert setAlertStyle:NSWarningAlertStyle];
            [alert runModal];
        }
    }
}

- (IBAction)showAboutWindow:(id)sender {
    [self.aboutWindow makeKeyAndOrderFront:self];
}

- (IBAction)takeFilterFrom:(id)sender {
    filterText = [sender stringValue];
    [self applyFilters];
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
    } else {
        [self updateUI];
    }
}

- (IBAction)styleFilterWasChangedBy:(id)sender {
    [self applyFilters];
}

- (NSInteger)numberOfRowsInTableView:(NSTableView *)mainFontList {
    NSUInteger count = [filteredFontFamilies count];
    self.statusBar.stringValue = [NSString stringWithFormat:@"%lu font families", (unsigned long)count];
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
    NSString *previewText = self.previewText;

    if (previewText == nil || [previewText isEqualToString:@""]) {
        NSDictionary *bindingInfo = [self.previewTextField.cell infoForBinding:@"value"];
        NSDictionary *options = [bindingInfo valueForKey:NSOptionsKey];
        previewText = [options valueForKey:NSNullPlaceholderBindingOption];
    }

    if ([tableColumn.identifier isEqualToString:@"NameColumn"]) {
        NSTableCellView *result = [tableView makeViewWithIdentifier:tableColumn.identifier owner:self];
        NSUInteger styleFlags = [self styleFlagsForFontName:fontName];
        result.textField.stringValue = [fontName stringByAppendingString:[self styleStringFromFlags:styleFlags]];
        return result;

    } else {
        AFColoredTableCellView *result = [tableView makeViewWithIdentifier:tableColumn.identifier owner:self];
        result.textColor = self.textColorWell.color.CGColor;
        result.previewFont = [self fontFromCurrentStateWithName:fontName];
        result.previewText = previewText;

        return result;
    }

    return nil;
}

@end