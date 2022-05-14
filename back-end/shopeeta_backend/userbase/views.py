from django.http import JsonResponse
from .models import User
from django.views.decorators.csrf import csrf_exempt
import json
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
            return JsonResponse({'was successful': False, 'message': 'Este e-mail já está cadastrado'})
        repeated_username = User.objects.filter(username=username)
        if repeated_username:
            return JsonResponse({'was successful': False, 'message': 'Este nome de usuário já está em uso!'})

        user = User(username=username, password=password, email=email)
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
def login_user(request):
    if request.method == 'POST':
        s = request.body.decode('utf-8')
        json_acceptable_string = s.replace("'", "\"")
        body = json.loads(json_acceptable_string)
        username = body.get('username')
        password = body.get('password')
        user = User.objects.filter(username=username, password=password)
        if user:
            return JsonResponse({'status': 'success'})
        else:
            return JsonResponse({'status': 'fail'})
    else:
        return JsonResponse({'status': 'fail'})
