//
//  ECU1227747.c
//  iOSALDL
//
//  Created by rpasek on 10/18/20.
//

#include <stdio.h>
#include <string.h>
#include "ECU.h"

static void Process(void);

static const char *RAWDataStrings[] = {
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

static const char *MW2Strings[] = {
    "Vss Pulse Occured",
    "ESC 43B Ready for second Pwr Enrich",
    "DRP Occured",
    "Diagnostic Mode (0 Ohms)",
    "Factory Test Mode (3.9k Ohms)",
    "ALDL Mode (10k Ohms)",
    "Idle Flag",
    "1st time Idle Flag"
};

static const char *MWAF1Strings[] = {
    "Clear Flood Flag",
    "BLM Enable Flag",
    "Low Battery (IAC Inhibited)",
    "Asynchronous Fuel Flag",
    "4-3 Downshift for TCC unlock",
    "Old High Gear Flag",
    "Closed Loop Flag",
    "Rich Flag"
};

static const char *MCU2IOStrings[] = {
    "AIR Divert Solenoid ON",
    "AIR Divert Solenoid ON",
    "A/C Disabled",
    "TCC Locked",
    "Park/Neutral",
    "No High Gear",
    "Not Used",
    "No A/C Requested"
};

static const StatusFlagStrings_t FlagDataStatusFlagsStrings[] = {
    {
        .Name = "MW2",
        .Strings = {
            .Num = ARRAY_SIZE(MW2Strings),
            .Items = MW2Strings,
        }
    }, {
        .Name = "MWAF1",
        .Strings = {
            .Num = ARRAY_SIZE(MWAF1Strings),
            .Items = MWAF1Strings,
        }
    }, {
        .Name = "MCU2IO",
        .Strings = {
            .Num = ARRAY_SIZE(MCU2IOStrings),
            .Items = MCU2IOStrings,
        }
    },
};

enum eSensorData {
    eSensor_IAC,
    eSensor_CT,
    eSensor_MPH,
    eSensor_MAP,
    eSensor_RPM,
    eSensor_TPS,
    eSensor_INT,
    eSensor_O2,
    eSensor_VOLT,
    eSensor_KNOCK_CNT,
    eSensor_BLM,
    eSensor_O2_CNT,
    eSensor_Max,
};

static const char *SensorDataStrings[eSensor_Max] = {
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

static const char *SensorDataUSStrings[] = {
    "[#]",
    "[F]",
    "[MPH]",
    "[Volts]",
    "[RPM]",
    "[Volts]",
    "[#]",
    "[Volts]",
    "[Volts]",
    "[#]",
    "[#]",
    "[#]"
};

static const char *SensorDataMetricStrings[] = {
    "",
    "[C]",
    "[KPH]",
    "[kpa]",
    "",
    "[%]",
    "",
    "",
    "",
    "",
    "",
    "",
};

static const char *MALFFLG1Strings[] = {
    "24 VSS (Vehicle Speed Sensor)",
    "23 IAT / MAT low (Air Temperature)",
    "22 TPS low (Throttle Position Sensor)",
    "21 TPS high (Throttle Position Sensor)",
    "15 CT low (Coolant Temperature)",
    "14 CT high (Coolant Temperature)",
    "13 Oxygen sensor",
    "12 Engine not running",
};

static const char *MALFFLG2Strings[] = {
    "42 EST (Electronic Spark Timing",
    "41 Not Used",
    "35 Not Used",
    "34 MAP low (Manifold Air Pressure)",
    "33 MAP high (Manifold Air Pressure)",
    "32 EGR (Exaust Gas Recirculation)",
    "31 Governor Fail",
    "25 IAT / MAT high (Air Temperature)",
};

static const char *MALFFLG3Strings[] = {
    "55 ADU error",
    "54 Fuel Pump Relay Failure",
    "53 Not Used",
    "52 CAL Pack missing",
    "51 PROM error",
    "45 O2 rich (Oxygen sensor)",
    "44 O2 lean (Oxygen sensor)",
    "43 Knock ESC",
};

static const StatusFlagStrings_t ErrorCodesStatusFlagsStrings[] = {
    {
        .Name = "MALFFLG1",
        .Strings = {
            .Num = ARRAY_SIZE(MALFFLG1Strings),
            .Items = MALFFLG1Strings,
        }
    }, {
        .Name = "MALFFLG2",
        .Strings = {
            .Num = ARRAY_SIZE(MALFFLG2Strings),
            .Items = MALFFLG2Strings,
        }
    }, {
        .Name = "MALFFLG3",
        .Strings = {
            .Num = ARRAY_SIZE(MALFFLG3Strings),
            .Items = MALFFLG3Strings,
        }
    },
};

const ALDLStrings_t ECU1227747_ALDLStrings = {
    .Name = "1227747",
    .RAWDataStrings = {
        .Num = ARRAY_SIZE(RAWDataStrings),
        .Items = RAWDataStrings,
    },
    .FlagDataStrings = {
        .Num = ARRAY_SIZE(FlagDataStatusFlagsStrings),
        .Items = FlagDataStatusFlagsStrings,
    },
    .SensorDataStrings = {
        .Num = ARRAY_SIZE(SensorDataStrings),
        .Items = SensorDataStrings,
    },
    .SensorDataUSStrings = {
        .Num = ARRAY_SIZE(SensorDataUSStrings),
        .Items = SensorDataUSStrings,
    },
    .SensorDataMetricStrings = {
        .Num = ARRAY_SIZE(SensorDataMetricStrings),
        .Items = SensorDataMetricStrings,
    },
    .ErrorCodesStrings = {
        .Num = ARRAY_SIZE(ErrorCodesStatusFlagsStrings),
        .Items = ErrorCodesStatusFlagsStrings,
    }
};

typedef union _ECU1227747_ALDLData_t {
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
} ECU1227747_ALDLData_t;

ECU1227747_ALDLData_t FakeALDLData[] = {
    [0].bytes = { 36, 15, 71, 46, 59, 0, 65, 40, 25, 129, 163, 0, 0, 0, 178, 249, 65, 10, 122, 112, },
    [1].bytes = { 32, 15, 71, 46, 59, 0, 66, 41, 25, 128, 104, 0, 0, 0, 242, 253, 65, 10, 122, 111, },
    [2].bytes = { 36, 15, 71, 45, 59, 0, 64, 40, 25, 127, 140, 0, 0, 0, 178, 248, 73, 10, 122, 110, },
    [3].bytes = { 32, 15, 71, 45, 59, 0, 65, 40, 25, 129, 166, 0, 0, 0, 242, 248, 73, 10, 122, 109, },
    [4].bytes = { 36, 15, 71, 45, 59, 0, 66, 39, 25, 126,  90, 0, 0, 0, 178, 248, 65, 10, 122, 108, },
    [5].bytes = { 32, 15, 71, 45, 59, 0, 64, 41, 25, 129, 201, 0, 0, 0, 242, 252, 65, 10, 122, 107, },
    [6].bytes = { 36, 15, 71, 45, 59, 0, 67, 39, 25, 125,  87, 0, 0, 0, 178, 248, 73, 10, 122, 106, },
    [7].bytes = { 36, 15, 71, 45, 59, 0, 64, 40, 25, 126, 109, 0, 0, 0, 242, 248, 73, 10, 122, 105, },
    [8].bytes = { 36, 15, 71, 45, 59, 0, 65, 40, 25, 125, 168, 0, 0, 0, 242, 248, 65, 10, 122, 104, },
    [9].bytes = { 32, 15, 71, 45, 59, 0, 62, 40, 25, 128, 199, 0, 0, 0, 210, 252, 65, 10, 122, 102, },
    [10].bytes = { 32, 15, 71, 45, 59, 0, 65, 40, 25, 128, 113, 0, 0, 0, 242, 248, 73, 10, 122, 101, },
    [11].bytes = { 36, 15, 71, 45, 59, 0, 64, 39, 25, 126, 100, 0, 0, 0, 178, 248, 73, 10, 122, 100, },
    [12].bytes = { 36, 15, 71, 46, 60, 0, 63, 41, 25, 130, 212, 0, 0, 0, 242, 248, 65, 10, 122,  99, },
    [13].bytes = { 32, 15, 71, 46, 59, 0, 64, 41, 25, 130, 118, 0, 0, 0, 178, 253, 65, 10, 122,  98, },
};

uint8_t FlagData[3];
SensorEntry_t SensorData[ARRAY_SIZE(SensorDataStrings)];
uint8_t ErrorCodes[3];

ALDLData_t ALDLData = {
    .Process = &Process,
    .RawData = {
        .Num = ARRAY_SIZE(FakeALDLData),
        .EntrySize = sizeof(FakeALDLData[0]),
        .BufSize = sizeof(FakeALDLData),
        .Data = &FakeALDLData[0].bytes[0],
    },
    .FlagData = {
        .Num = ARRAY_SIZE(FlagData),
        .Data = FlagData,
    },
    .SensorData = {
        .Num = ARRAY_SIZE(SensorData),
        .Data = SensorData,
    },
    .ErrorCodes = {
        .Num = ARRAY_SIZE(ErrorCodes),
        .Data = ErrorCodes,
    }
};

static void Process(void) {
    ECU1227747_ALDLData_t *ALDLDataPtr = &FakeALDLData[ARRAY_SIZE(FakeALDLData) - 1];
    
    FlagData[0] = ALDLDataPtr->items.MW2;
    FlagData[1] = ALDLDataPtr->items.MWAF1;
    FlagData[2] = ALDLDataPtr->items.MCU2IO;
    
    /*
    eSensor_IAC,
    eSensor_CT,
    eSensor_MPH,
    eSensor_MAP,
    eSensor_RPM,
    eSensor_TPS,
    eSensor_INT,
    eSensor_O2,
    eSensor_VOLT,
    eSensor_KNOCK_CNT,
    eSensor_BLM,
    eSensor_O2_CNT,
    eSensor_Max,
    */
    
    snprintf(SensorData[eSensor_IAC].Entries[eSensorEntryLatest].Raw, sizeof(SensorData[eSensor_IAC].Entries[eSensorEntryLatest].Raw), "%u", ALDLDataPtr->items.IAC);
    
    ErrorCodes[0] = ALDLDataPtr->items.MALFFLG1;
    ErrorCodes[1] = ALDLDataPtr->items.MALFFLG2;
    ErrorCodes[2] = ALDLDataPtr->items.MALFFLG3;
}
