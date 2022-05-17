from math import prod
from django.views.decorators.csrf import csrf_exempt
from django.http import JsonResponse
from .models import Product
import json
from userbase.models import User
from userbase.views import check_user_validity

# Create your views here.


@csrf_exempt
def register_product(request):
    if request.method == 'POST':
        s = request.body.decode('utf-8')
        json_acceptable_string = s.replace("'", "\"")
        body = json.loads(json_acceptable_string)
        name = body.get('name')
        description = body.get('description')
        price = body.get('price')
        seller_username = body.get('username')
        password = body.get('password')
        if not check_user_validity(seller_username, password):
            return JsonResponse({'status': 'fail', 'message': 'Usuário ou senha inválidos!'})

        seller = User.objects.get(username=seller_username)
        product = Product(name=name, description=description,
                          price=price, seller=seller)
        product.save()
        return JsonResponse({'status': 'success'})

    return JsonResponse({'status': 'fail'})


@csrf_exempt
def update_product(request):
    if request.method == 'POST':
        s = request.body.decode('utf-8')
        json_acceptable_string = s.replace("'", "\"")
        body = json.loads(json_acceptable_string)
        id = body.get('id')
        name = body.get('name')
        description = body.get('description')
        price = body.get('price')
        seller = body.get('username')
        password = body.get('password')
        if not check_user_validity(seller, password):
            return JsonResponse({'status': 'fail', 'message': 'Usuário ou senha inválidos!'})
        product = Product.objects.get(id=id)
        product.name = name
        product.description = description
        product.price = price
        product.seller = seller
        product.save()
        return JsonResponse({'status': 'success'})

    return JsonResponse({'status': 'fail'})


@csrf_exempt
def delete_product(request):
    if request.method == 'POST':
        s = request.body.decode('utf-8')
        json_acceptable_string = s.replace("'", "\"")
        body = json.loads(json_acceptable_string)
        id = body.get('product_id')
        username = body.get('username')
        password = body.get('password')
        if not check_user_validity(username, password):
            return JsonResponse({'status': 'fail', 'message': 'Usuário ou senha inválidos!'})
        product = Product.objects.get(id=id)
        product.delete()
        return JsonResponse({'status': 'success'})

    return JsonResponse({'status': 'fail'})


@csrf_exempt
def get_latest_products(request):
    if request.method == 'GET':
        products = Product.objects.all()
        products.order_by('-id')
        products_list = []
        for product in products:
            product_dict = {
                'id': product.id,
                'name': product.name,
                'description': product.description,
                'price': product.price,
                'seller': product.seller.username
            }
            products_list.append(product_dict)
        return JsonResponse({'status': 'success', 'products': products_list})

    return JsonResponse({'status': 'fail'})


@csrf_exempt
def search_products_by_name(request):
    if request.method == 'POST':
        s = request.body.decode('utf-8')
        json_acceptable_string = s.replace("'", "\"")
        body = json.loads(json_acceptable_string)
        name = body.get('name')

        products = Product.objects.filter(name__contains=name)
        products_list = []
        for product in products:
            product_dict = {
                'id': product.id,
                'name': product.name,
                'description': product.description,
                'price': product.price,
                'seller': product.seller.username
            }
            products_list.append(product_dict)
        return JsonResponse({'status': 'success', 'products': products_list})

    return JsonResponse({'status': 'fail'})


@csrf_exempt
def search_products_by_seller(request):
    if request.method == 'POST':
        s = request.body.decode('utf-8')
        json_acceptable_string = s.replace("'", "\"")
        body = json.loads(json_acceptable_string)
        seller = body.get('seller')

        products = Product.objects.filter(seller__username=seller)
        products_list = []
        for product in products:
            product_dict = {
                'id': product.id,
                'name': product.name,
                'description': product.description,
                'price': product.price,
                'seller': product.seller.username
            }
            print(type(product.id))
            products_list.append(product_dict)
        return JsonResponse({'status': 'success', 'products': products_list})

    return JsonResponse({'status': 'fail'})