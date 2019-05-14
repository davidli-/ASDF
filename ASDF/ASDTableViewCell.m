//
//  ASDTableViewCell.m
//  ASDF
//
//  Created by Macmafia on 2019/5/13.
//  Copyright © 2019 Macmafia. All rights reserved.
//

#import "ASDTableViewCell.h"
#import "Masonry.h"

@interface ASDTableViewCell ()
@property (nonatomic, strong) UILabel *label;
@property (nonatomic, strong) UILabel *timeLabel;
@property (nonatomic, strong) UILabel *durationLabel;
@property (nonatomic, strong) UIButton *startBtn;

@end

@implementation ASDTableViewCell

//通过 [registerNib:forCellReuseIdentifier:]方法注册cell时，如果重用cell时发现没有，则会从nib中加载cell，并调用这里
- (void)awakeFromNib {
    [super awakeFromNib];
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder{
    self = [super initWithCoder:aDecoder];
    return self;
}

//通过 [registerClass: forCellReuseIdentifier:]方法注册cell时，重用cell时需要自己判断cell是否存在；不存在时则主动调用此方法创建一个；
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        //设置 "self.contentview" 中的内容和布局(不是直接加载到 self 上)
        
        //行号
        UILabel *label = [[UILabel alloc] init];
        [self.contentView addSubview:label];
        label.text = @"default";
        [label mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self.contentView);
            make.leading.equalTo(self.contentView).offset(20);
            make.trailing.greaterThanOrEqualTo(self.contentView).offset(0);
        }];
        _label = label;
        
        //进度
        UILabel *label2 = [[UILabel alloc] init];
        [self.contentView addSubview:label2];
        label2.text = @"00:00";
        [label2 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.centerY.equalTo(self.contentView);
        }];
        _timeLabel = label2;
        
        //播放
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeInfoDark];
        [btn addTarget:self action:@selector(onStart:) forControlEvents:UIControlEventTouchUpInside];
        [self.contentView addSubview:btn];
        [btn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.trailing.equalTo(self.contentView).offset(-20);
            make.centerY.equalTo(self.contentView);
        }];
        _startBtn = btn;
        
        
        //时长
        UILabel *label3 = [[UILabel alloc] init];
        [self.contentView addSubview:label3];
        label3.text = @"00:00";
        [label3 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.leading.greaterThanOrEqualTo(label2.mas_trailing).offset(20);
            make.trailing.equalTo(btn).offset(-40);
            make.centerY.equalTo(self.contentView);
        }];
        _durationLabel = label3;
        
    }
    return self;
}

- (void)setWithIndex:(NSInteger)index model:(ASDTableViewModel*)model delegate:(id<ASDTableViewCellDelegate>)dele
{
    self.delegate = dele;
    self.index = index;
    
    //重置所有样式，解决重用时保留了上个cell样式的问题
    _label.text = [NSString stringWithFormat:@"%ld",(long)index];
    _timeLabel.text = model.nowTime;
    _durationLabel.text = model.remain;
    
    
    __weak ASDTableViewCell *wSelf = self;
    __weak ASDTableViewModel *wModel = model;
    
    //防止cell重用时，多次监听的情况（多次监听就会多次触发回调）
    if (!model.observed) {
        model.observed = YES;
        
        //[model.player addObserver:model forKeyPath:@"status" options:NSKeyValueObservingOptionNew context:nil];
        [model.player addPeriodicTimeObserverForInterval:CMTimeMakeWithSeconds(1, NSEC_PER_SEC)
                                                   queue:NULL //NNULL 使用主队列（此处一定要是串行队列，否则会发生未知错误）
                                              usingBlock:^(CMTime time) {
            __strong ASDTableViewCell *sSelf = wSelf;
            __strong ASDTableViewModel *sModel = wModel;
            
            NSInteger textIndex = sSelf.label.text.integerValue;
            NSInteger modelInxex = sModel.index;
            
            /*回调回来后判断model的index与cell的行号是否相同（回调回来时cell可能已经被别的行重用了）*/
            if (textIndex == modelInxex) {
                
                NSLog(@"+++cellIndex:%ld,modelIndex:%ld",(long)textIndex,(long)modelInxex);
                
                double timeT = CMTimeGetSeconds(time);
                if (isnan(timeT)) {
                    return;
                }
                
                //计算当前播放时间
                int minute = timeT / 60.0;
                int second = [[NSNumber numberWithDouble:timeT] intValue] % 60;
                sModel.nowTime = [NSString stringWithFormat:@"%d:%d",minute,second];
                sSelf.timeLabel.text = sModel.nowTime; //更新文本
                
                //计算剩余可播放时长
                double timeRemain = CMTimeGetSeconds(sModel.player.currentItem.duration) - timeT;
                if (timeRemain > 0) {
                    minute = timeRemain / 60.0;
                    second = [[NSNumber numberWithDouble:timeRemain] intValue] % 60;
                    sModel.remain = [NSString stringWithFormat:@"%d:%d",minute,second];
                    sSelf.durationLabel.text = sModel.remain; //更新文本
                }
            }else{
                NSLog(@"+++cellIndex:%ld,modelIndex:%ld,行号不相等，拒绝更新文本~~",(long)textIndex,(long)modelInxex);
            }
        }];
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

-(void)layoutSubviews{
    [super layoutSubviews];
    //这里是自定义的布局信息
}


- (void)onStart:(UIButton*)sender{
    ASDTableViewCell *cell = (ASDTableViewCell*)[[sender superview] superview];
    NSInteger index = cell.index;
    if ([_delegate respondsToSelector:@selector(ASDTableViewCell:didSelectRow:)]) {
        [_delegate ASDTableViewCell:self didSelectRow:index];
    }
    printf("++index%ld",(long)index);
}

@end
