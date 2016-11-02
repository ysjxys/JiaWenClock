//
//  EditWorkTypeViewController.m
//  JiawenClock
//
//  Created by ysj on 16/9/27.
//  Copyright © 2016年 yushengjie. All rights reserved.
//

#import "EditWorkTypeViewController.h"
#import "UIView+YSJ.h"
#import "YSJTextField.h"
#import "UIBarButtonItem+YSJ.h"
#import "FMDBHelper.h"

@interface EditWorkTypeViewController ()<UITextFieldDelegate,UIPickerViewDelegate,UIPickerViewDataSource>

@property (nonatomic, assign) WorkTypeMode workTypeMode;

@property (nonatomic, strong) YSJTextField *loveNameTF;
@property (nonatomic, strong) YSJTextField *startTimeTF;
@property (nonatomic, strong) YSJTextField *endTimeTF;

@property (nonatomic, strong) UIPickerView *startTimePicker;
@property (nonatomic, strong) UIPickerView *endTimePicker;

@property (nonatomic, copy) NSArray *hourArr;
@property (nonatomic, copy) NSArray *minArr;

@property (nonatomic, assign) int startHour;
@property (nonatomic, assign) int startMinute;
@property (nonatomic, assign) int endHour;
@property (nonatomic, assign) int endMinute;
@end

@implementation EditWorkTypeViewController

- (instancetype)initWithWorkTypeMode:(WorkTypeMode)workTypeMode{
    if (self = [super init]) {
        self.workTypeMode = workTypeMode;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initData];
    [self initViews];
}

- (void)initData{
    _hourArr = @[@"0",@"1",@"2",@"3",@"4",@"5",@"6",@"7",@"8",@"9",
                @"10",@"11",@"12",@"13",@"14",@"15",@"16",@"17",@"18",@"19",@"20",
                 @"21",@"22",@"23"];
    _minArr = @[@"0",@"1",@"2",@"3",@"4",@"5",@"6",@"7",@"8",@"9",
            @"10",@"11",@"12",@"13",@"14",@"15",@"16",@"17",@"18",@"19",
            @"20",@"21",@"22",@"23",@"24",@"25",@"26",@"27",@"28",@"29",
            @"30",@"31",@"32",@"33",@"34",@"35",@"36",@"37",@"38",@"39",
            @"40",@"41",@"42",@"43",@"44",@"45",@"46",@"47",@"48",@"49",
            @"50",@"51",@"52",@"53",@"54",@"55",@"56",@"57",@"58",@"59"];
    if (_workTypeMode == WorkTypeModeAdd) {
        _startHour = 0;
        _startMinute = 0;
        _endHour = 0;
        _endMinute = 0;
    }else{
        _startHour = [[_workTypeModel.startTime substringToIndex:2] intValue];
        _startMinute = [[_workTypeModel.startTime substringWithRange:NSMakeRange(2, 2)] intValue];
        _endHour = [[_workTypeModel.endTime substringToIndex:2] intValue];
        _endMinute = [[_workTypeModel.endTime substringWithRange:NSMakeRange(2, 2)] intValue];
    }
}

