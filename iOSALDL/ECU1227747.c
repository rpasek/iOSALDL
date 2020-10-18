//
//  ECU1227747.c
//  iOSALDL
//
//  Created by rpasek on 10/18/20.
//

#include <stdio.h>
#include "ECU.h"

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

static const char *SensorDataStrings[] = {
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

static const char *MALFFLG1Strings[] = {
    "24 VSS (Vehicle Speed Sensor)",
    "23 IAT / MAT low (Air Temperature)",
    "22 TPS low (Throttle Position Sensor)",
    "15 CT low (Coolant Temperature)",
    "21 TPS high (Throttle Position Sensor)",
    "14 CT high (Coolant Temperature)",
    "12 Engine not running",
    "13 Oxygen sensor"
};

static const char *MALFFLG2Strings[] = {
    "42 EST (Electronic Spark Timing",
    "41 Not Used",
    "35 Not Used",
    "33 MAP high (Manifold Air Pressure)",
    "34 MAP low (Manifold Air Pressure)",
    "32 EGR (Exaust Gas Recirculation)",
    "25 IAT / MAT high (Air Temperature)",
    "31 Governor Fail"
};

static const char *MALFFLG3Strings[] = {
    "52 CAL Pack missing",
    "53 Not Used",
    "54 Fuel Pump Relay Failure",
    "51 PROM error",
    "55 ADU error",
    "45 O2 rich (Oxygen sensor)",
    "43 Knock ESC",
    "44 O2 lean (Oxygen sensor)"
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
    .ErrorCodesStrings = {
        .Num = ARRAY_SIZE(ErrorCodesStatusFlagsStrings),
        .Items = ErrorCodesStatusFlagsStrings,
    }
};
