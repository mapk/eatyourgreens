//
//  Tips.m
//  Greens
//
//  Created by Todd Mathison on 7/19/14.
//  Copyright (c) 2014 Todd Mathison. All rights reserved.
//

#import "Tips.h"
#import "Entry.h"

@implementation Tips

@synthesize color, headline, message, food, date;

static NSString *fileName = @"SavedTips";


-(void)encodeWithCoder:(NSCoder *)coder
{
    [coder encodeObject:color forKey:@"color"];
    [coder encodeObject:headline forKey:@"headline"];
    [coder encodeObject:message forKey:@"message"];
    [coder encodeObject:food forKey:@"food"];
    [coder encodeObject:date forKey:@"date"];
}

-(id)initWithCoder:(NSCoder *)coder
{
    if(self = [self init])
    {
        color = [coder decodeObjectForKey:@"color"];
        headline = [coder decodeObjectForKey:@"headline"];
        message = [coder decodeObjectForKey:@"message"];
        food = [coder decodeObjectForKey:@"food"];
        date = [coder decodeObjectForKey:@"date"];
    }
    
    return self;
}


+(void)checkForTip
{
    BOOL showNewTip = YES;
    
    /*
    NSArray *tips = [Tips fetchSavedTips];
    
    if(tips.count == 0)
        showNewTip = YES;
    else
    {
        Tips *t = (Tips *)[tips firstObject];
        
        NSTimeInterval time = [[NSDate date] timeIntervalSinceDate:t.date];
        time = ABS(time);
        if(time > 60*60*24*7)
            showNewTip = YES;
    }

    NSMutableArray *last7Days = [[NSMutableArray alloc] init];

    if(showNewTip)
    {
        NSArray *entries = [Entry fetchFiles];
        
        NSDate *thisWeek  = [[NSDate date] dateByAddingTimeInterval: -604800.0];

        for(Entry *e in entries)
            if([e.date compare:thisWeek] == NSOrderedAscending)
                [last7Days addObject:e];
    }
     */

    if(showNewTip)
    {
    
        NSMutableArray *allTips = [NSMutableArray arrayWithArray:[Tips data]];
        NSArray *savedTips = [Tips fetchSavedTips];
        
        for(int i = (int)allTips.count-1; i>-1; i--)
        {
            BOOL found = NO;
            Tips *t1 = (Tips *)[allTips objectAtIndex:i];
            
            for(Tips *t2 in savedTips)
                if([t1.color isEqualToString:t2.color] && [t1.headline isEqualToString:t2.headline])
                {
                    found = YES;
                    break;
                }
            
            if(found)
                [allTips removeObjectAtIndex:i];
        }
        
        NSMutableArray *disliked = [[NSMutableArray alloc] init];
        
        NSDictionary *selected =  [NSMutableDictionary dictionaryWithDictionary:(NSDictionary *)[[NSUserDefaults standardUserDefaults] dictionaryForKey:@"selectedFoods"]];
        
        if(selected)
        {
            for(id key in selected)
            {
                NSNumber *n = (NSNumber *)[selected objectForKey:key];
                if(n.boolValue)
                    [disliked addObject:(NSString *)key];
            }
        }
        
        for(int i = (int)allTips.count-1; i>-1; i--)
        {
            Tips *t1 = (Tips *)[allTips objectAtIndex:i];
            
            for(NSString *s in disliked)
                if([s isEqualToString:t1.food])
                {
                    [allTips removeObjectAtIndex:i];
                    break;
                }
        }
        
        if(allTips.count > 0)
        {
        
            NSInteger i = arc4random() % allTips.count;
            Tips *t = (Tips *)[allTips objectAtIndex:i];
            [t setDate:[NSDate date]];
            [t save];
    
            UILocalNotification *localNotification = [[UILocalNotification alloc] init];
            [localNotification setAlertBody:t.headline];
            [localNotification setFireDate:[[NSDate date] dateByAddingTimeInterval:120]];
        //    [localNotification setUserInfo:dict];
            [localNotification setSoundName:UILocalNotificationDefaultSoundName];
            
            [[UIApplication sharedApplication] scheduleLocalNotification:localNotification];
        }
    }
}

+(void)clearTips
{
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSString *filePath = [DOCUMENTS_FOLDER stringByAppendingPathComponent:fileName];
    if([fileManager fileExistsAtPath:filePath])
        [fileManager removeItemAtPath:filePath error:nil];
}

+(NSArray *)fetchSavedTips
{
     NSFileManager *fileManager = [NSFileManager defaultManager];
     NSString *filePath = [DOCUMENTS_FOLDER stringByAppendingPathComponent:fileName];
     bool success = [fileManager fileExistsAtPath:filePath];
     
     if(!success) return nil;
     
     NSMutableArray *array = (NSMutableArray *)[NSKeyedUnarchiver unarchiveObjectWithFile:filePath];
     
     NSArray *a = [array sortedArrayUsingComparator:^NSComparisonResult(Tips *v1, Tips *v2){
         return [v2.date compare:v1.date];
     }];
    
    return a;
    
}

