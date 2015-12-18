//
//  ViewController.h
//  HealthyTest
//
//  Created by Fillinse on 15/12/18.
//  Copyright © 2015年 Fillinse. All rights reserved.
//

#import <UIKit/UIKit.h>
@import HealthKit;

@interface ViewController : UIViewController

@property (strong, nonatomic) HKHealthStore *healthManager;
@end

