from modules.insurance_type import InsuranceType


def info_type():
    title = input('Enter title: ')
    description = input('Enter description: ')
    rate = input('Enter rate: ')
    category_id = int(input('Enter category id: '))
    insurance_object_id = int(input('Enter insurance object id: '))

    return title, description, rate, category_id, insurance_object_id


def create_post():
    info = info_type()
    insurance_type = InsuranceType(info[0], info[1], info[2], info[3], info[4])

    return insurance_type
