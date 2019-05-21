//
//  XMLTool.m
//  ASDF
//
//  Created by Macmafia on 2019/5/19.
//  Copyright © 2019 Macmafia. All rights reserved.
//

#import "XMLTool.h"

/* XML标签示例
 <breakfast_menu>
    <food>
    <name>Belgian Waffles</name>
    <price>$5.95</price>
    <description>two of our famous Belgian Waffles with plenty of real maple syrup</description>
    <calories>650</calories>
    </food>
 </breakfast_menu>
 */

static XMLTool *mXMLTool;

static NSString *K_MENUE = @"breakfast_menu";
static NSString *K_FOOD = @"food";
static NSString *K_NAME = @"name";
static NSString *K_PRICE = @"price";
static NSString *K_DESCRIPT = @"descript";
static NSString *K_CALORIES = @"calories";

#define PRINT_F NSLog(@"++++%s",__FUNCTION__); //打印函数
#define PRINT_O(x) NSLog(@"++++%@",x); //打印对象

@interface XMLTool ()<NSXMLParserDelegate>

@property (nonatomic, strong) NSMutableArray *mDataArr;
@property (nonatomic, copy) NSString *mTag; //当前解析开始的标签

@end

@implementation XMLTool

+ (instancetype)shareInstance{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        mXMLTool = [[[self class] alloc] init];
    });
    return mXMLTool;
}


-(NSMutableArray *)mDataArr{
    if (!_mDataArr) {
        _mDataArr = [NSMutableArray array];
    }
    return _mDataArr;
}

- (void)start
{
    //防止多次调用 数据累积
    [_mDataArr removeAllObjects];
    _mTag = nil;
    
    NSURL *pathUrl = [[NSBundle mainBundle] URLForResource:@"simple" withExtension:@"xml"];
    NSXMLParser *parser = [[NSXMLParser alloc] initWithContentsOfURL:pathUrl];
    parser.delegate = self;
    [parser parse];
}

- (void)parserDidStartDocument:(NSXMLParser *)parser{
    PRINT_F
}

- (void)parserDidEndDocument:(NSXMLParser *)parser{
    PRINT_F
}

// XML解析器读取到节点
- (void)parser:(NSXMLParser *)parser
didStartElement:(NSString *)elementName
  namespaceURI:(NSString *)namespaceURI
 qualifiedName:(NSString *)qName
    attributes:(NSDictionary<NSString *,NSString *> *)attributeDict
{
    PRINT_O(elementName)
    _mTag = elementName;
    //读取到起始节点，创建对象
    if ([elementName isEqualToString:K_FOOD]) {
        Food *food = [[Food alloc] init];
        [self.mDataArr addObject:food];
    }
}

- (void)parser:(NSXMLParser *)parser
 didEndElement:(NSString *)elementName
  namespaceURI:(NSString *)namespaceURI
 qualifiedName:(NSString *)qName
{
    PRINT_O(elementName)
    _mTag = nil;
}

- (void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)string
{
    //读取到开始标签和结束标签之间的数据
    PRINT_O(string)
    if ([_mTag isEqualToString:K_NAME] ||
        [_mTag isEqualToString:K_PRICE] ||
        [_mTag isEqualToString:K_DESCRIPT] ||
        [_mTag isEqualToString:K_CALORIES])
    {
        Food *food = [_mDataArr lastObject];
        [food f_setValue:string forKey:_mTag];
    }
}

//MARK:-API
- (Food*)dataAtIndexPath:(NSIndexPath*)indexPath {
    NSInteger index = indexPath.row;
    NSInteger count = _mDataArr.count;
    if (count && 0 <= index && index < count) {
        return _mDataArr[index];
    }
    return nil;
}

- (NSUInteger)numOfDatasource
{
    return _mDataArr.count;
}

@end
