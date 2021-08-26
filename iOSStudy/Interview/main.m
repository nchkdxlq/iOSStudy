//
//  main.m
//  Interview
//
//  Created by Knox on 2021/4/25.
//

#import <Foundation/Foundation.h>
#import "NKClassEntry.h"
#import "NKBlockEntry.h"
#import "NKRuntime.h"
#import "Synchronized.h"

int main(int argc, const char * argv[]) {
    @autoreleasepool {
//        [NKClassEntry entry];
//        [NKBlockEntry entry];
        [NKRuntime entry];
//        [Synchronized entry];
    }
    return 0;
}
