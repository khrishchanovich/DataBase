class InsuranceAgent:
    def __init__(self, user_id, post_id, insurance_office_id):
        self._user_id = user_id
        self._post_id = post_id
        self._insurance_office_id = insurance_office_id

    def get_post_id(self):
        return self._post_id

    def set_post_id(self, post_id):
        self._post_id = post_id

    def get_insurance_office_id(self):
        return self._insurance_office_id

    def set_insurance_office_id(self, insurance_office_id):
        self._insurance_office_id = insurance_office_id

    def get_user_id(self):
        return self._user_id

    def set_user_id(self, user_id):
        self._user_id = user_id

