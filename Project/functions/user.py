from utils.user import registration_client, login_client, create_client


def register_user(connection):



    user = create_client()

    try:
        with connection.cursor() as cursor:
            cursor.execute('CALL create_user(%s, %s, %s, %s, %s, %s)', (user.get_email(),
                                                                        user.get_username(),
                                                                        user.get_password(),
                                                                        user.get_name(),
                                                                        user.get_surname(),
                                                                        user.get_status()))
            user_id = cursor.lastrowid
            connection.commit()

            print(f'Registration successful! Your user ID is {user_id}')

            return user_id
    except Exception as exception:
        print(f'Error: Unable to register user\n{exception}')


def login_user(connection):


