// -*- mode: ObjC -*-

//  This file is part of class-dump, a utility for examining the Objective-C segment of Mach-O files.
//  Copyright (C) 1997-1998, 2000-2001, 2004-2011 Steve Nygard.

#import "CDSection.h"
#include <mach-o/loader.h>

@class CDMachOFileDataCursor, CDMachOFile, CDLCSegment32;

@interface CDSection32 : CDSection
{
    CDLCSegment32 *nonretained_segment;

    struct section section;
}

- (id)initWithDataCursor:(CDMachOFileDataCursor *)cursor segment:(CDLCSegment32 *)aSegment;

- (CDLCSegment32 *)segment;
- (CDMachOFile *)machOFile;

- (NSUInteger)addr;
- (NSUInteger)size;
- (uint32_t)offset;

- (void)loadData;

//- (NSString *)description;

- (BOOL)containsAddress:(NSUInteger)address;
- (NSUInteger)fileOffsetForAddress:(NSUInteger)address;

@end
