class Journal:
    def __init__(self, client_id, type_id, object_id, payment, description):
        self._agent_id = None
        self._client_id = client_id
        self._type_id = type_id
        self._object_id = object_id
        self._payment = payment
        self._description = description
        self._approved = False

    def get_agent_id(self):
        return self._agent_id

    def set_(self, agent_id):
        self._agent_id = agent_id

    def get_client_id(self):
        return self._client_id

    def set_client_id(self, client_id):
        self._client_id = client_id

    def get_(self):
        return self._type_id

    def set_type_id(self, type_id):
        self._type_id = type_id

    def get_object_id(self):
        return self._object_id

    def set_object_id(self, object_id):
        self._object_id = object_id

    def get_payment(self):
        return self._payment

    def set_payment(self, payment):
        self._payment = payment

    def get_description(self):
        return self._description

    def set_description(self, description):
        self._description = description

    def get_approved(self):
        return self._approved

    def set_approved(self, approved):
        self._approved = approved

