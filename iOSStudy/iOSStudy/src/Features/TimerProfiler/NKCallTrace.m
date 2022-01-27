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


@end