- (void)initViews{
    self.view.backgroundColor = [UIColor groupTableViewBackgroundColor];
    self.edgesForExtendedLayout = UIRectEdgeNone;
    self.navigationItem.title = _workTypeMode==WorkTypeModeAdd?@"添加工作类型":@"修改工作类型";
    
    self.navigationItem.leftBarButtonItem = [UIBarButtonItem itemWithTitle:@"取消" color:[UIColor blackColor] textSize:15.0f bounds:CGRectMake(0, 0, 50, 35) alignment:UIControlContentHorizontalAlignmentLeft target:self action:@selector(cancelBarButtonItemSelected)];
    
    self.navigationItem.rightBarButtonItem = [UIBarButtonItem itemWithTitle:@"确定" color:[UIColor blackColor] textSize:15.0f bounds:CGRectMake(0, 0, 50, 35) alignment:UIControlContentHorizontalAlignmentRight target:self action:@selector(sureBarButtonItemSelected)];
    
    _loveNameTF = [[YSJTextField alloc]initWithFrame:CGRectMake(0, 50, self.view.width, 44)];
    _loveNameTF.delegate = self;
    _loveNameTF.textAlignment = NSTextAlignmentRight;
    _loveNameTF.backgroundColor = [UIColor whiteColor];
    _loveNameTF.borderStyle = UITextBorderStyleNone;
    _loveNameTF.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
//    _loveNameTF.clearButtonMode = UITextFieldViewModeWhileEditing;
    _loveNameTF.placeholder = @"请输入班次简称";
    [self.view addSubview:_loveNameTF];
    
    UILabel *loveNameTitleLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, 50, 100, 44)];
    loveNameTitleLabel.text = @"班次简称";
    [self.view addSubview:loveNameTitleLabel];
    
    
    _startTimeTF = [[YSJTextField alloc]initWithFrame:CGRectMake(0, 150, self.view.width, 44)];
    _startTimeTF.placeholder = @"请选择起始时间";
    _startTimeTF.textAlignment = NSTextAlignmentRight;
    _startTimeTF.userInteractionEnabled = YES;
    _startTimeTF.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:_startTimeTF];
    
    UILabel *startTimeTitleLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, 150, 100, 44)];
    startTimeTitleLabel.text = @"起始时间";
    [self.view addSubview:startTimeTitleLabel];
    
    UIView *startTimeBackView = [[UIView alloc]initWithFrame:_startTimeTF.frame];
    [self.view addSubview:startTimeBackView];
    [startTimeBackView addGestureRecognizer:[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(startTimeChoose)]];
    
    
    _endTimeTF = [[YSJTextField alloc] initWithFrame:CGRectMake(0, 250, self.view.width, 44)];
    _endTimeTF.placeholder = @"请选择结束时间";
    _endTimeTF.textAlignment = NSTextAlignmentRight;
    _endTimeTF.userInteractionEnabled = YES;
    _endTimeTF.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:_endTimeTF];
    
    UILabel *endTimeTitleLabe = [[UILabel alloc]initWithFrame:CGRectMake(10, 250, 100, 44)];
    endTimeTitleLabe.text = @"结束时间";
    [self.view addSubview:endTimeTitleLabe];
    
    UIView *endTimeBackView = [[UIView alloc]initWithFrame:_endTimeTF.frame];
    [self.view addSubview:endTimeBackView];
    [endTimeBackView addGestureRecognizer:[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(endTimeChoose)]];
    
    _startTimePicker = [[UIPickerView alloc]initWithFrame:CGRectMake(0, self.view.bottom, self.view.width, 216.0f)];
    _startTimePicker.delegate = self;
    _startTimePicker.dataSource = self;
    [_startTimePicker selectRow:_hourArr.count*25 inComponent:0 animated:YES];
    [_startTimePicker selectRow:_minArr.count*25 inComponent:1 animated:YES];
    [self.view addSubview:_startTimePicker];
    
    _endTimePicker = [[UIPickerView alloc]initWithFrame:_startTimePicker.frame];
    _endTimePicker.delegate = self;
    _endTimePicker.dataSource = self;
    [_endTimePicker selectRow:_hourArr.count*25 inComponent:0 animated:YES];
    [_endTimePicker selectRow:_minArr.count*25 inComponent:1 animated:YES];
    [self.view addSubview:_endTimePicker];
    
    if (_workTypeMode == WorkTypeModeEdit) {
        _loveNameTF.text = _workTypeModel.loveName;
        [self updateStartTimeText];
        [self updateEndTimeText];
        [_startTimePicker selectRow:_hourArr.count*25+_startHour inComponent:0 animated:NO];
        [_startTimePicker selectRow:_minArr.count*25+_startMinute inComponent:1 animated:NO];
        [_endTimePicker selectRow:_hourArr.count*25+_endHour inComponent:0 animated:NO];
        [_endTimePicker selectRow:_minArr.count*25+_endMinute inComponent:1 animated:NO];
    }
}

- (void)updateStartTimeText{
    NSString *startHourStr = _startHour<10?[NSString stringWithFormat:@"0%d",_startHour]:[NSString stringWithFormat:@"%d",_startHour];
    NSString *startMinuteStr = _startMinute<10?[NSString stringWithFormat:@"0%d",_startMinute]:[NSString stringWithFormat:@"%d",_startMinute];
    _startTimeTF.text = [NSString stringWithFormat:@"%@:%@",startHourStr,startMinuteStr];
}

- (void)updateEndTimeText{
    NSString *endHourStr = _endHour<10?[NSString stringWithFormat:@"0%d",_endHour]:[NSString stringWithFormat:@"%d",_endHour];
    NSString *endMinuteStr = _endMinute<10?[NSString stringWithFormat:@"0%d",_endMinute]:[NSString stringWithFormat:@"%d",_endMinute];
    _endTimeTF.text = [NSString stringWithFormat:@"%@:%@",endHourStr,endMinuteStr];
}

