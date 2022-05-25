from django.http import JsonResponse
from .models import User
from django.views.decorators.csrf import csrf_exempt
from django.utils.crypto import get_random_string
import json
import hashlib
# Create your views here.


@csrf_exempt
def register_user(request):
    if request.method == 'POST':
        s = request.body.decode('utf-8')
        json_acceptable_string = s.replace("'", "\"")
        body = json.loads(json_acceptable_string)
        username = body.get('username')
        password = body.get('password')
        email = body.get('email')
        repeated_email = User.objects.filter(email=email)
        if repeated_email:
            return JsonResponse({'status': 'fail', 'message': 'Este e-mail já está cadastrado'})
        repeated_username = User.objects.filter(username=username)
        if repeated_username:
            return JsonResponse({'status': 'fail', 'message': 'Este nome de usuário já está em uso!'})
        
        password_hash = hashlib.sha256(password.encode('utf-8')).hexdigest()
        user = User(username=username, password_hash=password_hash, email=email)
        user.save()
        return JsonResponse({'status': 'success'})
    else:
        return JsonResponse({'status': 'fail'})


@csrf_exempt
def verify_username(request):
    if request.method == 'POST':
        s = request.body.decode('utf-8')
        json_acceptable_string = s.replace("'", "\"")
        body = json.loads(json_acceptable_string)
        username = body.get('username')
        repeated_username = User.objects.filter(username=username)
        if repeated_username:
            return JsonResponse({'status': 'fail'})
        else:
            return JsonResponse({'status': 'success'})
    else:
        return JsonResponse({'status': 'fail'})

@csrf_exempt
def verify_email(request):
    if request.method == 'POST':
        s = request.body.decode('utf-8')
        json_acceptable_string = s.replace("'", "\"")
        body = json.loads(json_acceptable_string)
        email = body.get('email')
        repeated_email = User.objects.filter(email=email)
        if repeated_email:
            return JsonResponse({'status': 'fail'})
        else:
            return JsonResponse({'status': 'success'})
    else:
        return JsonResponse({'status': 'fail'})


@csrf_exempt
def login_user(request):
    if request.method == 'POST':
        s = request.body.decode('utf-8')
        json_acceptable_string = s.replace("'", "\"")
        body = json.loads(json_acceptable_string)
        username = body.get('username')
        password = body.get('password')
        
        if check_user_validity(username, password):
            token = get_random_string(length=32)
            user = User.objects.get(username=username)
            user.token = token
            user.save()
            return JsonResponse({'status': 'success'})
        else:
            return JsonResponse({'status': 'fail'})
    else:
        return JsonResponse({'status': 'fail'})

@csrf_exempt
def verify_session(request):
    if request.method == 'POST':
        s = request.body.decode('utf-8')
        json_acceptable_string = s.replace("'", "\"")
        body = json.loads(json_acceptable_string)
        username = body.get('username')
        password = body.get('password')
        if check_user_validity(username, password):
            return JsonResponse({'status': 'success'})
        else:
            return JsonResponse({'status': 'fail'})
    else:
        return JsonResponse({'status': 'fail'})


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
        return True
    else:
        return False