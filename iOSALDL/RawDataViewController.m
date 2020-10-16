//
//  ViewController.m
//  iOSALDL
//
//  Created by rpasek on 10/15/20.
//

#import "RawDataViewController.h"
#import "MMSpreadsheetView.h"
#import "MMGridCell.h"
#import "MMTopRowCell.h"
#import "MMLeftColumnCell.h"
#import "NSIndexPath+MMSpreadsheetView.h"

@interface RawDataViewController () <MMSpreadsheetViewDataSource, MMSpreadsheetViewDelegate>

@property (nonatomic, strong) NSMutableSet *selectedGridCells;
@property (nonatomic, strong) NSMutableArray *tableData;
@property (nonatomic, strong) NSString *cellDataBuffer;

@end

@implementation RawDataViewController

#ifndef ARRAY_SIZE
#define ARRAY_SIZE(arr) (sizeof(arr) / sizeof((arr)[0]))
#endif

const char *RAWDataStrings[] = {
    "MW2",
    "PROMIDA",
    "PROMIDB",
    "IAC",
    "CT",
    "MPH",
    "MAP",
    "RPM",
    "TPS",
    "INT",
    "O2",
    "MALFFLG1",
    "MALFFLG2",
    "MALFFLG3",
    "MWAF1",
    "VOLT",
    "MCU2IO",
    "KNOCK_CNT",
    "BLM",
    "O2_CNT"
};
const size_t RAWDataStringsLen = ARRAY_SIZE(RAWDataStrings);

const char *FlagDataStrings[] = {
    "MW2",
    "MWAF1",
    "MCU2IO"
};
const size_t FlagDataStringsLen = ARRAY_SIZE(FlagDataStrings);

const char *MW2Strings[] = {
    "Vss Pulse Occured",
    "ESC 43B Ready for second Pwr Enrich",
    "DRP Occured",
    "Diagnostic Mode (0 Ohms)",
    "Factory Test Mode (3.9k Ohms)",
    "ALDL Mode (10k Ohms)",
    "Idle Flag",
    "1st time Idle Flag"
};
const size_t MW2StringsLen = ARRAY_SIZE(MW2Strings);

const char *MWAF1Strings[] = {
    "Clear Flood Flag",
    "BLM Enable Flag",
    "Low Battery (IAC Inhibited)",
    "Asynchronous Fuel Flag",
    "4-3 Downshift for TCC unlock",
    "Old High Gear Flag",
    "Closed Loop Flag",
    "Rich Flag"
};
const size_t MWAF1StringsLen = ARRAY_SIZE(MWAF1Strings);

const char *MCU2IOStrings[] = {
    "AIR Divert Solenoid ON",
    "AIR Divert Solenoid ON",
    "A/C Disabled",
    "TCC Locked",
    "Park/Neutral",
    "No High Gear",
    "Not Used",
    "No A/C Requested"
};
const size_t MCU2IOStringsLen = ARRAY_SIZE(MCU2IOStrings);

const char *SensorDataStrings[] = {
    "IAC",
    "Coolant Temp",
    "MPH",
    "MAP",
    "RPM",
    "TPS",
    "INT",
    "O2",
    "Battery Voltage",
    "Knock counter",
    "BLM",
    "rich / lean counter"
};
const size_t SensorDataStringsLen = ARRAY_SIZE(SensorDataStrings);

const char *ErrorCodesStrings[] = {
    "MALFFLG1",
    "MALFFLG2",
    "MALFFLG3",
};
const size_t ErrorCodesStringsLen = ARRAY_SIZE(ErrorCodesStrings);

const char *MALFFLG1Strings[] = {
    "24 VSS (Vehicle Speed Sensor)",
    "23 IAT / MAT low (Air Temperature)",
    "22 TPS low (Throttle Position Sensor)",
    "15 CT low (Coolant Temperature)",
    "21 TPS high (Throttle Position Sensor)",
    "14 CT high (Coolant Temperature)",
    "12 Engine not running",
    "13 Oxygen sensor"
};
const size_t MALFFLG1StringsLen = ARRAY_SIZE(MALFFLG1Strings);

const char *MALFFLG2Strings[] = {
    "42 EST (Electronic Spark Timing",
    "41 Not Used",
    "35 Not Used",
    "33 MAP high (Manifold Air Pressure)",
    "34 MAP low (Manifold Air Pressure)",
    "32 EGR (Exaust Gas Recirculation)",
    "25 IAT / MAT high (Air Temperature)",
    "31 Governor Fail"
};
const size_t MALFFLG2StringsLen = ARRAY_SIZE(MALFFLG2Strings);

