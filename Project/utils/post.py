from modules.post import Post


def info_post():
    title = input('Enter title: ')
    description = input('Enter description: ')

    return title, description


def create_post():
    info = info_post()
    post = Post(info[0], info[1])

    return post

