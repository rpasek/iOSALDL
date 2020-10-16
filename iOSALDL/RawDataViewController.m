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
@property (nonatomic, strong) NSString *cellDataBuffer;

@end

@implementation RawDataViewController

#ifndef ARRAY_SIZE
#define ARRAY_SIZE(arr) (sizeof(arr) / sizeof((arr)[0]))
#endif

typedef union _ALDLData_t {
    uint8_t bytes[20];
    struct {
        uint8_t MW2;
        uint8_t PROMIDA;
        uint8_t PROMIDB;
        uint8_t IAC;
        uint8_t CT;
        uint8_t MPH;
        uint8_t MAP;
        uint8_t RPM;
        uint8_t TPS;
        uint8_t INT;
        uint8_t O2;
        uint8_t MALFFLG1;
        uint8_t MALFFLG2;
        uint8_t MALFFLG3;
        uint8_t MWAF1;
        uint8_t VOLT;
        uint8_t MCU2IO;
        uint8_t KNOCK_CNT;
        uint8_t BLM;
        uint8_t O2_CNT;
    } items;
} ALDLData_t;

ALDLData_t ALDLData[] = {
    [0].bytes =  { 36, 15, 71, 46, 59, 0, 65, 40, 25, 129, 163, 0, 0, 0, 178, 249, 65, 10, 122, 112, },
    [1].bytes =  { 32, 15, 71, 46, 59, 0, 66, 41, 25, 128, 104, 0, 0, 0, 242, 253, 65, 10, 122, 111, },
    [2].bytes =  { 36, 15, 71, 45, 59, 0, 64, 40, 25, 127, 140, 0, 0, 0, 178, 248, 73, 10, 122, 110, },
    [3].bytes =  { 32, 15, 71, 45, 59, 0, 65, 40, 25, 129, 166, 0, 0, 0, 242, 248, 73, 10, 122, 109, },
    [4].bytes =  { 36, 15, 71, 45, 59, 0, 66, 39, 25, 126,  90, 0, 0, 0, 178, 248, 65, 10, 122, 108, },
    [5].bytes =  { 32, 15, 71, 45, 59, 0, 64, 41, 25, 129, 201, 0, 0, 0, 242, 252, 65, 10, 122, 107, },
    [6].bytes =  { 36, 15, 71, 45, 59, 0, 67, 39, 25, 125,  87, 0, 0, 0, 178, 248, 73, 10, 122, 106, },
    [7].bytes =  { 36, 15, 71, 45, 59, 0, 64, 40, 25, 126, 109, 0, 0, 0, 242, 248, 73, 10, 122, 105, },
    [8].bytes =  { 36, 15, 71, 45, 59, 0, 65, 40, 25, 125, 168, 0, 0, 0, 242, 248, 65, 10, 122, 104, },
    [9].bytes =  { 32, 15, 71, 45, 59, 0, 62, 40, 25, 128, 199, 0, 0, 0, 210, 252, 65, 10, 122, 102, },
    [10].bytes = { 32, 15, 71, 45, 59, 0, 65, 40, 25, 128, 113, 0, 0, 0, 242, 248, 73, 10, 122, 101, },
    [11].bytes = { 36, 15, 71, 45, 59, 0, 64, 39, 25, 126, 100, 0, 0, 0, 178, 248, 73, 10, 122, 100, },
    [12].bytes = { 36, 15, 71, 46, 60, 0, 63, 41, 25, 130, 212, 0, 0, 0, 242, 248, 65, 10, 122,  99, },
    [13].bytes = { 32, 15, 71, 46, 59, 0, 64, 41, 25, 130, 118, 0, 0, 0, 178, 253, 65, 10, 122,  98, },
};

size_t ALDLDataLen = ARRAY_SIZE(ALDLData);

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
    CGFloat leftColumnWidth = 120.0f;
    CGFloat topRowHeight = 30.0f;
    CGFloat gridCellWidth = 50.0f;
    CGFloat gridCellHeight = 30.0f;

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
    return RAWDataStringsLen + 1;
}

- (NSInteger)numberOfColumnsInSpreadsheetView:(MMSpreadsheetView *)spreadsheetView
{
    return ALDLDataLen + 1;
}

- (UICollectionViewCell *)spreadsheetView:(MMSpreadsheetView *)spreadsheetView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    UICollectionViewCell *cell = nil;
    long dataRow = indexPath.mmSpreadsheetRow - 1;
    long dataColumn = indexPath.mmSpreadsheetColumn - 1;
    if (indexPath.mmSpreadsheetRow == 0 && indexPath.mmSpreadsheetColumn == 0) {
        // Upper left.
        cell = [spreadsheetView dequeueReusableCellWithReuseIdentifier:@"GridCell" forIndexPath:indexPath];
        MMGridCell *gc = (MMGridCell *)cell;
        gc.textLabel.text = @"Sample";
        cell.backgroundColor = [UIColor colorWithWhite:0.9f alpha:1.0f];
    }
    else if (indexPath.mmSpreadsheetRow == 0 && indexPath.mmSpreadsheetColumn > 0) {
        // Upper right.
        cell = [spreadsheetView dequeueReusableCellWithReuseIdentifier:@"TopRowCell" forIndexPath:indexPath];
        MMTopRowCell *tr = (MMTopRowCell *)cell;
        tr.textLabel.text = (dataColumn < ALDLDataLen) ? [NSString stringWithFormat:@"%li", dataColumn * -1] : nil;
        cell.backgroundColor = [UIColor whiteColor];
    }
    else if (indexPath.mmSpreadsheetRow > 0 && indexPath.mmSpreadsheetColumn == 0) {
        // Lower left.
        cell = [spreadsheetView dequeueReusableCellWithReuseIdentifier:@"LeftColumnCell" forIndexPath:indexPath];
        MMLeftColumnCell *lc = (MMLeftColumnCell *)cell;
        lc.textLabel.text = (dataRow < RAWDataStringsLen) ? @(RAWDataStrings[dataRow]) : nil;
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
        gc.textLabel.text = (dataColumn < ALDLDataLen && dataRow < sizeof(ALDLData[0].bytes)) ? [NSString stringWithFormat:@"%u", ALDLData[dataColumn].bytes[dataRow]] : nil;
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
    if (action == @selector(copy:)) {
        return YES;
    }
    return NO;
}

- (void)spreadsheetView:(MMSpreadsheetView *)spreadsheetView performAction:(SEL)action forItemAtIndexPath:(NSIndexPath *)indexPath withSender:(id)sender
{
    long dataRow = indexPath.mmSpreadsheetRow - 1;
    long dataColumn = indexPath.mmSpreadsheetColumn - 1;
    if (action == @selector(copy:)) {
        self.cellDataBuffer = (dataColumn < ALDLDataLen && dataRow < sizeof(ALDLData[0].bytes)) ? [NSString stringWithFormat:@"%u", ALDLData[dataColumn].bytes[dataRow]] : nil;
    }
}


@end
