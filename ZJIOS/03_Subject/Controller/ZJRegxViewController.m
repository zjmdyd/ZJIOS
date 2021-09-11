//
//  ZJRegxViewController.m
//  ZJIOS
//
//  Created by Zengjian on 2021/7/10.
//

#import "ZJRegxViewController.h"

@interface ZJRegxViewController ()

@end

@implementation ZJRegxViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self test0];
}
/*
 2021-07-11 17:02:37.045693+0800 ZJIOS[6150:497939] resultRange = {3, 4}
 2021-07-11 17:02:37.045887+0800 ZJIOS[6150:497939] resultRange = {10, 4}
 2021-07-11 17:02:37.046011+0800 ZJIOS[6150:497939] resultRange = {18, 4}
 2021-07-11 17:02:37.046124+0800 ZJIOS[6150:497939] resultRange = {27, 4}
 2021-07-11 17:02:37.046266+0800 ZJIOS[6150:497939] resultRange = {34, 4}
 2021-07-11 17:02:37.046406+0800 ZJIOS[6150:497939] resultRange = {43, 4}
 */
- (void)test0 {
    NSString* yourString = @"<h6>hai</h6> ab,hai ab, hai ab, ahaiab, haiab\
    hai ab";
    
    NSError* error = NULL;
    NSString *word = @"hai";//[NSString stringWithFormat:@"(^(<h6>)(%@))", word];
//    NSString *regexWord = @"^<h6>hai";  //
    NSString *regexWord = @"(?!(^<h6>))hai";  //
//    NSString *regexWord = @"^hai";  //
//    NSString *regexWord = @"\\shai";  //可以匹配到3个hai  前面有空白字符[18,4] [34,4] [43,4]
//    NSString *regexWord = @"(?!([a-zA-Z])).hai"; // 匹配到5个hai,前面有非字母的字符, 比上1个多了[3,4], [10,4]
//    NSString *regexWord = @".hai"; //
//    NSString *regexWord = @".?hai"; //
//    NSString *regexWord = [NSString stringWithFormat:@"(((?!([a-zA-Z])).(%@))|^(%@)|(\\s?%@))(?!([a-zA-Z])).", word, word, word];
//    NSString *regexWord = [NSString stringWithFormat:@"((^(?!<h6>).(%@))((?!([a-zA-Z])).(%@))|^(%@)|(\\s?%@))(?!([a-zA-Z])).", word, word, word, word];
    NSRegularExpression* regex = [NSRegularExpression
                                  regularExpressionWithPattern:regexWord
                                  options:NSRegularExpressionCaseInsensitive
                                  error:&error];

    NSInteger offset = 0; // keeps track of range changes in the string
                          // due to replacements.
    for (NSTextCheckingResult* result in [regex matchesInString:yourString
                                                        options:0
                                                          range:NSMakeRange(0, [yourString length])]) {
        NSRange resultRange = [result range];
        resultRange.location += offset; // resultRange.location is updated
                                        // based on the offset updated below

        NSLog(@"resultRange = %@", NSStringFromRange(resultRange));
    }
}

- (void)test1 {
    NSString* yourString = @"hai ab,hai ab, hai ab, ahaiab, haiab\
    hai ab";
    
    NSError* error = NULL;
    NSString *word = @"hai";//[NSString stringWithFormat:@"(^(<h6>)(%@))", word];
//    NSString *regexWord = @"^hai";  //只能匹配到第一个hai 前面无字符 [0,3]
//    NSString *regexWord = @"\\shai";  //可以匹配到3个hai  前面有空白字符[14,4] [30,4] [39,4]
    NSString *regexWord = @"(?!([a-zA-Z])).hai"; // 匹配到4个hai,前面有非字母的字符, 比上1个多了[6,4]
//    NSString *regexWord = @".hai"; // 匹配到5个hai,比上1个多了[23,4]
//    NSString *regexWord = @".?hai"; // 匹配到6个hai,比上1个多了[0,3]
    NSRegularExpression* regex = [NSRegularExpression
                                  regularExpressionWithPattern:regexWord
                                  options:NSRegularExpressionCaseInsensitive
                                  error:&error];


    NSInteger offset = 0; // keeps track of range changes in the string
                          // due to replacements.
    for (NSTextCheckingResult* result in [regex matchesInString:yourString
                                                        options:0
                                                          range:NSMakeRange(0, [yourString length])]) {

        NSRange resultRange = [result range];
        resultRange.location += offset; // resultRange.location is updated
                                        // based on the offset updated below

        NSLog(@"resultRange = %@", NSStringFromRange(resultRange));
    }
}

- (void)test2 {
    NSString* yourString = @"This is the input string where i want to replace 1 2 & 3";
    NSMutableString* mutableString = [yourString mutableCopy];

    NSError* error = NULL;
    NSRegularExpression* regex = [NSRegularExpression
                                  regularExpressionWithPattern:@"\\b[1-3]\\b"
                                  options:NSRegularExpressionCaseInsensitive
                                  error:&error];


    NSInteger offset = 0; // keeps track of range changes in the string
                          // due to replacements.
    for (NSTextCheckingResult* result in [regex matchesInString:yourString
                                                        options:0
                                                          range:NSMakeRange(0, [yourString length])]) {

        NSRange resultRange = [result range];
        resultRange.location += offset; // resultRange.location is updated
                                        // based on the offset updated below

        // implement your own replace functionality using
        // replacementStringForResult:inString:offset:template:
        // note that in the template $0 is replaced by the match
        NSString* match = [regex replacementStringForResult:result
                                                   inString:mutableString
                                                     offset:offset
                                                   template:@"$0"];
        NSString* replacement;
        if ([match isEqualToString:@"1"]) {
            replacement = @"ONE";
        } else if ([match isEqualToString:@"2"]) {
            replacement = @"TWO";
        } else if ([match isEqualToString:@"3"]) {
            replacement = @"THREE";
        }

        // make the replacement
        [mutableString replaceCharactersInRange:resultRange withString:replacement];

        // update the offset based on the replacement
        offset += ([replacement length] - resultRange.length);
    }

    NSLog(@"mutableString: %@", mutableString); // mutableString: This is the input string where i want to replace ONE TWO & THREE
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
