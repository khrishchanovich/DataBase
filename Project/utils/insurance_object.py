from modules.insurance_object import InsuranceObject


def info_object():
    title = input('Enter title: ')
    description = input('Enter description: ')

    return title, description


def create_object():
    info = info_object()
    insurance_object = InsuranceObject(info[0], info[1])

    return insurance_object
