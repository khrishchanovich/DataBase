from constants.user import CLIENT, ADMIN, AGENT


class User:
    def __init__(self, email, username, password, name, surname, status):
        self._email = email
        self._username = username
        self._password = password

        self._name = name
        self._surname = surname

        self._status: str

        self.set_status(status)

    def get_email(self):
        return self._email

    def set_email(self, email):
        self._email = email

    def get_username(self):
        return self._username

    def set_username(self, username):
        self._username = username

    def get_password(self):
        return self._password

    def set_password(self, password):
        self._password = password

    def get_name(self):
        return self._name

    def set_name(self, name):
        self._name = name

    def get_surname(self):
        return self._surname

    def set_surname(self, surname):
        self._surname = surname

    def get_status(self):
        return self._status

    def set_status(self, status):
        if status == 1:
            self._status = CLIENT
        elif status == 2:
            self._status = AGENT
        elif status == 3:
            self._status = ADMIN