-(BOOL)save
{
     NSMutableArray *array = [NSMutableArray arrayWithArray:[Tips fetchSavedTips]];
     
     if(!array)
         array = [[NSMutableArray alloc] init];
     
    
     BOOL found = NO;
     
     if(array.count > 0)
     {
         for(int i = 0;i<array.count;i++)
         {
             Tips *v = (Tips *)[array objectAtIndex:i];
     
             if([v.color isEqualToString:self.color] && [v.headline isEqualToString:self.headline])
             {
                 [array removeObjectAtIndex:i];
                 [array insertObject:self atIndex:i];
     
                 found = YES;
                 break;
             }
         }
     }
     
     if(!found)
         [array addObject:self];
     
     [Tips clearTips];
     
     NSString *filePath = [DOCUMENTS_FOLDER stringByAppendingPathComponent:fileName];
     [NSKeyedArchiver archiveRootObject:array toFile:filePath];
     
     return YES;
}


-(NSString *)dateString
{
    NSString *s = @"";
    
    NSDateFormatter *df = [[NSDateFormatter alloc] init];
    [df setDateStyle:NSDateFormatterShortStyle];
    [df setTimeStyle:NSDateFormatterNoStyle];
    
    
    NSDateComponents *theDay = [[NSCalendar currentCalendar] components:NSEraCalendarUnit|NSYearCalendarUnit|NSMonthCalendarUnit|NSDayCalendarUnit fromDate:self.date];
    
    NSDateComponents *today = [[NSCalendar currentCalendar] components:NSEraCalendarUnit|NSYearCalendarUnit|NSMonthCalendarUnit|NSDayCalendarUnit fromDate:[NSDate date]];

    NSDate *yesterdayDay = [[NSDate date] dateByAddingTimeInterval: -86400.0];

    NSDateComponents *yesterday = [[NSCalendar currentCalendar] components:NSEraCalendarUnit|NSYearCalendarUnit|NSMonthCalendarUnit|NSDayCalendarUnit fromDate:yesterdayDay];
    
    
    NSDate *thisWeek  = [[NSDate date] dateByAddingTimeInterval: -604800.0];
    
    
    if([today day] == [theDay day] &&
       [today month] == [theDay month] &&
       [today year] == [theDay year] &&
       [today era] == [theDay era])
    {
        s = @"Today";
    }
    else if([yesterday day] == [theDay day] &&
                [yesterday month] == [theDay month] &&
                [yesterday year] == [theDay year] &&
                [yesterday era] == [theDay era])
    {
        s = @"Yesterday";
    }
    else if ([self.date compare:thisWeek] == NSOrderedDescending)
    {
        NSDateFormatter* day = [[NSDateFormatter alloc] init];
        [day setDateFormat: @"EEEE"];
        s = [day stringFromDate:self.date];
    }
    else
    {
        s = [df stringFromDate:self.date];
    }
    
    s = [s stringByAppendingString:@" >> "];
    
    return s;
}

+(Tips *)tipWithColor:(NSString *)c withHeadline:(NSString *)h withMessage:(NSString *)m withFood:(NSString *)f
{
    Tips *t = [[Tips alloc] init];
    [t setColor:c];
    [t setHeadline:h];
    [t setMessage:m];
    [t setFood:f];
    
    return t;
}


