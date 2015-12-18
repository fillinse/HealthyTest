//
//  ViewController.m
//  HealthyTest
//
//  Created by Fillinse on 15/12/18.
//  Copyright © 2015年 Fillinse. All rights reserved.
//

#import "ViewController.h"
@interface ViewController ()
@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    UIButton *healthBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    healthBtn.frame = CGRectMake(50, 100, 200, 20);
    [healthBtn setTitle:@"health request" forState:normal];
    [healthBtn setTitleColor:[UIColor redColor] forState:normal];
    [healthBtn addTarget:self action:@selector(healthTestClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:healthBtn];
    
    UIButton *writeData = [UIButton buttonWithType:UIButtonTypeCustom];
    writeData.frame = CGRectMake(100, 200, 100, 20);
    [writeData setTitle:@"writeData" forState:normal];
    [writeData setTitleColor:[UIColor redColor] forState:normal];
    [writeData addTarget:self action:@selector(writeData) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:writeData];

}
- (void)healthTestClick
{
    BOOL isSuccess = [HKHealthStore isHealthDataAvailable];
    //    NSLog(@"--isHealthDataAvailable--%d",isSuccess);
    if (isSuccess)
    {
        if([[UIDevice currentDevice].systemVersion floatValue]>=8.0)
        {
            //初始化健康中心对象
            self.healthManager = [[HKHealthStore alloc] init];
            //创建需要写权限的集合
            NSSet *writeDataTypes = [self dataTypesToWrite];
            //创建需要读权限的集合
            NSSet *readDataTypes = [self dataTypesToRead];
            //请求所需的权限
            [self.healthManager requestAuthorizationToShareTypes:writeDataTypes readTypes:readDataTypes completion:^(BOOL success, NSError *error) {
                if (!success)
                {
                    NSLog(@"You didn't allow HealthKit to access these read/write data types. In your app, try to handle this error gracefully when a user decides not to provide access. The error was: %@. If you're using a simulator, try it on a device.", error);
                    
                    return;
                }
            }];
        }
    }
}
- (void)writeData
{
    [self writeDataToHealthKit];
}
- (NSSet *)dataTypesToWrite
{
    HKQuantityType *weightType = [HKQuantityType quantityTypeForIdentifier:HKQuantityTypeIdentifierBodyMass];
    
    HKQuantityType *BMIType = [HKQuantityType quantityTypeForIdentifier:HKQuantityTypeIdentifierBodyMassIndex];
    
    HKQuantityType *FatType = [HKQuantityType quantityTypeForIdentifier:HKQuantityTypeIdentifierBodyFatPercentage];
    
    return [NSSet setWithObjects:weightType, BMIType, FatType, nil];
}
- (NSSet *)dataTypesToRead
{
    //膳食卡路里
    HKQuantityType *dietaryCalorieEnergyType = [HKObjectType quantityTypeForIdentifier:HKQuantityTypeIdentifierDietaryEnergyConsumed];
    //活动能量
    HKQuantityType *activeEnergyBurnType = [HKObjectType quantityTypeForIdentifier:HKQuantityTypeIdentifierActiveEnergyBurned];
    //身高数据
    HKQuantityType *heightType = [HKObjectType quantityTypeForIdentifier:HKQuantityTypeIdentifierHeight];
    //体重数据
    HKQuantityType *weightType = [HKObjectType quantityTypeForIdentifier:HKQuantityTypeIdentifierBodyMass];
    //出生日期
    HKCharacteristicType *birthdayType = [HKObjectType characteristicTypeForIdentifier:HKCharacteristicTypeIdentifierDateOfBirth];
    //性别
    HKCharacteristicType *biologicalSexType = [HKObjectType characteristicTypeForIdentifier:HKCharacteristicTypeIdentifierBiologicalSex];
    //BMI
    HKQuantityType *BMIType = [HKQuantityType quantityTypeForIdentifier:HKQuantityTypeIdentifierBodyMassIndex];
    //体脂
    HKQuantityType *FatType = [HKQuantityType quantityTypeForIdentifier:HKQuantityTypeIdentifierBodyFatPercentage];
    //步数
    HKQuantityType *stepCount = [HKQuantityType quantityTypeForIdentifier:HKQuantityTypeIdentifierStepCount];
    //步行/跑步距离
    HKQuantityType *walkDistance = [HKQuantityType quantityTypeForIdentifier:HKQuantityTypeIdentifierDistanceWalkingRunning];
    
    return [NSSet setWithObjects:dietaryCalorieEnergyType, activeEnergyBurnType, heightType, weightType, birthdayType, biologicalSexType,BMIType,FatType,stepCount,walkDistance, nil];
}
#pragma mark - Writing HealthKit Data

- (void)writeDataToHealthKit
{
    // Save the user's weight into HealthKit.
    NSDate *now = [NSDate date];
    
    //体重
    CGFloat weight = 65.6;/** 模拟体重 */
    HKUnit *gramUnit = [HKUnit gramUnit];/** 单位 g  本单位。可以自行设置 */
    HKQuantity *weightQuantity = [HKQuantity quantityWithUnit:gramUnit doubleValue: 1000 * weight];
    HKQuantityType *weightType = [HKQuantityType quantityTypeForIdentifier:HKQuantityTypeIdentifierBodyMass];
    HKQuantitySample *weightSample = [HKQuantitySample quantitySampleWithType:weightType quantity:weightQuantity startDate:now endDate:now];
    
    //BMI 身高体重指数
    CGFloat bmi = 21.2;
    HKQuantity *BMIQuantity = [HKQuantity quantityWithUnit:[HKUnit countUnit] doubleValue:bmi];
    
    HKQuantityType *BMIType = [HKQuantityType quantityTypeForIdentifier:HKQuantityTypeIdentifierBodyMassIndex];
    
    HKQuantitySample *BMISample = [HKQuantitySample quantitySampleWithType:BMIType quantity:BMIQuantity startDate:now endDate:now];
    
    //体脂率
    HKQuantity *FatQuantity = [HKQuantity quantityWithUnit:[HKUnit percentUnit] doubleValue:46/100];
    
    HKQuantityType *FatType = [HKQuantityType quantityTypeForIdentifier:HKQuantityTypeIdentifierBodyFatPercentage];
    
    HKQuantitySample *FatSample = [HKQuantitySample quantitySampleWithType:FatType quantity:FatQuantity startDate:now endDate:now];
    
    [self.healthManager saveObjects:[NSArray arrayWithObjects:weightSample, BMISample, FatSample, nil] withCompletion:^(BOOL success, NSError *error) {
        if (!success) {
            NSLog(@"An error occured saving the weight sample %@. In your app, try to handle this gracefully. The error was: %@.", weightSample, error);
        }
        else
        {
            NSLog(@"healthKit success");
        }
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
