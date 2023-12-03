class Post:
    def __init__(self, title, description):
        self._title = title
        self._description = description

    def get_title(self):
        return self._title

    def set_title(self, title):
        self._title = title

    def get_description(self):
        return self._description

    def set_description(self, description):
        self._description = description
