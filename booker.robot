*** Settings ***
Resource    robot/keywords.robot

Suite Setup     Run Keywords    Ping Booking        Create Token
Suite Teardown  Run Keywords    Delete All   Check That All Bookings Are Deleted


*** Test Cases ***
Create A Few Books
    [Tags]  Create_Book
    Create A 5 Books
    Get All Booking IDs

Create Single Book And Update All Body
    [Tags]  Check_Update
    Create A 1 Books
    Get All Booking IDs
    Update Booking All Body

Create Single Book And Update partial Body
    [Tags]  Check_Update
    Create A 1 Books
    Get All Booking IDs
    Update Booking Partial Body

Create Single Book And Get Book With Specyfic Id
    [Tags]  Create_Book
    Create A 1 Books
    Get Booking With Specific Id

Check Search IDs Booking By Date From Checkin To Checkout Date
    [Tags]  Check_Search
    Search IDs Booking By Date From Checkin To Checkout Date

Check Search By Firstname And Lastname
    [Tags]  Check_Search
    Search IDs Booking By Firstname And Lastname

Validate All Bookings
    [Tags]  List_ALl
    List All Bookings With Specific Id
