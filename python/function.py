import requests
from robot.api.deco import keyword
from faker import Faker
import random


@keyword(name="Booking Body Create")
def booking_body_create():
    """Booking Body Create

            :returns:
                    booking_body:  Return body in json format from API
    """
    fake = Faker("pl_PL")
    booking_body = {
        "firstname": f'{fake.first_name()}',
        "lastname": f'{fake.last_name()}',
        "totalprice": random.randint(0,1000),
        "depositpaid": True,
        "bookingdates": {
        "checkin": f'{fake.date_between(start_date = "-3y", end_date = "-2y")}',
        "checkout": f'{fake.date_between(start_date = "-1y", end_date = "now")}'}
        }
    return booking_body


@keyword(name="Booking Body Create To Update")
def booking_body_create_to_update():
    """Booking Body Create To Update

        :returns:
                booking_body:  Return partial body in json format from API
    """
    fake = Faker("pl_PL")
    booking_body = {
        "firstname": f'{fake.first_name()}',
        "lastname": f'{fake.last_name()}'
    }
    return booking_body


@keyword(name="Get All Bookings ID")
def get_list_of_booking_ids(url):
    """Get All Bookings ID

    :param url: Address of API server
    :returns:
            req:  A list response from the app
            id_len:  A list response length
            list_ids:  A list of ID's
    """
    req = requests.get(f'{url}/booking/')
    req = req.json()
    list_ids = []
    id_len = len(req)
    for i in range(0, id_len):
        list_ids.append(req[i]['bookingid'])
    list_ids.sort()
    id_len = len(list_ids)
    return req, id_len, list_ids


@keyword(name="Search ID By Name")
def get_list_of_booking_ids_sort_by_name(firstname, lastname, url):
    """Search ID By Name

    :param url: Address of API server
    :param firstname: Search firstname
    :param lastname: Search lastname
    :returns:
            req:  A list response with ID's from the app
    """
    www = f'{url}/booking?firstname={firstname}&lastname={lastname}'
    req = (requests.get(www)).json()
    return req


@keyword(name="Search ID By Date")
def get_list_of_booking_ids_sort_by_check_date(checkin, checkout, url):
    """Search ID By Date

    :param url: Address of API server
    :param checkin: Search checkin date
    :param checkout: Search checkout date
    :returns:
            req:  A list response with ID's from the app
    """
    www = f'{url}/booking?checkin={checkin}&checkout={checkout}'
    req = (requests.get(www)).json()
    return req


@keyword(name="Get Token")
def get_token(credentials, url):
    """Get Token

    :param url: Address of API server
    :param credentials: User username and password
    :returns:
            pos:  A string with token key
    """
    pos = requests.post(f'{url}/auth/', json=credentials)
    return pos.json()


@keyword(name="Get Booking With Id")
def get_booking_id(id, url):
    """Get Booking With Id

    :param url: Address of API server
    :param id: Book Id
    :returns:
            req:  A response from the app
    """
    req = requests.get(f'{url}/booking/{id}')
    return req.json()


@keyword(name="Create Booking")
def create_booking(booking_body, url):
    """Create Booking

    :param url: Address of API server
    :param booking_body: All the data to create book
    :returns:
            pos:  A response from the app
    """
    pos = requests.post(f'{url}/booking/', json=booking_body)
    return pos.json()


@keyword(name="Update Booking")
def update_booking(id, booking_body, url, credentials):
    """Update Booking

    :param url: Address of API server
    :param id: Book Id
    :param booking_body: All the data to update book
    :param credentials: User username and password
    :returns:
            pos:  A response from the app
    """
    pos = requests.put(f'{url}/booking/{id}', json=booking_body, cookies=get_token(credentials, url))
    return pos.json()


@keyword(name="Update Booking Partial")
def update_booking_partial(id, booking_body2, url, credentials):
    """Update Booking Partial

    :param url: Address of API server
    :param id: Book Id
    :param booking_body2: Part of the data to update book
    :param credentials: User username and password
    :returns:
            pos:  A response from the app
    """
    pos = requests.patch(f'{url}/booking/{id}', json=booking_body2, cookies=get_token(credentials, url))
    return pos.json()


@keyword(name="Delete Booking")
def delete_booking(id, url, credentials):
    """Delete Booking

    :param url: Address of API server
    :param id: Book Id
    :param credentials: User username and password
    :returns:
            del_book.status_code:  A response status code
    """
    del_book = requests.delete(f'{url}/booking/{id}', cookies=get_token(credentials, url))
    return del_book.status_code


@keyword(name="Ping")
def ping_booking(url):
    """Ping API server

    :param url: Address of API server
    :returns:
            ping.status_code:  A response status code
    """
    ping = requests.get(f'{url}/ping')
    return ping.status_code


