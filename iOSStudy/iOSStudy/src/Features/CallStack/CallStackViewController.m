//
//  CallStackViewController.m
//  iOSStudy
//
//  Created by Knox on 2021/10/28.
//

#import "CallStackViewController.h"
#import "BSBacktraceLogger.h"
#import <CrashReporter/CrashReporter.h>

static mach_port_t main_thread_id;


int funC(int p, int q) {
    int sum = p + q;
    return sum;
}

void funB(int i) {
    int j = 10;
    int ret = funC(i, j);
}

void funA(void) {
    int a = 1;
    funB(a);
}


@interface CallStackViewController ()

@end

@implementation CallStackViewController

+ (void)load {
    main_thread_id = mach_thread_self();  //主线程获取线程标识
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
}


- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self callStackSymbols];
    [self backtraceLogger];
    [self plCrashReport];
//    funA();
}

- (void)callStackSymbols {
    NSArray *symbols = [NSThread callStackSymbols];
    NSLog(@"symbols = %@", symbols);
}

- (void)backtraceLogger {
    NSString *backtrace = [BSBacktraceLogger bs_backtraceOfCurrentThread];
    NSLog(@"backtrace = %@", backtrace);
}


- (void)plCrashReport {
    PLCrashReporterConfig *config = [[PLCrashReporterConfig alloc] initWithSignalHandlerType:PLCrashReporterSignalHandlerTypeBSD
                                                                       symbolicationStrategy:PLCrashReporterSymbolicationStrategyAll];
    PLCrashReporter *reporter = [[PLCrashReporter alloc] initWithConfiguration:config];
    NSError *error = nil;
    NSData *lagData = [reporter generateLiveReportWithThread:(thread_t)main_thread_id error:&error];
    PLCrashReport *report = [[PLCrashReport alloc] initWithData:lagData error:&error];
    NSString *lagReportString = [PLCrashReportTextFormatter stringValueForCrashReport:report withTextFormat:PLCrashReportTextFormatiOS];
    NSString *mainTheadReport = [lagReportString substringToIndex:[lagReportString rangeOfString:@"Thread 1:"].location];
    NSLog(@"PLCrashReport = %@", mainTheadReport);
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