const char *MALFFLG3Strings[] = {
    "52 CAL Pack missing",
    "53 Not Used",
    "54 Fuel Pump Relay Failure",
    "51 PROM error",
    "55 ADU error",
    "45 O2 rich (Oxygen sensor)",
    "43 Knock ESC",
    "44 O2 lean (Oxygen sensor)"
};
const size_t MALFFLG3StringsLen = ARRAY_SIZE(MALFFLG3Strings);

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    NSUInteger rows = RAWDataStringsLen;
    NSUInteger cols = 9;
    
    // Create some fake grid data for the demo.
    self.tableData = [NSMutableArray array];
    
    for (NSUInteger rowNumber = 0; rowNumber < rows; rowNumber++) {
        NSMutableArray *row = [NSMutableArray array];
        for (NSUInteger columnNumber = 0; columnNumber < cols; columnNumber++) {
            [row addObject:[NSString stringWithFormat:@"R%lu:C%lu", (unsigned long)rowNumber, (unsigned long)columnNumber]];
        }
        [self.tableData addObject:row];
    }
    
    self.selectedGridCells = [NSMutableSet set];

    // Create the spreadsheet in code.
    MMSpreadsheetView *spreadSheetView = [[MMSpreadsheetView alloc] initWithNumberOfHeaderRows:1 numberOfHeaderColumns:1 frame:self.view.bounds];
    self.restorationIdentifier = NSStringFromClass([self class]);
    spreadSheetView.restorationIdentifier = @"MMSpreadsheetView";

    // Register your cell classes.
    [spreadSheetView registerCellClass:[MMGridCell class] forCellWithReuseIdentifier:@"GridCell"];
    [spreadSheetView registerCellClass:[MMTopRowCell class] forCellWithReuseIdentifier:@"TopRowCell"];
    [spreadSheetView registerCellClass:[MMLeftColumnCell class] forCellWithReuseIdentifier:@"LeftColumnCell"];

    // Set the delegate & datasource for the spreadsheet view.
    spreadSheetView.delegate = self;
    spreadSheetView.dataSource = self;
    spreadSheetView.bounces = NO;
    
    // Add the spreadsheet view as a subview.
    [self.view addSubview:spreadSheetView];
}

#pragma mark - MMSpreadsheetViewDataSource

- (CGSize)spreadsheetView:(MMSpreadsheetView *)spreadsheetView sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    CGFloat leftColumnWidth = 160.0f;
    CGFloat topRowHeight = 75.0f;
    CGFloat gridCellWidth = 62.0f;
    CGFloat gridCellHeight = 51.5f;

    // Upper left.
    if (indexPath.mmSpreadsheetRow == 0 && indexPath.mmSpreadsheetColumn == 0) {
        return CGSizeMake(leftColumnWidth, topRowHeight);
    }
    
    // Upper right.
    if (indexPath.mmSpreadsheetRow == 0 && indexPath.mmSpreadsheetColumn > 0) {
        return CGSizeMake(gridCellWidth, topRowHeight);
    }
    
    // Lower left.
    if (indexPath.mmSpreadsheetRow > 0 && indexPath.mmSpreadsheetColumn == 0) {
        return CGSizeMake(leftColumnWidth, gridCellHeight);
    }
    
    return CGSizeMake(gridCellWidth, gridCellHeight);
}

- (NSInteger)numberOfRowsInSpreadsheetView:(MMSpreadsheetView *)spreadsheetView
{
    NSInteger rows = [self.tableData count];
    return rows;
}

- (NSInteger)numberOfColumnsInSpreadsheetView:(MMSpreadsheetView *)spreadsheetView
{
    NSArray *rowData = [self.tableData lastObject];
    NSInteger cols = [rowData count];
    return cols;
}

