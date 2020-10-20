//
//  SensorDataViewController.m
//  iOSALDL
//
//  Created by rpasek on 10/16/20.
//

#import "SensorDataViewController.h"
#import "ECU.h"
#import "MMSpreadsheetView.h"
#import "MMGridCell.h"
#import "MMTopRowCell.h"
#import "MMLeftColumnCell.h"
#import "NSIndexPath+MMSpreadsheetView.h"

enum eColumn {
    eColumnRaw,
    eColumnDataUS,
    eColumnUnitUS,
    eColumnDataMetric,
    eColumnUnitMetric,
    eColumnMax,
};

static const char *SensorDataHeaderStrings[] = {
    "RAW",
    "Convert",
    "Unit",
    "Convert",
    "Unit"
};

@interface SensorDataViewController () <MMSpreadsheetViewDataSource, MMSpreadsheetViewDelegate>

@property (nonatomic, strong) NSMutableSet *selectedGridCells;
@property (nonatomic, strong) NSString *cellDataBuffer;

@end

@implementation SensorDataViewController
@synthesize sensorSpreadsheetView;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.selectedGridCells = [NSMutableSet set];

    // Create the spreadsheet in code.
    MMSpreadsheetView *spreadSheetView = [[MMSpreadsheetView alloc] initWithNumberOfHeaderRows:1 numberOfHeaderColumns:1 frame:sensorSpreadsheetView.bounds];
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
    [sensorSpreadsheetView addSubview:spreadSheetView];
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
    return ALDLStrings->SensorDataStrings.Num + 1;
}

- (NSInteger)numberOfColumnsInSpreadsheetView:(MMSpreadsheetView *)spreadsheetView
{
    return ARRAY_SIZE(SensorDataHeaderStrings) + 1;
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
        gc.textLabel.text = @"";
        cell.backgroundColor = [UIColor colorWithWhite:0.9f alpha:1.0f];
    }
    else if (indexPath.mmSpreadsheetRow == 0 && indexPath.mmSpreadsheetColumn > 0) {
        // Upper right.
        cell = [spreadsheetView dequeueReusableCellWithReuseIdentifier:@"TopRowCell" forIndexPath:indexPath];
        MMTopRowCell *tr = (MMTopRowCell *)cell;
        tr.textLabel.text = (dataColumn < ARRAY_SIZE(SensorDataHeaderStrings)) ? @(SensorDataHeaderStrings[dataColumn]) : nil;
        cell.backgroundColor = [UIColor whiteColor];
    }
    else if (indexPath.mmSpreadsheetRow > 0 && indexPath.mmSpreadsheetColumn == 0) {
        // Lower left.
        cell = [spreadsheetView dequeueReusableCellWithReuseIdentifier:@"LeftColumnCell" forIndexPath:indexPath];
        MMLeftColumnCell *lc = (MMLeftColumnCell *)cell;
        lc.textLabel.text = (dataRow < ALDLStrings->SensorDataStrings.Num) ? @(ALDLStrings->SensorDataStrings.Items[dataRow]) : nil;
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
        switch (dataColumn) {
            case eColumnRaw:
                gc.textLabel.text = (dataColumn < eColumnMax && dataRow < ALDLData.SensorData.Num) ? @(ALDLData.SensorData.Data[dataRow].Entries[eSensorEntryLatest].Raw) : nil;
                break;
                
            case eColumnDataUS:
                //gc.textLabel.text = (dataColumn < eColumnMax && dataRow < ALDLData.SensorData.Num) ? @(ALDLData.SensorData.Data[dataRow].Raw) : nil;
                gc.textLabel.textAlignment = NSTextAlignmentRight;
                break;
                
            case eColumnUnitUS:
                gc.textLabel.text = (dataRow < ALDLStrings->SensorDataUSStrings.Num) ? @(ALDLStrings->SensorDataUSStrings.Items[dataRow]) : nil;
                gc.textLabel.textAlignment = NSTextAlignmentLeft;
                break;
                
            case eColumnDataMetric:
                //gc.textLabel.text = (dataColumn < ALDLDataLen && dataRow < sizeof(ALDLData[0].bytes)) ? [NSString stringWithFormat:@"%u", ALDLData[dataColumn].bytes[dataRow]] : nil;
                gc.textLabel.textAlignment = NSTextAlignmentRight;
                break;
                
            case eColumnUnitMetric:
                gc.textLabel.text = (dataRow < ALDLStrings->SensorDataMetricStrings.Num) ? @(ALDLStrings->SensorDataMetricStrings.Items[dataRow]) : nil;
                gc.textLabel.textAlignment = NSTextAlignmentLeft;
                break;
        }
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
        //self.cellDataBuffer = (dataColumn < ALDLDataLen && dataRow < sizeof(ALDLData[0].bytes)) ? [NSString stringWithFormat:@"%u", ALDLData[dataColumn].bytes[dataRow]] : nil;
    }
}

@end
