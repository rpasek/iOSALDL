//
//  ECU.c
//  iOSALDL
//
//  Created by rpasek on 10/18/20.
//

#include <stdio.h>
#include "ECU.h"
#include "ECU1227747.h"

const ALDLStrings_t *ALDLStringsArray[] = {
    &ECU1227747_ALDLStrings,
};

const ALDLStringPtrs_t ALDLStringsPtrs = {
    .Num = ARRAY_SIZE(ALDLStringsArray),
    .Items = ALDLStringsArray,
};

const ALDLStrings_t *ALDLStrings = &ECU1227747_ALDLStrings;
