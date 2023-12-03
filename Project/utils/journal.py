from modules.journal import Journal


def info_journal():
    client_id = input('Enter client id: ')
    type_id = input('Enter type id: ')
    object_id = input('Enter object id: ')
    payment = input('Enter initial payment: ')
    description = input('Enter description: ')

    return client_id, type_id, object_id, payment, description


def create_journal_entry():
    info = info_journal()
    journal = Journal(info[0], info[1], info[2], info[3], info[4])

    return journal


def update_journal_entry():
    agent_id = input('Enter agent id: ')
