*** Settings ***
Documentation       Keywords implementation for A simple Node booking form for testing RESTful web services.

Library             ../python/function.py
Library             ../python/validators.py
Variables           ../python/variables.py

*** Keywords ***
Ping Booking
    [Documentation]     Keyword to check server response
    ${res}=    Ping    ${url}
    SHOULD BE EQUAL AS INTEGERS    ${res}    201
    LOG TO CONSOLE    Response = ${res}

Create Token
    [Documentation]     Keyword to create Token
    LOG TO CONSOLE    Credentials For Token= ${credentials}
    ${token}=    Get Token    ${credentials}    ${url}
    LOG TO CONSOLE    ${token}

Create Book
    [Documentation]     Keyword to create one booking
    ${booking_body}=    Booking Body Create
    ${booking}=    Create Booking    ${booking_body}    ${url}
    ${firstname}=    Set Variable    ${booking['booking']['firstname']}
    ${lastname}=    Set Variable    ${booking['booking']['lastname']}
    ${checkin}=    Set Variable    ${booking['booking']['bookingdates']['checkin']}
    ${checkout}=    Set Variable    ${booking['booking']['bookingdates']['checkout']}
    Validate Booking Body And Response    ${booking_body}
    Validate Booking Created Response    ${booking}
    SHOULD BE TRUE    '${checkin}'<'${checkout}'
    LOG TO CONSOLE    Created Booking ID = ${booking['bookingid']}
    RETURN    ${firstname}    ${lastname}    ${checkin}    ${checkout}

Create A ${few} Books
    [Documentation]     Keyword to create multiple books
    FOR    ${i}    IN RANGE    1    ${few}+1
        Create Book
    END

Get Booking With Specific Id
    [Documentation]     Keyword to get booking with specific Id from server
    @{list_of_ids}=    Get All Booking IDs
    ${id}=    SET VARIABLE    ${list_of_ids[0]}
    ${booking_body_response}=    Get Booking With Id    ${id}    ${url}
    LOG TO CONSOLE    Booking for ID ${id}= ${booking_body_response}
    Validate Booking Body And Response    ${booking_body_response}

Get All Bookings With Specific Id ${id}
    [Documentation]     Keyword to get all bookings with specific Id from server
    ${booking_body_response}=    Get Booking With Id    ${id}    ${url}
    LOG TO CONSOLE    Booking for ID ${id}= ${booking_body_response}
    Validate Booking Body And Response    ${booking_body_response}

List All Bookings With Specific Id
    [Documentation]     Keyword to list all bookings with specific Id from server
    @{list_of_ids}=    Get All Booking IDs
    FOR    ${i}    IN    @{list_of_ids}
        RUN KEYWORD AND CONTINUE ON FAILURE    Get All Bookings With Specific Id ${i}
    END

Get All Booking IDs
    [Documentation]     Keyword to get all bookings from server
    ${booking_body_response}=    Get All Bookings ID    ${url}
    ${numbers_of_booking}=    SET VARIABLE    ${booking_body_response[1]}
    @{list_of_ids}=    SET VARIABLE    ${booking_body_response[2]}
    LOG    Body response= ${booking_body_response}
    RETURN    @{list_of_ids}

Check That All Bookings Are Deleted
    [Documentation]     Keyword to check that all bookings are deleted
    @{list_of_ids}=    Get All Booking IDs
    SHOULD NOT BE TRUE    ${list_of_ids}

Delete Booking With ID: ${id}
    [Documentation]     Keyword to delete booking with given Id
    ${response}=    Delete Booking    ${id}    ${url}    ${credentials}
    SHOULD BE EQUAL AS INTEGERS    ${response}    201

Delete All
    [Documentation]     Keyword to delete all bookings
    @{list}=    Get All Booking IDs
    FOR    ${i}    IN    @{list}
        RUN KEYWORD AND CONTINUE ON FAILURE    Delete Booking With ID: ${i}
    END

Update Booking All Body
    [Documentation]     Keyword to update all booking body
    ${booking_body}=    Booking Body Create
    @{list_of_ids}=    Get All Booking IDs
    ${id}=    SET VARIABLE    ${list_of_ids[0]}
    ${booking_updated}=    Update Booking    ${id}    ${booking_body}    ${url}    ${credentials}
    Validate Booking Body And Response    ${booking_body}
    Validate Booking Body And Response    ${booking_updated}
    SHOULD BE EQUAL    ${booking_updated}    ${booking_body}
    LOG TO CONSOLE    Updated Booking ID= ${id}
    LOG    ${booking_updated}

Update Booking Partial Body
    [Documentation]     Keyword to update partial booking body
    @{list_of_ids}=    Get All Booking IDs
    ${id}=    SET VARIABLE    ${list_of_ids[0]}
    ${booking_body_to_update}=    Booking Body Create To Update
    LOG TO CONSOLE    Updated Booking ID= ${id}
    ${booking_updated_partial}=    Update Booking Partial
    ...    ${id}
    ...    ${booking_body_to_update}
    ...    ${url}
    ...    ${credentials}
    Validate Booking Body And Response    ${booking_updated_partial}
    SHOULD BE EQUAL    ${booking_updated_partial['firstname']}    ${booking_body_to_update['firstname']}
    SHOULD BE EQUAL    ${booking_updated_partial['lastname']}    ${booking_body_to_update['lastname']}
    LOG    ${booking_updated_partial}

Search IDs Booking By Firstname And Lastname
    [Documentation]     Keyword to search booking Id by firstname and lastname
    ${firstname}    ${lastname}    ${checkin}    ${checkout}=    Create Book
    ${response_search}=    Search ID By Name    ${firstname}    ${lastname}    ${url}
    LOG TO CONSOLE    Search :${firstname} ${lastname}
    LOG TO CONSOLE    List of finded bookings: ${response_search}
    Validate Search Name    ${response_search[0]}

Search IDs Booking By Date From Checkin To Checkout Date
    [Documentation]     Keyword to search booking Id by date from checkin to check out date
    ${firstname}    ${lastname}    ${checkin}    ${checkout}=    Create Book
    ${response_search}=    Search ID By Date    ${checkin}    ${checkout}    ${url}
    ${search_len}=    Get Length    ${response_search}
    LOG TO CONSOLE    Search from: ${checkin} to: ${checkout}
    LOG TO CONSOLE    List of finded bookings: ${response_search}
    FOR    ${item}    IN    @{response_search}
        Validate Search Date    ${item}
    END
