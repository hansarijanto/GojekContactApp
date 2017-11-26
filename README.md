# GojekContactApp
IOS Contact App made for Gojek IOS Developer application process

Disclaimer/FYI:
  - First time using Realm, much more intuitive than Core Data
  - Listed down improvements that can be made to the code below
  - Can't implement everything I wanted and all test cases due to other interview deadlines
  - Focused test on functionality of infra instead of UI
  - Icons and images were obtained from google image search (all png format)
  - Left out 2 deprecated PureLayout function warnings, which are not used in the project
  - Long but extensive mini project, I enjoyed it alot
  - One unit test "testDownloadContacts" fails when all unit test are run, however runs fine when run individually
  
Assumptions:
  - Ordered contact list alphabetically by Name (First is prioritized), but above all favorite contacts of each section are shown first (also alphabetically ordered)

Improvements:
  - Scroll to selected row when editing (most important)
  - Dedicated logging and funneling of all Realm getters and writes
  - UITest on each functionality flow (i.e Changing a phone number, calling a contact, editing an image)
  - Refactoring of ContactsDetailVC to reduce bloated class, can be easily done with extensions to seperate Delegates and group realted functionailies together
  - Add a "Check/Download" contacts to allow user directed download to be feasible (check for content update on server)
  - Update data on server by sending post request on editing contact
  - Re-write sorting algorithm (currently too long) for contact list and show loading ui when contacts are sorted when app first loads, on update it doesn't need to be entire re-sorted (just move the updated contact, less expensive)
