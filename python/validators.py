from pydantic import BaseModel
from robot.api.deco import keyword
from datetime import date

class Token(BaseModel):
    token: str

class Booking_Date(BaseModel):
    checkin: str
    checkin: date
    checkout: str
    checkout: date

class Booking(BaseModel):

    firstname: str
    lastname: str
    totalprice: int
    depositpaid: bool
    bookingdates: Booking_Date

class Booking_Response(BaseModel):
    bookingid: int
    booking: Booking

class Booking_Search_Name(BaseModel):
    bookingid: int

class Booking_Search_Date(BaseModel):
    bookingid: int

@keyword(name="Validate Search Name")
def validate_search_name(response_search):
    return Booking_Search_Name(**response_search)

@keyword(name="Validate Search Date")
def validate_search_date(response_search):
    return Booking_Search_Date(**response_search)

@keyword(name="Validate Token Response")
def validate_token(token_response):
    return Token(**token_response)

@keyword(name="Validate Booking Body And Response")
def validate_booking_body(booking_body):
    return Booking(**booking_body)

@keyword(name="Validate Booking Created Response")
def validate_booking_created_response(booking_body_response):
    return Booking_Response(**booking_body_response)