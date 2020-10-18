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
    const StatusFlagStringsPtrs_t ErrorCodesStrings;
} ALDLStrings_t;

typedef struct _ALDLStringPtrs_t {
    const size_t Num;
    const ALDLStrings_t **Items;
} ALDLStringPtrs_t;

typedef union _ALDLData_t {
    uint8_t bytes[20];
} ALDLData_t;

extern const ALDLStrings_t *ALDLStrings;
extern ALDLData_t *ALDLData;
extern size_t ALDLDataLen;

#endif /* ECU_h */
