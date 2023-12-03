from getpass import getpass
from mysql.connector import connect, Error


def conect_to_db():
    try:
        connection = connect(
            host="localhost",
            user="root",
            password="Nastya091103",
            database="insurancecompany"
        )

        return connection
    except Error as error:
        print(error)
