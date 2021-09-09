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
//    NSString *str = @"<h9><i>Monday, July 15th</i></h9><h7>beach</h7>, near our hotel. My sister and I tried paragliding.";
    NSString *str = @"<h6>aaa</h6>,<h10>bbb</h10>.<h7>ccc</h7>?";
    [self addWrapStyle:str];
//    [self testLen];
}

- (NSString *)addWrapStyle:(NSString *)originString {
    NSMutableString *changeStr = originString.mutableCopy;
    NSInteger offsetLoc = 0;
    NSArray *punctuations = @[@",", @".", @"!", @"?", @":"];
    NSInteger nextEndIndex = 0;     // 记录changeStr的结束标记
    for (int i = 0; i < originString.length; i++) {
        NSString *sub = [originString substringWithRange:NSMakeRange(i, 1)];
        if ([punctuations containsObject:sub]) {    // 找到标点符号
            NSLog(@"找到标点符号:%@ loc = %d", sub, i);
            int j = i - 2;                          // 记录h5标签结尾位置
            NSString *sub2 = [originString substringWithRange:NSMakeRange(i - 1, 1)];
            if ([sub2 isEqualToString:@">"]) {      // 找到标点符号前面紧挨着的h5标签
                NSLog(@"找到h5结束位置:%d", i - 1);
                NSMutableString *mark = [NSMutableString string];  // 记录h5标签的字符串(不包含<>)
                while (j >= 0) {
                    NSString *beforeChar = [originString substringWithRange:NSMakeRange(j, 1)];
                    if ([beforeChar isEqualToString:@"<"]) { // 找到匹配的h5标签
                        NSLog(@"找到h5开始:%d, 结束的h5标签 = %@", j, mark);
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
                        [changeStr insertString:[inseartTag endTagString] atIndex:i+1 + offsetLoc];
                        [changeStr insertString:inseartTag atIndex:startLoc + offsetLoc];
                        offsetLoc += 11;
                        NSLog(@"匹配后的结果:%@-->offsetLoc = %ld", changeStr, (long)offsetLoc);
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
