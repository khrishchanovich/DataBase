from modules.insurance_agent import  InsuranceAgent


def info_agent():
    user_id = input('Enter user id: ')
    post_id = input('Enter post id: ')
    office_id = input('Enter office id: ')

    return user_id, post_id, office_id


def update_agent():
    info = info_agent()
    agent = InsuranceAgent(info[0], info[1], info[2])

    return agent
