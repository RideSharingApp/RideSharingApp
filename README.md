# Casper - is a cheap and most convinient way to reach a destination!

*Casper*

**Casper** is an awesome ride sharing app!

## User Stories

The following **required** functionality is completed:
- [x] Login/Signup functionality [phone number verification] [Karly]
- [x] Find drives [Jiayi]
- [ ] Settings [Tarang]
- [ ] lougout [Tarang]
- [x] Integrate Parse [Karly]
- [ ] Facebook login [Karly]
- [x] Detailed ride view controller [Akshat]
- [x] Upload rides to Parse [Akshat]
- [x] Login/Signup UI [Akshat] 
- [ ] Custom Search bar [Tarang]
- [x] SlideOut Menu Controller [Tarang]

The following **optional** features are implemented:
- [ ] messages
- [ ] payment
- [ ] review
- [ ] load cell after posting in drive without calling backend

The following **additional** features are implemented:
- [ ] List anything else that you can get done to improve the app functionality!

**Parse** implementation will require following classes and their attributes:
- [ ] User class:
1. username(String);
2. password(String);
3. phoneNumber(String);
4. phoneNumberVerified(Boolean);
5. firstName(String);
6. lastName(String);
7. profilePicture(File);
8. reviews(Array) - will contain many Review class objects;
9. rating - average of all review ratings(Number);
10. email(String) - optional;

- [ ] Ride class:
1. departurePoint(String);
2. arrivalPoint(String);
3. dateAndTime(Date);
4. price(String);
5. seatsAvailable(String);
5. driver(Pointer<_User>);
6. description(String);
7. availability(Boolean);

- [ ] Review class:
1. reviewer(Pointer<_User>);
2. rating(Number) --> should think about types, it is may be better to store everything as a String;
3. comment(String);

## Video Walkthrough 

Here's a walkthrough of implemented user stories:

<img src='http://i.imgur.com' title='Video Walkthrough' width='' alt='Video Walkthrough' />

GIF created with [LiceCap](http://www.cockos.com/licecap/).

## Notes

Describe any challenges encountered while building the app.

## License

    Copyright [2016] [The team]

    Licensed under the Apache License, Version 2.0 (the "License");
    you may not use this file except in compliance with the License.
    You may obtain a copy of the License at

        http://www.apache.org/licenses/LICENSE-2.0

    Unless required by applicable law or agreed to in writing, software
    distributed under the License is distributed on an "AS IS" BASIS,
    WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
    See the License for the specific language governing permissions and
    limitations under the License.
