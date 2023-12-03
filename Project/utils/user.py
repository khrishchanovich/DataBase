from getpass import getpass

from modules.user import User


def registration_client():
    print('**********\n'
          'Registration\n'
          '**********')

    email = input('Enter email: ')
    username = input('Enter username: ')
    password = input('Enter password: ')

    print('**********\n'
          'Add information\n'
          '**********')

    name = input('Enter name: ')
    surname = input('Enter surname: ')

    status = 1

    return email, username, password, name, surname, status


def login_client():
    username = input('Enter username: ')
    password = getpass('Enter password: ')

    return username, password


def create_client(info):
    user = User(info[0], info[1], info[2], info[3], info[4], info[5])

    return user

