//
//  Food.m
//  Greens
//
//  Created by Todd Mathison on 6/12/14.
//  Copyright (c) 2014 Todd Mathison. All rights reserved.
//

#import "Food.h"

@implementation Food

@synthesize title,description,textColor,backgroundColor,examples;

+(NSArray *)foods
{
    NSMutableArray *array = [[NSMutableArray alloc] init];
    
    Food *f1 = [[Food alloc] init];
    [f1 setTitle:@"Red"];
    [f1 setDescription:@"Red foods typically have high levels of vitamin A, vitamin C, Manganese, and Fiber. Their antioxident properites make them good for memory, lung function, joints, and fighting various cancers."];
    [f1 setTextColor:[UIColor whiteColor]];
    [f1 setBackgroundColor:[UIColor colorWithRed:233.0f/255.0f green:39.0f/255.0f blue:47.0f/255.0f alpha:1.0f]];

    [f1 setExamples:@[
    @"Beets"
    ,@"Blood Oranges"
    ,@"Cherries"
    ,@"Cranberries"
    ,@"Guava"
    ,@"Papaya"
    ,@"Pink Grapefruit"
    ,@"Pink/Red Grapefruit"
    ,@"Pomegranates"
    ,@"Radicchio"
    ,@"Radishes"
    ,@"Raspberries"
    ,@"Red Bell Peppers"
    ,@"Red Chili Peppers"
    ,@"Red Grapes"
    ,@"Red Onions"
    ,@"Red Pears"
    ,@"Red Peppers"
    ,@"Red Potatoes"
    ,@"Rhubarb"
    ,@"Strawberries"
    ,@"Tomatoes"
    ,@"Watermelon"
    ]];
    

    Food *f2 = [[Food alloc] init];
    [f2 setTitle:@"Orange/Yellow"];
    [f2 setDescription:@"Orange and yellow foods are high in beta-carotene (a form of vitamin A), vitamin C, and Fiber. They are great for our immune system, heart health, fighting aging, vision, and skin health."];
    [f2 setTextColor:[UIColor whiteColor]];
    [f2 setBackgroundColor:[UIColor colorWithRed:244.0f/255.0f green:148.0f/255.0f blue:51.0f/255.0f alpha:1.0f]];
    [f2 setExamples:@[
    @"Apricots"
    ,@"Butternut Squash"
    ,@"Cantelope"
    ,@"Cape Gooseberries"
    ,@"Carrots"
    ,@"Golden Kiwifruit"
    ,@"Grapefruit"
    ,@"Lemon"
    ,@"Mangoes"
    ,@"Nectarines"
    ,@"Oranges"
    ,@"Papayas"
    ,@"Peaches"
    ,@"Persimmons"
    ,@"Pineapples"
    ,@"Pumpkin"
    ,@"Rutabagas"
    ,@"Sweet Corn"
    ,@"Sweet Potatoes"
    ,@"Tangerines"
    ,@"Yellow Apples"
    ,@"Yellow Beets"
    ,@"Yellow Figs"
    ,@"Yellow Pears"
    ,@"Yellow Peppers"
    ,@"Yellow Potatoes"
    ,@"Yellow Summer Squash"
    ,@"Yellow Tomatoes"
    ,@"Yellow Watermelon"
    ,@"Yellow Winter Squash"
    ]];

    Food *f3 = [[Food alloc] init];
    [f3 setTitle:@"White/Tan"];
    [f3 setDescription:@"White and tan foods are void in color, but packed with minerals and vitamins like vitamin C, vitamin K, folate, and fiber. They’re filled with anti-bacterial, anti-fungal, and anti-viral proteries."];
    [f3 setTextColor:[UIColor colorWithRed:180.0f/255.0f green:170.0f/255.0f blue:162.0f/255.0f alpha:1.0f]];
    [f3 setBackgroundColor:[UIColor colorWithRed:241.0f/255.0f green:231.0f/255.0f blue:220.0f/255.0f alpha:1.0f]];
    [f3 setExamples:@[
    @"Bananas"
    ,@"Brown Pears"
    ,@"Cauliflower"
    ,@"Dates"
    ,@"Garlic"
    ,@"Ginger"
    ,@"Jerusalem Artichoke"
    ,@"Jicama"
    ,@"Kohlrabi"
    ,@"Mushrooms"
    ,@"Onions"
    ,@"Parsnips"
    ,@"Potatoes"
    ,@"Shallots"
    ,@"Soy Beans"
    ,@"Turnips"
    ,@"White Corn"
    ,@"White Nectarines"
    ,@"White Peaches"
    ]];

    Food *f4 = [[Food alloc] init];
    [f4 setTitle:@"Green"];
    [f4 setDescription:@"Green foods have a high level of chlorophyl which helps fight cell damage. They contain vitamin K, vitamin C, numerous B vitamins, and minerals."];
    [f4 setTextColor:[UIColor whiteColor]];
    [f4 setBackgroundColor:[UIColor colorWithRed:120.0f/255.0f green:190.0f/255.0f blue:77.0f/255.0f alpha:1.0f]];
    [f4 setExamples:@[
    @"Artichokes"
    ,@"Arugula"
    ,@"Asparagus"
    ,@"Avocados"
    ,@"Broccoflower"
    ,@"Broccoli"
    ,@"Broccoli Rabe"
    ,@"Brussels Sprouts"
    ,@"Celery"
    ,@"Chayote Squash"
    ,@"Chinese Cabbage"
    ,@"Cucumbers"
    ,@"Edamame"
    ,@"Endive"
    ,@"Green Apples"
    ,@"Green Beans"
    ,@"Green Cabbage"
    ,@"Green Grapes"
    ,@"Green Onion"
    ,@"Green Pears"
    ,@"Green Peppers"
    ,@"Honeydew"
    ,@"Kiwifruit"
    ,@"Leafy Greens"
    ,@"Leeks"
    ,@"Lettuce"
    ,@"Limes"
    ,@"Okra"
    ,@"Peas"
    ,@"Snow Peas"
    ,@"Spinach"
    ,@"Sugar Snap Peas"
    ,@"Swiss Chard"
    ,@"Watercress"
    ,@"Zucchini"
    ]];
    
    Food *f5 = [[Food alloc] init];
    [f5 setTitle:@"Blue/Purple"];
    [f5 setDescription:@"Blue and purple foods are loaded with powerful antioxidents. They contain fiber, vitamin C, vitamin K, manganese for improving brain health, fighting inflammation, improving the immune system, aiding in digestion, and heart health."];
    [f5 setTextColor:[UIColor whiteColor]];
    [f5 setBackgroundColor:[UIColor colorWithRed:39.0f/255.0f green:105.0f/255.0f blue:176.0f/255.0f alpha:1.0f]];
    [f5 setExamples:@[
    @"Black Currants"
    ,@"Black Salsify"
    ,@"Blackberries"
    ,@"Blueberries"
    ,@"Dried Plums"
    ,@"Eggplant"
    ,@"Elderberries"
    ,@"Grapes"
    ,@"Plums"
    ,@"Pomegranates"
    ,@"Prunes"
    ,@"Purple Belgian Endive"
    ,@"Purple Potatoes"
    ,@"Purple Asparagus"
    ,@"Purple Cabbage"
    ,@"Purple Carrots"
    ,@"Purple Figs"
    ,@"Purple Grapes"
    ,@"Purple Peppers"
    ,@"Raisins"
    ]];
    
    [array addObject:f1];
    [array addObject:f2];
    [array addObject:f3];
    [array addObject:f4];
    [array addObject:f5];

    return array;
}

@end
