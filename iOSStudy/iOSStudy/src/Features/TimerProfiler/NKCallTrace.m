//
//  NKCallTrace.m
//  iOSStudy
//
//  Created by Knox on 2022/1/25.
//

#import "NKCallTrace.h"
#import "NKCallTraceCore.h"
#import "SMCallTraceCore.h"

@implementation NKCallTrace


+ (void)start {
    smCallTraceStart();
}

+ (void)stop {
    
}

+ (void)getCallRecords {
    NSLog(@"%s", __func__);
    int num = 0;
    smCallRecord *recordArray = smGetCallRecords(&num);
    for (int i = 0; i < num; i++) {
        smCallRecord record = recordArray[i];
        NSLog(@"%@", record.cls);
    }
}


@end
