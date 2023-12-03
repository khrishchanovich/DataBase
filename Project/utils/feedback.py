from modules.feedback import Feedback


def info_feedback():
    rating = int(input('Enter rating: '))
    feedback = input('Enter feedback: ')
    client_id = int(input('Enter client id: '))

    return rating, feedback, client_id


def create_feedback():
    info = info_feedback()
    feedback = Feedback(info[0], info[1], info[2])

    return feedback

