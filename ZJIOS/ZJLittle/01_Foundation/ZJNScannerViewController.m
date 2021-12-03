//
//  ZJNScannerViewController.m
//  ZJIOS
//
//  Created by issuser on 2021/8/16.
//

#import "ZJNScannerViewController.h"
#import "NSString+ZJString.h"

@interface ZJNScannerViewController ()

@end

@implementation ZJNScannerViewController

- (void)viewDidLoad {
    [super viewDidLoad];
//    <h11><h6>aaa</h6>,</h11><h11><h10>bbb</h10>.</h11><h11><h7>ccc</h7>?</h11>
//    [self test0];
    [self test1];
}

- (void)test0 {// len = 8
    NSString *str = @"</h7>...";
    NSArray *punctuations = @[@",", @".", @"!", @"?", @":", @"..."];
    for (int i = 0; i < str.length; i++) {
        if (i+2 < str.length) {
            NSString *punc3 = [str substringWithRange:NSMakeRange(i, 3)];
            if ([punctuations containsObject:punc3]) {
                NSLog(@"找到省略号:%d", i);
            }
        }
    }
}

- (void)test1 {
//    NSString *str = @"<h6>aaa</h6>,<h10>bbb</h10>.<h7>ccc</h7>...<h7>ccc</h7>?";
//    NSString *str = @"<h7>Could</h7><h7>you</h7><h7>please</h7>...?,hello\"<h7>egg</h7>\".";
    NSString *str = @"<h7>please</h7>...hello\"<h7>egg</h7>\".";
    [self addWrapStyle:str];
}
//   0   4  7
//
- (NSString *)addWrapStyle:(NSString *)originString {
    NSMutableString *changeStr = originString.mutableCopy;
    NSInteger offsetLoc = 0;
    NSArray *punctuations = @[@",", @".", @"!", @"?", @":", @"...", @"\"."];
//    NSInteger nextEndIndex = 0;     // 记录changeStr的结束标记
    for (int i = 0; i < originString.length; i++) {
        NSString *punc1 = [originString substringWithRange:NSMakeRange(i, 1)];
        NSInteger puncLen = 1;  // 标点默认长度
        // 处理其他长度标点符号
        NSString *puncOther;
        BOOL containPuncOther = NO;
        NSArray *puncOtherLens = @[@2, @3];
        for (int k = 0; k < puncOtherLens.count; k++) {
            int pLen = [puncOtherLens[k] intValue];
            if (i + pLen - 1 < originString.length) {
                puncOther = [originString substringWithRange:NSMakeRange(i, pLen)];
                if ([punctuations containsObject:puncOther]) {
                    containPuncOther = YES;
                    puncLen = pLen;
                    break;
                }
            }
        }
        
        if ([punctuations containsObject:punc1] || containPuncOther) {    // 找到标点符号
            NSLog(@"找到标点符号:%@ loc = %d, containPuncOther = %d", punc1, i, containPuncOther);
            int j = i - 2;                          // 记录h5标签结尾位置
            NSString *sub2 = [originString substringWithRange:NSMakeRange(i - 1, 1)];
            if ([sub2 isEqualToString:@">"]) {      // 找到标点符号前面紧挨着的h5标签
                NSLog(@"找到h5结束位置:%d", i - 1);
                NSMutableString *mark = [NSMutableString string];  // 保存h5标签的字符串(不包含<>)
                while (j >= 0) {
                    NSString *beforeChar = [originString substringWithRange:NSMakeRange(j, 1)];
                    if ([beforeChar isEqualToString:@"<"]) { // 找到匹配的h5标签
                        NSLog(@"找到h5开始位置:%d, 结束的h5标签 = %@", j, mark);
                        break;
                    }else {
                        [mark insertString:beforeChar atIndex:0];
                        NSLog(@"mark = %@", mark);
                    }
                    j--;
                }
                NSInteger beganMarkLen = mark.length + 1;   // 开头标签的长度(包含<>)
                NSInteger startLoc = j - beganMarkLen;
                NSString *beganMark = [NSString stringWithFormat:@"<%@>", [mark substringFromIndex:1]];
                NSLog(@"需要匹配的beganMark = %@", beganMark);
                while (startLoc >= 0) {
                    NSString *beganMatchStr = [originString substringWithRange:NSMakeRange(startLoc, beganMarkLen)];
                    NSLog(@"往前找:%@, startLoc = %ld", beganMatchStr, (long)startLoc);
                    if ([beganMatchStr isEqualToString:beganMark]) {
                        NSLog(@"匹配到了, 开始位置:%ld", (long)startLoc);
                        NSString *inseartTag = @"<h11>";
//                        [changeStr insertString:[inseartTag endTagString] atIndex:i+puncLen + offsetLoc];
                        [changeStr insertString:inseartTag atIndex:startLoc + offsetLoc];
                        offsetLoc += 11;
                        NSLog(@"匹配后的结果:%@-->offsetLoc = %ld", changeStr, (long)offsetLoc);
                        if (puncLen > 1) {  // 长度大于1的标点特殊处理
                            i += (puncLen - 1);
                        }
                        break;
                    }else {
                        startLoc--;
                    }
                }
            }else { // 标点前面不是h5标签
//                NSInteger m = i + offsetLoc;    // index由originString转换到changeStr
//                while (m >= nextEndIndex) {
//                    NSString *sub3 = [changeStr substringWithRange:NSMakeRange(m, 1)];
//                    if ([sub3 isEqualToString:@">"]) {  // 找到h5结束标签时停止查找,在结束标签后添加<h11>
//                        NSLog(@"标点前面不是h5标签, 找到了最近的h5结束标签, loc = %ld", (long)m);
//                        NSString *inseartTag = @"<h11>";
//                        [changeStr insertString:[inseartTag endTagString] atIndex:i+1 + offsetLoc];
//                        [changeStr insertString:inseartTag atIndex:m+1];
//                        offsetLoc += 11;
//                        nextEndIndex = i + offsetLoc;
//                        NSLog(@"匹配后的结果:%@-->offsetLoc = %ld, nextEndIndex = %ld", changeStr, (long)offsetLoc, nextEndIndex);
//                        break;
//                    }else {
//                        NSLog(@"往前找:loc = %ld, str = %@", (long)m, sub3);
//                    }
//                    m--;
//                }
            }
        }
    }
    
    return changeStr;
}

- (void)testLen {
    NSString *str1 = @"<h9><i><h11>Monday,</h11> July 15th</i></h9><h11><h7>beach</h7>,</h11><h11> near our hotel.</h11>";
    NSString *str2 = @"<h9><i><h11>Monday,</h11> July 15th</i></h9><h11><h7>beach</h7>,</h11><h11> near our hotel.</h11> My sister and I tried paragliding.";
    NSLog(@"len = %ld", str1.length);    // 97
    NSLog(@"len = %ld", str2.length);    // 132
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
