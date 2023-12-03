from modules.insurance_office import InsuranceOffice


def info_office():
    name = input('Enter name: ')
    address = input('Enter address: ')
    phone_number = input('Enter phone number: ')

    return name, address, phone_number


def create_office():
    info = info_office()
    office = InsuranceOffice(info[0], info[1], info[2])

    return office
