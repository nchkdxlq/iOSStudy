//
//  NKCrashViewController.m
//  iOSStudy
//
//  Created by Knox on 2021/9/4.
//

#import "NKCrashViewController.h"
#include <execinfo.h>

void uncaughtExceptionHandler(NSException *exception) {
    NSLog(@"%@", exception);
}

void handleSignalException(int signal) {
    NSMutableString *crashString = [[NSMutableString alloc]init];
    void* callstack[128];
    int frames = backtrace(callstack, 128);
    char** traceChar = backtrace_symbols(callstack, frames);
    for (int i = 0; i <frames; ++i) {
        [crashString appendFormat:@"%s\n", traceChar[i]];
    }
    NSLog(@"%@", crashString);
}


void registerUncaughtExceptionHandler(void) {
    NSSetUncaughtExceptionHandler(&uncaughtExceptionHandler);
}

void registerSignalHandler(void) {
    signal(SIGSEGV, handleSignalException);
    signal(SIGFPE, handleSignalException);
    signal(SIGBUS, handleSignalException);
    signal(SIGPIPE, handleSignalException);
    signal(SIGHUP, handleSignalException);
    signal(SIGINT, handleSignalException);
    signal(SIGQUIT, handleSignalException);
    signal(SIGABRT, handleSignalException);
    signal(SIGILL, handleSignalException);
}


@interface NKCrashViewController ()

@property (nonatomic, strong) NSArray *dataSource;

@end


@implementation NKCrashViewController

- (instancetype)init {
    self = [super init];
    if (self) {
        registerUncaughtExceptionHandler();
        registerSignalHandler();
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];

    _dataSource = [NSArray new];
}

- (void)triggerCrash {
    [_dataSource objectAtIndex:1];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self triggerCrash];
}

@end