#pragma  mark - btn selected

- (void)startTimeChoose{
    [UIView animateWithDuration:0.3 animations:^{
        _endTimePicker.frame = CGRectMake(0, self.view.bottom, self.view.width, 216.0f);
        _startTimePicker.frame = CGRectMake(0, self.view.bottom-216.0f, self.view.width, 216.0f);
    }];
    
    [self pickerView:_startTimePicker didSelectRow:_hourArr.count*25+_startHour inComponent:0];
    [self pickerView:_startTimePicker didSelectRow:_minArr.count*25+_startMinute inComponent:1];
}

- (void)endTimeChoose{
    [UIView animateWithDuration:0.3 animations:^{
        _startTimePicker.frame = CGRectMake(0, self.view.bottom, self.view.width, 216.0f);
        _endTimePicker.frame = CGRectMake(0, self.view.bottom-216.0f, self.view.width, 216.0f);
    }];
    
    [self pickerView:_endTimePicker didSelectRow:_hourArr.count*25+_endHour inComponent:0];
    [self pickerView:_endTimePicker didSelectRow:_minArr.count*25+_endMinute inComponent:1];
}

- (void)cancelBarButtonItemSelected{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)sureBarButtonItemSelected{
    if ([_loveNameTF.text isEqualToString:@""]) {
        [self showHudWithTitle:@"请输入工作类型简称"];
    }
    if (![_startTimeTF.text isEqualToString:@""]) {
        [self showHudWithTitle:@"请输入工作起始时间"];
    }
    if (![_endTimeTF.text isEqualToString:@""]) {
        [self showHudWithTitle:@"请输入工作结束时间"];
    }
    NSString *startTime = [_startTimeTF.text stringByReplacingOccurrencesOfString:@":" withString:@""];
    NSString *endTime = [_endTimeTF.text stringByReplacingOccurrencesOfString:@":" withString:@""];
    
    if (_workTypeMode == WorkTypeModeAdd) {
        NSDictionary *param = @{LoveNameKey:_loveNameTF.text,StartTimeKey:startTime,EndTimeKey:endTime};
        [FMDBHelper insertKeyValues:param intoTable:TableNameWorkType];
        [self dismissViewControllerAnimated:YES completion:^{
            [[NSNotificationCenter defaultCenter] postNotificationName:@"updateWorkTypeSettingViewControllerNotification" object:nil];
        }];
    }else{
        NSDictionary *param = @{LoveNameKey:_loveNameTF.text,StartTimeKey:startTime,EndTimeKey:endTime};
        [FMDBHelper updateTable:TableNameWorkType updateDic:param andOrKey:NoneKey compareKeyArr:@[[FMDBHelper compareKey:CompareKeyEqual]] columnArr:@[@{IdKey:@(_workTypeModel.workTypeId)}]];
        [self dismissViewControllerAnimated:YES completion:^{
            [[NSNotificationCenter defaultCenter] postNotificationName:@"updateWorkTypeSettingViewControllerNotification" object:nil];
        }];
    }
}

#pragma  mark - MainView selected
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [_loveNameTF resignFirstResponder];
    [UIView animateWithDuration:0.3 animations:^{
        _startTimePicker.frame = CGRectMake(0, self.view.bottom, self.view.width, 216.0f);
        _endTimePicker.frame = CGRectMake(0, self.view.bottom, self.view.width, 216.0f);
    }];
}

#pragma mark - PickerView
- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component{
    if (pickerView == _startTimePicker) {
        if (component == 0) {
            _startHour =[_hourArr[row%_hourArr.count] intValue];
        }else{
            _startMinute = [_minArr[row%_minArr.count] intValue];
        }
        [self updateStartTimeText];
    }else{
        if (component == 0) {
            _endHour =[_hourArr[row%_hourArr.count] intValue];
        }else{
            _endMinute = [_minArr[row%_minArr.count] intValue];
        }
        [self updateEndTimeText];
    }
}

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView{
    return 2;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component{
    return component==0?_hourArr.count*50:_minArr.count*50;
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component{
    return component==0?_hourArr[row%_hourArr.count]:_minArr[row%_minArr.count];
}

#pragma mark - TextField delegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    return YES;
}

- (void)textFieldDidBeginEditing:(UITextField *)textField{
    [textField becomeFirstResponder];
}

- (void)textFieldDidEndEditing:(UITextField *)textField{
    [textField resignFirstResponder];
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    if ([string isEqualToString:@""]) {
        return YES;
    }
    return textField.text.length > 10?NO:YES;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