- (UICollectionViewCell *)spreadsheetView:(MMSpreadsheetView *)spreadsheetView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    UICollectionViewCell *cell = nil;
    if (indexPath.mmSpreadsheetRow == 0 && indexPath.mmSpreadsheetColumn == 0) {
        // Upper left.
        cell = [spreadsheetView dequeueReusableCellWithReuseIdentifier:@"GridCell" forIndexPath:indexPath];
        MMGridCell *gc = (MMGridCell *)cell;
        UIImageView *logo = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"mm_logo"]];
        [gc.contentView addSubview:logo];
        logo.center = gc.contentView.center;
        gc.textLabel.numberOfLines = 0;
        cell.backgroundColor = [UIColor colorWithWhite:0.9f alpha:1.0f];
    }
    else if (indexPath.mmSpreadsheetRow == 0 && indexPath.mmSpreadsheetColumn > 0) {
        // Upper right.
        cell = [spreadsheetView dequeueReusableCellWithReuseIdentifier:@"TopRowCell" forIndexPath:indexPath];
        MMTopRowCell *tr = (MMTopRowCell *)cell;
        tr.textLabel.text = [NSString stringWithFormat:@"TR: %li", (long)indexPath.mmSpreadsheetColumn];
        cell.backgroundColor = [UIColor whiteColor];
    }
    else if (indexPath.mmSpreadsheetRow > 0 && indexPath.mmSpreadsheetColumn == 0) {
        // Lower left.
        cell = [spreadsheetView dequeueReusableCellWithReuseIdentifier:@"LeftColumnCell" forIndexPath:indexPath];
        MMLeftColumnCell *lc = (MMLeftColumnCell *)cell;
        lc.textLabel.text = (indexPath.mmSpreadsheetRow - 1) < RAWDataStringsLen ? @(RAWDataStrings[indexPath.mmSpreadsheetRow - 1]) : nil;
        BOOL isDarker = indexPath.mmSpreadsheetRow % 2 == 0;
        if (isDarker) {
            cell.backgroundColor = [UIColor colorWithRed:222.0f / 255.0f green:243.0f / 255.0f blue:250.0f / 255.0f alpha:1.0f];
        } else {
            cell.backgroundColor = [UIColor colorWithRed:233.0f / 255.0f green:247.0f / 255.0f blue:252.0f / 255.0f alpha:1.0f];
        }
    }
    else {
        // Lower right.
        cell = [spreadsheetView dequeueReusableCellWithReuseIdentifier:@"GridCell" forIndexPath:indexPath];
        MMGridCell *gc = (MMGridCell *)cell;
        NSArray *colData = [self.tableData objectAtIndex:indexPath.mmSpreadsheetRow];
        NSString *rowData = [colData objectAtIndex:indexPath.mmSpreadsheetColumn];
        gc.textLabel.text = rowData;
        BOOL isDarker = indexPath.mmSpreadsheetRow % 2 == 0;
        if (isDarker) {
            cell.backgroundColor = [UIColor colorWithRed:242.0f / 255.0f green:242.0f / 255.0f blue:242.0f / 255.0f alpha:1.0f];
        } else {
            cell.backgroundColor = [UIColor colorWithRed:250.0f / 255.0f green:250.0f / 255.0f blue:250.0f / 255.0f alpha:1.0f];
        }
    }

    return cell;
}

#pragma mark - MMSpreadsheetViewDelegate

- (void)spreadsheetView:(MMSpreadsheetView *)spreadsheetView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    if ([self.selectedGridCells containsObject:indexPath]) {
        [self.selectedGridCells removeObject:indexPath];
        [spreadsheetView deselectItemAtIndexPath:indexPath animated:YES];
    } else {
        [self.selectedGridCells removeAllObjects];
        [self.selectedGridCells addObject:indexPath];
    }
}

- (BOOL)spreadsheetView:(MMSpreadsheetView *)spreadsheetView shouldShowMenuForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}

- (BOOL)spreadsheetView:(MMSpreadsheetView *)spreadsheetView canPerformAction:(SEL)action forItemAtIndexPath:(NSIndexPath *)indexPath withSender:(id)sender
{
    
    /*
     These are the selectors the sender (a UIMenuController) sends by default.
     
     _insertImage:
     cut:
     copy:
     select:
     selectAll:
     paste:
     delete:
     _promptForReplace:
     _showTextStyleOptions:
     _define:
     _addShortcut:
     _accessibilitySpeak:
     _accessibilitySpeakLanguageSelection:
     _accessibilityPauseSpeaking:
     makeTextWritingDirectionRightToLeft:
     makeTextWritingDirectionLeftToRight:
     
     We're only interested in 3 of them at this point
     */
    if (action == @selector(cut:) ||
        action == @selector(copy:) ||
        action == @selector(paste:)) {
        return YES;
    }
    return NO;
}

- (void)spreadsheetView:(MMSpreadsheetView *)spreadsheetView performAction:(SEL)action forItemAtIndexPath:(NSIndexPath *)indexPath withSender:(id)sender
{
    NSMutableArray *rowData = [self.tableData objectAtIndex:indexPath.mmSpreadsheetRow];
    if (action == @selector(cut:)) {
        self.cellDataBuffer = [rowData objectAtIndex:indexPath.row];
        [rowData replaceObjectAtIndex:indexPath.row withObject:@""];
        [spreadsheetView reloadData];
    } else if (action == @selector(copy:)) {
        self.cellDataBuffer = [rowData objectAtIndex:indexPath.row];
    } else if (action == @selector(paste:)) {
        if (self.cellDataBuffer) {
            [rowData replaceObjectAtIndex:indexPath.row withObject:self.cellDataBuffer];
            [spreadsheetView reloadData];
        }
    }
}


@end