+(NSArray *)data
{
    NSMutableArray *array = [[NSMutableArray alloc] init];
    
    
    [array addObject:[Tips tipWithColor:@"Blue/Purple" withHeadline:@"Add some dark purple to your diet" withMessage:@"Try some black currants! They're an edible berry packed with antioxidants and vitamins, especially vitamin C." withFood:@"Black Currant"]];
    [array addObject:[Tips tipWithColor:@"Blue/Purple" withHeadline:@"Want to get crazy with some purple?" withMessage:@"Black salsify is also called an oyster plant because of the root's oyster-like flavor." withFood:@"Black Salsify"]];
    [array addObject:[Tips tipWithColor:@"Blue/Purple" withHeadline:@"Need some purple or blues?" withMessage:@"Blackberries contain vitamins, minerals, and antioxidants for your body." withFood:@"Blackberries"]];
    [array addObject:[Tips tipWithColor:@"Blue/Purple" withHeadline:@"Add these blue goodies, they're healthy" withMessage:@"You've likely heard how healthy blueberries are, so why don't you try some!" withFood:@"Blueberries"]];
    [array addObject:[Tips tipWithColor:@"Blue/Purple" withHeadline:@"Get your purple on!" withMessage:@"There are tons of recipes out there for eggplant. Give one a try and get some purple into your diet." withFood:@"Eggplant"]];
    [array addObject:[Tips tipWithColor:@"Blue/Purple" withHeadline:@"More berries please!" withMessage:@"Did you know? Elderberry juice was used to treat a flu pandemic in Panama in 1995. Looks like you need more blues and purples, so give these a try." withFood:@"Elderberries"]];
    [array addObject:[Tips tipWithColor:@"Blue/Purple" withHeadline:@"Kids love this purple food" withMessage:@"Plums will help you stay regular, especially the dried version, prunes." withFood:@"Plums"]];
    [array addObject:[Tips tipWithColor:@"Blue/Purple" withHeadline:@"Add this purple to your diet, it's worth the effort" withMessage:@"Pomegranates may be tricky to gather all those little bits together, but they're well worth the effort." withFood:@"Pomegranates"]];
    [array addObject:[Tips tipWithColor:@"Blue/Purple" withHeadline:@"This purple will keep you regular" withMessage:@"Prunes are the go to fruit to help keep you regular. They're great to eat by themselves, drink as a juice, or blend in smoothies." withFood:@"Prunes"]];
    [array addObject:[Tips tipWithColor:@"Blue/Purple" withHeadline:@"Purple & Leafy" withMessage:@"While it may be tricky to find, purple belgian endives are great to season up and make salads with." withFood:@"Purple Belgian Endive"]];
    [array addObject:[Tips tipWithColor:@"Blue/Purple" withHeadline:@"Time for more purple, eh?" withMessage:@"Purple Potatoes, commonly found in South America, and a colorful addition to any meal. High in potassium, they're great for regulating blood pressure." withFood:@"Purple Potatoes"]];
    [array addObject:[Tips tipWithColor:@"Blue/Purple" withHeadline:@"You're looking a bit low in the purples" withMessage:@"Purple Asparagus is much like its green brother, but has a purple color because of the high levels of anthocyanins. These contain anti-inflammatory and anti-cancer properties." withFood:@"Purple Asparagus"]];
    [array addObject:[Tips tipWithColor:@"Blue/Purple" withHeadline:@"Get those purple levels up" withMessage:@"Purple Cabbage is great in salads and offers a crunchy treat filled with fiber." withFood:@"Purple Cabbage"]];
    [array addObject:[Tips tipWithColor:@"Blue/Purple" withHeadline:@"What's up Doc? Not your purple levels" withMessage:@"Try some Purple Carrots! With all the benefits of the common orange carrot, purple carrots also contain anthocyanins which give them their purple color and act as anti-inflammatories." withFood:@"Purple Carrots"]];
    [array addObject:[Tips tipWithColor:@"Blue/Purple" withHeadline:@"Looks like you can use some purple" withMessage:@"Figs tend to go bad rather quickly, but if you get them while they're ripe, you'll love their soft texture and enjoyable taste!" withFood:@"Purple Figs"]];
    [array addObject:[Tips tipWithColor:@"Blue/Purple" withHeadline:@"We all love them, and you should try them" withMessage:@"Purple grapes are a family favorite. They're known to help with aging, cardiovascular problems, and eye problems." withFood:@"Purple Grapes"]];
    [array addObject:[Tips tipWithColor:@"Blue/Purple" withHeadline:@"Don't forget your purples" withMessage:@"You gotta be brave to try these little guys. Purple Peppers are hot and tasty. They'll enhance any meal." withFood:@"Purple Peppers"]];
    [array addObject:[Tips tipWithColor:@"Blue/Purple" withHeadline:@"Raise your purple intake" withMessage:@"Raisins are dense sources of energy, vitamins, minerals, and antioxidants. Grab and handful and go!" withFood:@"Raisins"]];
    [array addObject:[Tips tipWithColor:@"Green" withHeadline:@"A little more green will do you well" withMessage:@"Artichokes are low in calories and fat, but a rich source of dietary fiber." withFood:@"Artichokes"]];
    [array addObject:[Tips tipWithColor:@"Green" withHeadline:@"Launch the salad rocket" withMessage:@"Looks like you can use a bit of arugula in your diet. It's a green leafy vegetable that can benefit your health." withFood:@"Arugula"]];
    [array addObject:[Tips tipWithColor:@"Green" withHeadline:@"Are you missing some ruffage?" withMessage:@"Asparagus is known to help treat conditions like dropsy and Irritable Bowel Syndrom." withFood:@"Asparagus"]];
    [array addObject:[Tips tipWithColor:@"Green" withHeadline:@"Don't avoid these fats" withMessage:@"Avocados can be a healthy addition to anyone's diet." withFood:@"Avocados"]];
    [array addObject:[Tips tipWithColor:@"Green" withHeadline:@"It's not white, it's green!" withMessage:@"Oh yea, it's broccoflower - the GREEN cauliflower. Broccoflower is a good source of folate and fiber." withFood:@"Broccoflower"]];
    [array addObject:[Tips tipWithColor:@"Green" withHeadline:@"Get some greens in there!" withMessage:@"Broccoli is an excellent source of antioxidants, vitamins, and dietary fiber. Eat up, it's good for you." withFood:@"Broccoli"]];
    [array addObject:[Tips tipWithColor:@"Green" withHeadline:@"Up those greens" withMessage:@"Broccoli Rabe is commonly found in Italian, Galician, and Portuguese cuisines. While it resembles broccoli and bit, it's much more leafy." withFood:@"Broccoli Rabe"]];
    [array addObject:[Tips tipWithColor:@"Green" withHeadline:@"It's a green challenge" withMessage:@"Brussels Sprouts are a great way to add some green to your diet. After baking them in olive oil, they're tasty to pop into your mouth." withFood:@"Brussels Sprouts"]];
    [array addObject:[Tips tipWithColor:@"Green" withHeadline:@"Green, green, green" withMessage:@"One of the more crunchy greens is the beloved celery. But don't forget to eat the leaves too." withFood:@"Celery"]];
    [array addObject:[Tips tipWithColor:@"Green" withHeadline:@"Add some green to that color wheel" withMessage:@"Chayote Squash, or otherwise known as mirliton, has a mild sweet taste and crispy in texture." withFood:@"Chayote Squash"]];
    [array addObject:[Tips tipWithColor:@"Green" withHeadline:@"Explore the green side" withMessage:@"Try some Chinese Cabbage. Other names are bok choi, and napa cabbage. Did you know that Chinese Cabbage was ranked first for nutrient density of 41 'powerhouse' fruits and vegetables by a US Center for Disease Control study." withFood:@"Chinese Cabbage"]];
    [array addObject:[Tips tipWithColor:@"Green" withHeadline:@"Add some green with one of America's favorite veggies" withMessage:@"Cucumbers are a great addition to any vegetable or fruit salad." withFood:@"Cucumbers"]];
    [array addObject:[Tips tipWithColor:@"Green" withHeadline:@"Time for green!" withMessage:@"Edamame is a popular green treat. Try some today." withFood:@"Edamame"]];
    [array addObject:[Tips tipWithColor:@"Green" withHeadline:@"Dive into some green, you need it" withMessage:@"Endive is a leafy vegetable consummed throughout Europe and among the United States." withFood:@"Endive"]];
    [array addObject:[Tips tipWithColor:@"Green" withHeadline:@"Haven't seen any green for a while" withMessage:@"Try some Green Apples in your diet. They're high in fiber and probably one of the more nutritious apples around!" withFood:@"Green Apples"]];
    [array addObject:[Tips tipWithColor:@"Green" withHeadline:@"Snap it up with some green" withMessage:@"Green Beans are also known by other names such as snap beans, or french beans. They should be stiff but flexible and give a 'snap' sound when breaking them open." withFood:@"Green Beans"]];
    [array addObject:[Tips tipWithColor:@"Green" withHeadline:@"Don't be shy of the green" withMessage:@"Looks like you need some green. Chopped Green Cabbage is an excellent substitute for lettuce in tacos." withFood:@"Green Cabbage"]];
    [array addObject:[Tips tipWithColor:@"Green" withHeadline:@"Your colorwheels are a bit drab, add more greenery!" withMessage:@"Frozen Green Grapes are a perfect snack for those hot summer days!" withFood:@"Green Grapes"]];
    [array addObject:[Tips tipWithColor:@"Green" withHeadline:@"Time to green it up!" withMessage:@"Green Onions can be used raw in salads or cooked in stir-fries or other dishes. Go on and try them out!" withFood:@"Green Onion"]];
    [array addObject:[Tips tipWithColor:@"Green" withHeadline:@"Get those greens up!" withMessage:@"Green Pears are best when eaten fresh or can be cooked when it's slightly ripe." withFood:@"Green Pears"]];
    [array addObject:[Tips tipWithColor:@"Green" withHeadline:@"You're missing greens lately" withMessage:@"And they're missing you! Try adding some Green Peppers to your diet. Chop them up and mix them in with your salads or other dishes." withFood:@"Green Peppers"]];
    [array addObject:[Tips tipWithColor:@"Green" withHeadline:@"Honey, why don't you add a little green" withMessage:@"The way to do that is by eating some fresh, sweet Honeydew!" withFood:@"Honeydew"]];
    [array addObject:[Tips tipWithColor:@"Green" withHeadline:@"We think you need some more green" withMessage:@"Pick up a Kiwi, and peel back that fuzzy skin for a wonderful delight." withFood:@"Kiwifruit"]];
    [array addObject:[Tips tipWithColor:@"Green" withHeadline:@"Let's see some green!" withMessage:@"Everyone loves leafy greens. Add some to your diet." withFood:@"Leafy Greens"]];
    [array addObject:[Tips tipWithColor:@"Green" withHeadline:@"Can we leak you some green info?" withMessage:@"Leeks are a good way to add that onion flavor to your meals." withFood:@"Leeks"]];
    [array addObject:[Tips tipWithColor:@"Green" withHeadline:@"Lettuce' help you with some green advice" withMessage:@"Lettuce comes in a variety of leafy textures. We're sure you'll find one to make a natural part of every meal." withFood:@"Lettuce"]];
    [array addObject:[Tips tipWithColor:@"Green" withHeadline:@"Get some green by adding this to your water!" withMessage:@"Lime water can improve digestion, help stimulate the liver, lower blood pressure, and many others." withFood:@"Limes"]];
    [array addObject:[Tips tipWithColor:@"Green" withHeadline:@"Add some green to your plate with this African treat" withMessage:@"Popular in Africa, Okra is a great source of dietary fiber, minerals, and vitamins." withFood:@"Okra"]];
    [array addObject:[Tips tipWithColor:@"Green" withHeadline:@"A spoonfull of green" withMessage:@"Peas are one of the most nutritious leguminous vegetables around." withFood:@"Peas"]];
    [array addObject:[Tips tipWithColor:@"Green" withHeadline:@"Where's the greenery?" withMessage:@"Snow Peas can help! Just eat the whole pod, and enjoy. They're a wonderful snack." withFood:@"Snow Peas"]];
    [array addObject:[Tips tipWithColor:@"Green" withHeadline:@"Want the forearms of Popeye?" withMessage:@"Well then you gotta eat some spinach! 100g of it will provide 25% of your daily iron intake. Go for it." withFood:@"Spinach"]];
    [array addObject:[Tips tipWithColor:@"Green" withHeadline:@"It's green, leafy, and looking for you!" withMessage:@"Swiss Chard is an excellent source of vitamin C, vitamin K, vitamin A, and other nutrients." withFood:@"Swiss Chard"]];
    [array addObject:[Tips tipWithColor:@"Green" withHeadline:@"No green veggies? Try some herbs!" withMessage:@"Watercress is an herb and it's been around for a long time. Try adding the peppery flavored leaves to your meals." withFood:@"Watercress"]];
    [array addObject:[Tips tipWithColor:@"Green" withHeadline:@"You've been missing green lately" withMessage:@"Zucchini is a good source of dietary fiber and adds color and flavor to any meal." withFood:@"Zucchini"]];
    [array addObject:[Tips tipWithColor:@"White/Tan" withHeadline:@"Go on, get some whites in there" withMessage:@"When you think of bananas, you may think of the color yellow, but we don't eat the peels, right? The part we eat is white, so add some white to your diet by eating this fruit." withFood:@"Bananas"]];
    [array addObject:[Tips tipWithColor:@"White/Tan" withHeadline:@"You can use some nutritious browns" withMessage:@"Brown Pears are packed with dietary fiber, antioxidants, minerals, and vegetables." withFood:@"Brown Pears"]];
    [array addObject:[Tips tipWithColor:@"White/Tan" withHeadline:@"We see the color, but where's your white?" withMessage:@"The tightly clustered florets of Cauliflower are good to add to salads, meals, and can be eaten raw or cooked." withFood:@"Cauliflower"]];
    [array addObject:[Tips tipWithColor:@"White/Tan" withHeadline:@"Try this popular brown color" withMessage:@"Dates are one of the most popular fruits in the world. Their flavor is loved by many and often used to sweeten up many dishes." withFood:@"Dates"]];
    [array addObject:[Tips tipWithColor:@"White/Tan" withHeadline:@"You need some white in there" withMessage:@"Galric has long been used for its medicinal values. It boosts the immune system, helps fight off coughs and colds, and can even be used topically for special treatments." withFood:@"Garlic"]];
    [array addObject:[Tips tipWithColor:@"White/Tan" withHeadline:@"We're not seeing any white lately, why not?" withMessage:@"Ginger will help fill that gap. And its medicinal properties are a huge benefit such as relieving common colds or sore throats. It can even help against motion sickness." withFood:@"Ginger"]];
    [array addObject:[Tips tipWithColor:@"White/Tan" withHeadline:@"No whites? Time to get in touch with your roots" withMessage:@"Jerusalem Artichokes can be eaten raw, boiled and mashed, roasted, or sauteed like potato." withFood:@"Jerusalem Artichoke"]];
    [array addObject:[Tips tipWithColor:@"White/Tan" withHeadline:@"Where's the white?" withMessage:@"Jicama is a crispy ice-white, fruit-like root that can be eaten raw or cooked in both sweet and savory dishes." withFood:@"Jicama"]];
    [array addObject:[Tips tipWithColor:@"White/Tan" withHeadline:@"Time for some white food, eh?" withMessage:@"Mildly sweet, succulent Kohlrabi is notably rich in vitamins and dietary fiber." withFood:@"Kohlrabi"]];
    [array addObject:[Tips tipWithColor:@"White/Tan" withHeadline:@"Make some room for this white food!" withMessage:@"Often grouped with vegetables, mushrooms provide many of the nutritional attributes of produce, as well as attributes more commonly found in meat, beans or grains." withFood:@"Mushrooms"]];
    [array addObject:[Tips tipWithColor:@"White/Tan" withHeadline:@"Add some white in there" withMessage:@"Onions are very low in calories (just 40 calories per 100 g) and fats; however, rich in soluble dietary fiber." withFood:@"Onions"]];
    [array addObject:[Tips tipWithColor:@"White/Tan" withHeadline:@"A little white can go a long way" withMessage:@"Parsnips sweet, juicy root is rich in several health-benefiting phyto-nutrients, vitamins, minerals, and fiber." withFood:@"Parsnips"]];
    [array addObject:[Tips tipWithColor:@"White/Tan" withHeadline:@"Let's get some white foods going on" withMessage:@"Potatoes are one of the richest sources of starch, vitamins, minerals and dietary fiber." withFood:@"Potatoes"]];
    [array addObject:[Tips tipWithColor:@"White/Tan" withHeadline:@"White is a good food too, don't forget!" withMessage:@"Shallots have a better nutrition profile than onions. Give them a try." withFood:@"Shallots"]];
    [array addObject:[Tips tipWithColor:@"White/Tan" withHeadline:@"Remember to eat some white foods" withMessage:@"When including soybeans, try to stick with the whole food forms, and also consider giving preference to fermented versions like tempeh, fermented tofu, and soy miso." withFood:@"Soy Beans"]];
    [array addObject:[Tips tipWithColor:@"White/Tan" withHeadline:@"You're missing white foods" withMessage:@"Turnips can help the body scavenge harmful free radicals, prevent forms of cancers, inflammation, and help boost immunity." withFood:@"Turnips"]];
    [array addObject:[Tips tipWithColor:@"White/Tan" withHeadline:@"Make white foods a part of your meals" withMessage:@"American loves to grow corn. In fact, it's in everything. The important part is to eat non-GMO corn which may be more difficult to find." withFood:@"White Corn"]];
    [array addObject:[Tips tipWithColor:@"White/Tan" withHeadline:@"White fruits would be a good addition" withMessage:@"Nectarines are packed with numerous health promoting anti-oxidants, plant nutrients, minerals and vitamins." withFood:@"White Nectarines"]];
    [array addObject:[Tips tipWithColor:@"Orange/Yellow" withHeadline:@"Go on, eat the color orange" withMessage:@"Apricots are excellent sources of vitamin-A, and carotenes. They are a sweet fruit that's enjoyable to eat." withFood:@"Apricots"]];
    [array addObject:[Tips tipWithColor:@"Orange/Yellow" withHeadline:@"Try some nutritious oranges and yellows" withMessage:@"Butternut squash has pleasant nutty flavor and mildly sweet taste. Fresh raw butternut cubes may add special tang to vegetable salads." withFood:@"Butternut Squash"]];
    [array addObject:[Tips tipWithColor:@"Orange/Yellow" withHeadline:@"You're missing some oranges and yellows" withMessage:@"Cantaloupe is rich in numerous health promoting poly-phenolic plant derived compounds, vitamins, and minerals that are absolute for optimum health." withFood:@"Cantaloupe"]];
    [array addObject:[Tips tipWithColor:@"Orange/Yellow" withHeadline:@"Up those oranges and yellows" withMessage:@"Cape Gooseberries are often tart and have a texture similar to cherries." withFood:@"Cape Gooseberries"]];
    [array addObject:[Tips tipWithColor:@"Orange/Yellow" withHeadline:@"Get some oranges and yellows in there!" withMessage:@"Carrots are exceptionally rich source of carotenes and vitamin-A." withFood:@"Carrots"]];
    [array addObject:[Tips tipWithColor:@"Orange/Yellow" withHeadline:@"Don't be shy, try some oranges and yellows" withMessage:@"While its flavor provides a moment of delicious pleasure, the even greater value of Golden Kiwifruit lies in its healthy stores of vitamins C and E, potassium, and fiber." withFood:@"Golden Kiwifruit"]];
    [array addObject:[Tips tipWithColor:@"Orange/Yellow" withHeadline:@"You can use some more orange and yellow in your diet" withMessage:@"Grapefruit is rich in dietary insoluble fiber pectin, which by acting as a bulk laxative helps to protect the colon." withFood:@"Grapefruit"]];
    [array addObject:[Tips tipWithColor:@"Orange/Yellow" withHeadline:@"Yellows might be a good addition" withMessage:@"Studies show that Lemon water is one of the best things to drink in the morning when you wake up. Try it out." withFood:@"Lemon"]];
    [array addObject:[Tips tipWithColor:@"Orange/Yellow" withHeadline:@"Looks like you can use more orange and yellows" withMessage:@"According to new research study, Mango fruit has been found to protect against colon, breast, leukemia and prostate cancers." withFood:@"Mangoes"]];
    [array addObject:[Tips tipWithColor:@"Orange/Yellow" withHeadline:@"Add some orange and yellow foods to your plate" withMessage:@"Nectarines are packed with numerous health promoting anti-oxidants, plant nutrients, minerals and vitamins." withFood:@"Nectarines"]];
    [array addObject:[Tips tipWithColor:@"Orange/Yellow" withHeadline:@"Let's see some oranges" withMessage:@"Oranges are one of the most common fruits eaten throughout the world. Add them to your diet." withFood:@"Oranges"]];
    [array addObject:[Tips tipWithColor:@"Orange/Yellow" withHeadline:@"Time for some orange or yellow foods, eh?" withMessage:@"Papaya is one of the favorites of fruit lovers for its nutritional, digestive, and medicinal properties." withFood:@"Papayas"]];
    [array addObject:[Tips tipWithColor:@"Orange/Yellow" withHeadline:@"Balance it out with some orange and yellows" withMessage:@"Peaches can be eaten raw, or sliced into salads. They are a wonderful and juicy fruit." withFood:@"Peaches"]];
    [array addObject:[Tips tipWithColor:@"Orange/Yellow" withHeadline:@"Orange and yellows will help your color wheel" withMessage:@"Persimmons contain health benefiting flavonoid poly-phenolic anti-oxidants such as catechins and gallocatechins in addition to having an important anti-tumor compound, betulinic acid." withFood:@"Persimmons"]];
    [array addObject:[Tips tipWithColor:@"Orange/Yellow" withHeadline:@"Remember to eat variety" withMessage:@"Pineapple fruit contains a proteolytic enzyme bromelain that digests food by breaking down protein." withFood:@"Pineapples"]];
    [array addObject:[Tips tipWithColor:@"Orange/Yellow" withHeadline:@"Don't forget the orange and yellow foods" withMessage:@"Pumpkins are one of the food items recommended by dieticians in cholesterol controlling and weight reduction programs." withFood:@"Pumpkin"]];
    [array addObject:[Tips tipWithColor:@"Orange/Yellow" withHeadline:@"Still missing orange and yellow?" withMessage:@"Along with its strength in vitamin C and potassium, the Rutabaga offers manganese, and is a good source of fiber, thiamin, vitamin B6, calcium, magnesium, and phosphorus." withFood:@"Rutabagas"]];
    [array addObject:[Tips tipWithColor:@"Orange/Yellow" withHeadline:@"Try this sweet vegetable" withMessage:@"Corn features high-quality phyto-nutrition profile comprising of dietary fiber, vitamins, and antioxidants in addition to moderate proportions of minerals." withFood:@"Sweet Corn"]];
    [array addObject:[Tips tipWithColor:@"Orange/Yellow" withHeadline:@"It may not be Thanksgiving, but try this anyways" withMessage:@"Sweet Potatoes contain amylose which raises the blood sugar levels slowly on comparison to simple sugars and therefore, recommended as a healthy food supplement even in diabetes." withFood:@"Sweet Potatoes"]];
    [array addObject:[Tips tipWithColor:@"Orange/Yellow" withHeadline:@"Everyone loves this fruit, try it out" withMessage:@"Tangerines are high in vitamin-C and therefore should be an addition to your diet." withFood:@"Tangerines"]];
    [array addObject:[Tips tipWithColor:@"Orange/Yellow" withHeadline:@"Nothing beats orange and yellow foods" withMessage:@"The Yellow Beet variety is rich in ß-xanthin pigment." withFood:@"Yellow Beets"]];
    [array addObject:[Tips tipWithColor:@"Orange/Yellow" withHeadline:@"Have you eaten any orange or yellow foods latelly?" withMessage:@"Yellow Peppers contain an impressive list of plant nutrients that are known to have disease preventing and health promoting properties." withFood:@"Yellow Peppers"]];
    [array addObject:[Tips tipWithColor:@"Orange/Yellow" withHeadline:@"Change it up a bit" withMessage:@"Yellow Tomato, a pulpy nutritious fruit is commonly eaten as a vegetable." withFood:@"Yellow Tomatoes"]];
    [array addObject:[Tips tipWithColor:@"Orange/Yellow" withHeadline:@"Yellow Watermelon? How's that sound?" withMessage:@"Rich in electrolytes and water content, Yellow Watermelons are nature’s gift to beat tropical summer thirst." withFood:@"Yellow Watermelon"]];
    [array addObject:[Tips tipWithColor:@"Red" withHeadline:@"Nothing beats a beet" withMessage:@"Raw beets are an excellent source of folates." withFood:@"Beets"]];
    [array addObject:[Tips tipWithColor:@"Red" withHeadline:@"Vampires wouldn't like your color wheel. Where's the red?" withMessage:@"The potassium levels in Blood Oranges can help control heart rate and blood pressure through countering sodium actions." withFood:@"Blood Oranges"]];
    [array addObject:[Tips tipWithColor:@"Red" withHeadline:@"Time for some red, eh?" withMessage:@"Scientific studies have shown that anthocyanins in the Cherries are found to act like anti-inflammatory agents by blocking the actions of cyclooxygenase-1, and 2 enzymes." withFood:@"Cherries"]];
    [array addObject:[Tips tipWithColor:@"Red" withHeadline:@"Add some red foods in there" withMessage:@"Scientific studies have shown that consumption of Cranberries have potential health benefits against cancer, aging and neurological diseases, inflammation, diabetes, and bacterial infections." withFood:@"Cranberries"]];
    [array addObject:[Tips tipWithColor:@"Red" withHeadline:@"Go on, eat some reds" withMessage:@"Try some Guava, and eat it raw with the skin." withFood:@"Guava"]];
    [array addObject:[Tips tipWithColor:@"Red" withHeadline:@"You're missing red foods" withMessage:@"Papaya is one of the favorites of fruit lovers for its nutritional, digestive, and medicinal properties." withFood:@"Papaya"]];
    [array addObject:[Tips tipWithColor:@"Red" withHeadline:@"Add some variety with red foods" withMessage:@"Well known for its health benefits, Pomegranates can be difficult to extract and eat. Try cutting it in half and beating the outer shell with a wooden spoon over a bowl." withFood:@"Pomegranates"]];
    
    [array addObject:[Tips tipWithColor:@"Red" withHeadline:@"Have you eaten any red foods lately?" withMessage:@"Radicchios are leafy, cabbage-like vegetables that contain lactucopicrin which is a potent anti-malarial agent and has a sedative and analgesic (painkiller) effect." withFood:@"Radicchio"]];
    
    [array addObject:[Tips tipWithColor:@"Red" withHeadline:@"Your color wheel would benefit from some red" withMessage:@"The Chinese believe that eating radishes will bring wholesome health." withFood:@"Radishes"]];
    [array addObject:[Tips tipWithColor:@"Red" withHeadline:@"More berries please!" withMessage:@"Raspberry has an ORAC value (oxygen radical absorbance capacity) of about 4900 per 100 grams, crediting it among the top-ranked ORAC fruits." withFood:@"Raspberries"]];
    [array addObject:[Tips tipWithColor:@"Red" withHeadline:@"Red can add some wonderful color in there" withMessage:@"Red Bell Peppers contain an impressive list of plant nutrients that are known to have disease preventing and health promoting properties." withFood:@"Red Bell Peppers"]];
    [array addObject:[Tips tipWithColor:@"Red" withHeadline:@"Up those red colors!" withMessage:@"Red Chili Peppers contain capsaicin which may be applied in cream form for the temporary relief of minor aches and pains of muscles and joints associated with arthritis, backache, strains and sprains." withFood:@"Red Chili Peppers"]];
    [array addObject:[Tips tipWithColor:@"Red" withHeadline:@"Add some reds to your plate" withMessage:@"Anthocyanins are another class of polyphenolic anti-oxidants present abundantly in the red grapes." withFood:@"Red Grapes"]];
    [array addObject:[Tips tipWithColor:@"Red" withHeadline:@"A little red can be a great addition" withMessage:@"Red Onions are generally less strongly flavored than white or brown varieties, which makes them ideal for use in raw salads." withFood:@"Red Onions"]];
    [array addObject:[Tips tipWithColor:@"Red" withHeadline:@"Nutritious reds can help" withMessage:@"Rhubarb is a perennial vegetable grown for its attractive succulent rose red color edible leafy stalks." withFood:@"Rhubarb"]];
    [array addObject:[Tips tipWithColor:@"Red" withHeadline:@"Where's the red?" withMessage:@"Studies show that consumption of strawberries may have potential health benefits against cancer, aging, inflammation and neurological diseases." withFood:@"Strawberries"]];
    [array addObject:[Tips tipWithColor:@"Red" withHeadline:@"Everyone's favorite red - try it!" withMessage:@"The antioxidants present in Tomatoes are scientifically found to be protective of cancers, including colon, prostate, breast, endometrial, lung, and pancreatic tumors." withFood:@"Tomatoes"]];
    [array addObject:[Tips tipWithColor:@"Red" withHeadline:@"Get some red in there" withMessage:@"Watermelon is an excellent source of Vitamin-A, which is a powerful natural anti-oxidant." withFood:@"Watermelon"]];
    
    
    return array;
}

@end
