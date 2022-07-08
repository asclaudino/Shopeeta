from .models import User
from .database import UserDatabase
from django.utils.crypto import get_random_string
from rest_framework.views import APIView
from rest_framework.decorators import api_view
from rest_framework.response import Response
from datetime import datetime
import json
import hashlib
# Create your views here.


@api_view(['POST'])
def verify_username(request):
    if request.method == 'POST':
        s = request.body.decode('utf-8')
        json_acceptable_string = s.replace("'", "\"")
        body = json.loads(json_acceptable_string)
        username = body.get('username')
        repeated_username = UserDatabase.fetch_users_by_username(username)
        if repeated_username:
            return Response({'status': 'fail'})
        else:
            return Response({'status': 'success'})
    else:
        return Response({'status': 'fail'})


@api_view(['POST'])
def verify_email(request):
    if request.method == 'POST':
        s = request.body.decode('utf-8')
        json_acceptable_string = s.replace("'", "\"")
        body = json.loads(json_acceptable_string)
        email = body.get('email')
        repeated_email = UserDatabase.fetch_users_by_email(email)
        if repeated_email:
            return Response({'status': 'fail'})
        else:
            return Response({'status': 'success'})
    else:
        return Response({'status': 'fail'})


def check_user_validity(username, password):
    password_hash = hashlib.sha256(password.encode('utf-8')).hexdigest()
    user = UserDatabase.fetch_user_by_username_and_password_hash(username, password_hash)
    if user:
        return True
    else:
        return False


def check_user_validity_by_token(token):
    user = UserDatabase.fetch_user_by_token(token)
    if user:
        return True
    return False


class UserView(APIView):
    """
    Manages user base.
    """

    def get(self, request):
        """
        List all users registered in the system.
        """
        users = User.objects.all()
        response = dict()
        response['quantity'] = len(users)
        userList = []
        for user in users:
            userdict = dict()
            userdict = user.to_json_dict()
            userList.append(userdict)

        response['users'] = userList
        response['status'] = 'success'
        return Response(response)

    def post(self, request):
        """
        Register a new user.
        """
        s = request.body.decode('utf-8')
        json_acceptable_string = s.replace("'", "\"")
        body = json.loads(json_acceptable_string)
        username = body.get('username')
        password = body.get('password')
        email = body.get('email')

        if username is None or password is None or email is None:
            response = dict()
            response['status'] = 'fail'
            response['message'] = 'Dados insuficientes'
            return Response(response)

        repeated_email = UserDatabase.fetch_users_by_email(email)
        if repeated_email:
            response = dict()
            response['status'] = 'fail'
            response['message'] = 'Este e-mail já está cadastrado'
            return Response(response)
        repeated_username = UserDatabase.fetch_users_by_username(username)
        if repeated_username:
            response = dict()
            response['status'] = 'fail'
            response['message'] = 'Este nome de usuário já está em uso!'
            return Response(response)

        password_hash = hashlib.sha256(password.encode('utf-8')).hexdigest()
        user = UserDatabase.create_user(username, password_hash, email)
        response = user.to_json_dict()
        response['status'] = 'success'
        return Response(response)

    def put(self, request):
        """
        Login the user and generate a token.
        """
        s = request.body.decode('utf-8')
        json_acceptable_string = s.replace("'", "\"")
        body = json.loads(json_acceptable_string)
        username = body.get('username')
        password = body.get('password')
        if username is None or password is None:
            response = dict()
            response['status'] = 'fail'
            response['message'] = 'Dados insuficientes'
            return Response(response)

        if check_user_validity(username, password):
            password_hash = hashlib.sha256(password.encode('utf-8')).hexdigest()
            user = UserDatabase.update_user_token(username, password_hash)
            response = user.to_json_dict()
            response['status'] = 'success'
            response['token'] = user.token
            return Response(response)
        else:
            response = dict()
            response['status'] = 'fail'
            response['message'] = 'Usuário inválido'
            return Response(response)

    def delete(self, request):
        """
        Delete a user.
        """
        s = request.body.decode('utf-8')
        json_acceptable_string = s.replace("'", "\"")
        body = json.loads(json_acceptable_string)
        username = body.get('username')
        password = body.get('password')
        if username is None or password is None:
            response = dict()
            response['status'] = 'fail'
            response['message'] = 'Dados insuficientes'
            return Response(response)

        if check_user_validity(username, password):
            password_hash = hashlib.sha256(password.encode('utf-8')).hexdigest()
            UserDatabase.delete_user(username, password_hash)
            response = dict()
            response['status'] = 'success'
            return Response(response)
        else:
            response = dict()
            response['status'] = 'fail'
            response['message'] = 'Dados inválidos'
            return Response(response)
