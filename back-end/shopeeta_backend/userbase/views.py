from .models import User
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
        repeated_username = User.objects.filter(username=username)
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
        repeated_email = User.objects.filter(email=email)
        if repeated_email:
            return Response({'status': 'fail'})
        else:
            return Response({'status': 'success'})
    else:
        return Response({'status': 'fail'})


def check_user_validity(username, password):
    password_hash = hashlib.sha256(password.encode('utf-8')).hexdigest()
    user = User.objects.filter(username=username, password_hash=password_hash)
    if user:
        return True
    else:
        return False


def check_user_validity_by_token(token):
    user = User.objects.filter(token=token)
    if user:
        if user.last_time_login + datetime.timedelta(hours=1) > datetime.now():
            return False
        return True
    else:
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
            userdict['id'] = user.id
            userdict['username'] = user.username
            userdict['email'] = user.email
            userdict['is_iniciativa'] = user.is_iniciativa
            userdict['last_time_login'] = user.last_time_login
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

        repeated_email = User.objects.filter(email=email)
        if repeated_email:
            response = dict()
            response['status'] = 'fail'
            response['message'] = 'Este e-mail já está cadastrado'
            return Response(response)
        repeated_username = User.objects.filter(username=username)
        if repeated_username:
            response = dict()
            response['status'] = 'fail'
            response['message'] = 'Este nome de usuário já está em uso!'
            return Response(response)

        password_hash = hashlib.sha256(password.encode('utf-8')).hexdigest()
        user = User(username=username,
                    password_hash=password_hash, email=email)
        user.save()
        response = dict()
        response['status'] = 'success'
        response['id'] = user.id
        response['username'] = user.username
        response['email'] = user.email
        response['is_iniciativa'] = user.is_iniciativa
        response['last_time_login'] = user.last_time_login
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
            response = dict()
            response['status'] = 'success'
            token = get_random_string(length=32)
            user = User.objects.get(username=username)
            user.token = token
            user.last_time_login = datetime.now()
            user.save()
            response['id'] = user.id
            response['username'] = user.username
            response['email'] = user.email
            response['is_iniciativa'] = user.is_iniciativa
            response['token'] = user.token
            return Response(response)
        else:
            response = dict()
            response['status'] = 'fail'
            response['message'] = 'Token inválido'
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
            user = User.objects.get(username=username)
            user.delete()
            response = dict()
            response['status'] = 'success'
            return Response(response)
        else:
            response = dict()
            response['status'] = 'fail'
            response['message'] = 'Dados inválidos'
            return Response(response)
