from modules.category import Category


def info_category():
    title = input('Enter title: ')
    description = input('Enter description: ')

    return title, description


def create_category():
    info = info_category()
    category = Category(info[0], info[1])

    return category

