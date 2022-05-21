*** Settings ***
Documentation   Keywords implementation for A simple Node booking form for testing RESTful web services.

Library     python/function.py
Library     python/validators.py
Variables    python/variables.py

*** Keywords ***

Ping Booking
    ${res}=     Ping    ${url}
    SHOULD BE EQUAL AS INTEGERS    ${res}   201
    log to console   Response = ${res}

Create Token
    log to console      Credentials For Token= ${credentials}
    ${token}=           Get Token      ${credentials}   ${url}
    LOG TO CONSOLE      ${token}

Create Book
    ${booking_body}=    Booking Body Create
    ${booking}=    Create Booking    ${booking_body}    ${url}
    ${firstname}=   Set Variable  ${booking['booking']['firstname']}
    ${lastname}=    Set Variable   ${booking['booking']['lastname']}
    ${checkin}=   Set Variable  ${booking['booking']['bookingdates']['checkin']}
    ${checkout}=    Set Variable   ${booking['booking']['bookingdates']['checkout']}
    Validate Booking Body And Response    ${booking_body}
    Validate Booking Created Response    ${booking}
    Should be true    '${checkin}'<'${checkout}'
    LOG TO CONSOLE    Created Booking ID = ${booking['bookingid']}

    [Return]    ${firstname}    ${lastname}    ${checkin}    ${checkout}


Create A ${few} Books
    FOR    ${i}    IN RANGE    1     ${few}+1
        Create Book
    END


Get Booking With Specific Id
    @{list_of_ids}=     Get All Booking IDs
    ${id}=   SET VARIABLE    ${list_of_ids[0]}
    ${booking_body_response}=     Get Booking With Id     ${id}     ${url}
    LOG TO CONSOLE  Booking for ID ${id}= ${booking_body_response}
    Validate Booking Body And Response     ${booking_body_response}


Get All Bookings With Specific Id ${id}
    ${booking_body_response}=     Get Booking With Id     ${id}     ${url}
    LOG TO CONSOLE  Booking for ID ${id}= ${booking_body_response}
    Validate Booking Body And Response     ${booking_body_response}


List All Bookings With Specific Id
    @{list_of_ids}=  Get All Booking IDs
    FOR    ${i}   IN    @{list_of_ids}
        run keyword and continue on failure     Get All Bookings With Specific Id ${i}
    END


Get All Booking IDs
    ${booking_body_response}=   Get All Bookings ID    ${url}
    ${numbers_of_booking}=   SET VARIABLE    ${booking_body_response[1]}
    @{list_of_ids}=     SET VARIABLE    ${booking_body_response[2]}
    LOG      Body response= ${booking_body_response}
    [Return]    @{list_of_ids}


Check That All Bookings Are Deleted
    @{list_of_ids}=  Get All Booking IDs
    should not be true      ${list_of_ids}


Delete Booking With ID: ${id}
    ${response}=     Delete Booking     ${id}   ${url}   ${credentials}
    SHOULD BE EQUAL AS INTEGERS    ${response}      201


Delete All
    @{list}=    Get All Booking IDs
    FOR    ${i}   IN    @{list}
        run keyword and continue on failure     Delete Booking With ID: ${i}
    END


Update Booking All Body
    ${booking_body}=    Booking Body Create
    @{list_of_ids}=     Get All Booking IDs
    ${id}=   SET VARIABLE    ${list_of_ids[0]}
    ${booking_updated}=    Update Booking    ${id}    ${booking_body}    ${url}    ${credentials}
    Validate Booking Body And Response      ${booking_body}
    Validate Booking Body And Response      ${booking_updated}
    SHOULD BE EQUAL    ${booking_updated}   ${booking_body}
    log to console  Updated Booking ID= ${id}
    log     ${booking_updated}


Update Booking Partial Body
    @{list_of_ids}=     Get All Booking IDs
    ${id}=   SET VARIABLE    ${list_of_ids[0]}
    ${booking_body_to_update}=  Booking Body Create To Update
    log to console  Updated Booking ID= ${id}
    ${booking_updated_partial}=    Update Booking Partial    ${id}    ${booking_body_to_update}    ${url}    ${credentials}
    Validate Booking Body And Response    ${booking_updated_partial}
    SHOULD BE EQUAL    ${booking_updated_partial['firstname']}   ${booking_body_to_update['firstname']}
    SHOULD BE EQUAL    ${booking_updated_partial['lastname']}    ${booking_body_to_update['lastname']}
    LOG    ${booking_updated_partial}


Search IDs Booking By Firstname And Lastname
    ${firstname}     ${lastname}    ${checkin}   ${checkout}=      Create Book
    ${response_search}=     Search ID By Name   ${firstname}   ${lastname}    ${url}
    log to console      Search :${firstname} ${lastname}
    log to console      List of finded bookings: ${response_search}
    Validate Search Name    ${response_search[0]}

Search IDs Booking By Date From Checkin To Checkout Date
    ${firstname}     ${lastname}    ${checkin}   ${checkout}=      Create Book
    ${response_search}=     Search ID By Date   ${checkin}   ${checkout}    ${url}
    ${search_len}=  Get Length     ${response_search}
    log to console  Search from: ${checkin} to: ${checkout}
    log to console  List of finded bookings: ${response_search}
    FOR    ${item}  IN    @{response_search}
    Validate Search Date    ${item}
    END



