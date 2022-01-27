//
//  TestAssembly.c
//  iOSStudy
//
//  Created by Knox on 2022/1/13.
//

#include "TestAssembly.h"


int sum(int a, int b) {
    int c = a + b;
    return c;
}


void callEntry(void) {
    int a = 1;
    int b = 2;
    int c = sum(a, b);
}
