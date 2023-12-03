class Feedback:
    def __init__(self, rating, feedback, client_id):
        self._rating = rating
        self._feedback = feedback
        self._client_id = client_id

    def get_rating(self):
        return self._rating

    def set_rating(self, rating):
        self._rating = rating

    def get_feedback(self):
        return self._feedback

    def set_feedback(self, feedback):
        self._feedback = feedback

    def get_client_id(self):
        return self._client_id

    def set_client_id(self, client_id):
        self._client_id = client_id

