//
//  ECU.h
//  iOSALDL
//
//  Created by rpasek on 10/18/20.
//

#ifndef ECU_h
#define ECU_h

#ifndef ARRAY_SIZE
#define ARRAY_SIZE(arr) (sizeof(arr) / sizeof((arr)[0]))
#endif

typedef struct _StringPtrs_t {
    const size_t Num;
    const char **Items;
} StringPtrs_t;

typedef struct _StatusFlagStrings_t {
    const char *Name;
    const StringPtrs_t Strings;
} StatusFlagStrings_t;

typedef struct _StatusFlagStringsPtrs_t {
    const size_t Num;
    const StatusFlagStrings_t *Items;
} StatusFlagStringsPtrs_t;

typedef struct _ALDLStrings_t {
    const char *Name;
    const StringPtrs_t RAWDataStrings;
    const StatusFlagStringsPtrs_t FlagDataStrings;
    const StringPtrs_t SensorDataStrings;
    const StringPtrs_t SensorDataUSStrings;
    const StringPtrs_t SensorDataMetricStrings;
    const StatusFlagStringsPtrs_t ErrorCodesStrings;
} ALDLStrings_t;

typedef struct _ALDLStringPtrs_t {
    const size_t Num;
    const ALDLStrings_t **Items;
} ALDLStringPtrs_t;

typedef struct _RawData_t {
    size_t Num;
    size_t EntrySize;
    size_t BufSize;
    uint8_t *Data;
} RawData_t;

typedef struct _FlagData_t {
    size_t Num;
    uint8_t *Data;
} FlagData_t;

enum eSensorEntries {
    eSensorEntryMin,
    eSensorEntryLatest,
    eSensorEntryMax,
    eSensorEntriesMax,
};

typedef struct _SensorEntry_t {
    struct {
        char Raw[12];
        char US[12];
        char Metric[12];
    } Entries[eSensorEntriesMax];
} SensorEntry_t;

typedef struct _SensorData_t {
    size_t Num;
    SensorEntry_t *Data;
} SensorData_t;

typedef struct _ALDLData_t {
    void (*Process)(void);
    RawData_t RawData;
    FlagData_t FlagData;
    SensorData_t SensorData;
    FlagData_t ErrorCodes;
} ALDLData_t;

extern const ALDLStrings_t *ALDLStrings;
extern ALDLData_t ALDLData;

#endif /* ECU_h */
