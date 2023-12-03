class InsuranceType:
    def __init__(self, title, description, rate, category_id, insurance_object_id):
        self._title = title
        self._description = description
        self._rate = rate
        self._category_id = category_id
        self._insurance_object_id = insurance_object_id

    def get_title(self):
        return self._title

    def set_title(self, title):
        self._title = title

    def get_description(self):
        return self._description

    def set_description(self, description):
        self._description = description

    def get_rate(self):
        return self._rate

    def set_rate(self, rate):
        self._rate = rate

    def get_category(self):
        return self._category_id

    def set_category(self, category_id):
        self._category_id = category_id

    def get_object(self):
        return self._insurance_object_id

    def set_object(self, insurance_object_id):
        self._insurance_object_id = insurance_object_id


