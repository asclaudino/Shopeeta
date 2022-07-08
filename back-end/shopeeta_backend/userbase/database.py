from userbase.models import User
from datetime import datetime
from django.utils.crypto import get_random_string


class UserDatabase:
    @staticmethod
    def fetch_user_by_username(username):
        user = User.objects.get(username=username)
        return user
    
    @staticmethod
    def fetch_users_by_username(username):
        users = User.objects.filter(username=username)
        return users

    @staticmethod
    def fetch_user_by_id(user_id):
        user = User.objects.get(id=user_id)
        return user

    @staticmethod
    def fetch_user_by_email(email):
        user = User.objects.get(email=email)
        return user
    
    @staticmethod
    def fetch_users_by_email(email):
        users = User.objects.filter(email=email)
        return users

    @staticmethod
    def fetch_user_by_token(token):
        user = User.objects.get(token=token)
        # TODO: check if token is expired
        if user:
            if user.last_time_login + datetime.timedelta(hours=1) > datetime.now():
                return False
            return user
        return None

    @staticmethod
    def fetch_user_by_username_and_password_hash(username, password_hash):
        return User.objects.get(username=username, password_hash=password_hash)

    @staticmethod
    def fetch_all_users():
        return User.objects.all()

    @staticmethod
    def create_user(username, password_hash, email):
        user = User(username=username, password_hash=password_hash, email=email)
        user.save()
        return user

    @staticmethod
    def update_user_token(username, password_hash):
        user = User.objects.get(username=username, password_hash=password_hash)
        token = get_random_string(length=32)
        user.token = token
        user.last_time_login = datetime.now()
        user.save()
        return user

    @staticmethod
    def delete_user(username, password_hash):
        user = User.objects.get(username=username, password_hash=password_hash)
        user.delete()
        return True