from .models import Product
import json
from rest_framework.decorators import api_view
from rest_framework.response import Response
from rest_framework.views import APIView
from userbase.models import User
from userbase.views import check_user_validity

# Create your views here.


class ProductView(APIView):
    """
    Manages product base
    """

    def get(self, request):
        """
        Get all products
        """
        products = Product.objects.all()
        products.order_by('-id')
        products_list = []
        for product in products:
            product_dict = {
                'product_id': product.id,
                'name': product.name,
                'description': product.description,
                'price': product.price,
                'seller': product.seller.username
            }
            products_list.append(product_dict)
        response = dict()
        response['status'] = 'success'
        response['products'] = products_list
        return Response(response)

    def post(self, request):
        """
        Add a new product
        """
        s = request.body.decode('utf-8')
        json_acceptable_string = s.replace("'", "\"")
        body = json.loads(json_acceptable_string)
        name = body.get('name')
        description = body.get('description')
        price = body.get('price')
        seller_username = body.get('username')
        password = body.get('password')
        if not check_user_validity(seller_username, password):
            return Response({'status': 'fail'})
        seller = User.objects.get(username=seller_username)
        product = Product(name=name, description=description,
                          price=price, seller=seller)
        product.image = None
        product.save()
        response = dict()
        response['status'] = 'success'
        response['product_id'] = product.id
        response['name'] = product.name
        response['description'] = product.description
        response['price'] = product.price

        return Response(response)

    def delete(self, request):
        """
        Delete a product
        """
        s = request.body.decode('utf-8')
        json_acceptable_string = s.replace("'", "\"")
        body = json.loads(json_acceptable_string)
        id = body.get('product_id')
        username = body.get('username')
        password = body.get('password')
        response = dict()
        if not check_user_validity(username, password):
            response['status'] = 'fail'
            response['message'] = 'Dados inválidos'
            return Response(response)
        product = Product.objects.get(id=id)
        if username != product.seller.username:
            response['status'] = 'fail'
            response['message'] = 'Você não tem permissão para deletar este produto'
            return Response(response)

        product.delete()
        response['status'] = 'success'
        return Response(response)

    def put(self, request):
        """
        Update a product
        """
        s = request.body.decode('utf-8')
        json_acceptable_string = s.replace("'", "\"")
        body = json.loads(json_acceptable_string)
        id = body.get('id')
        name = body.get('name')
        description = body.get('description')
        price = body.get('price')
        seller = body.get('username')
        password = body.get('password')
        response = dict()
        if not check_user_validity(seller, password):
            response['status'] = 'fail'
            response['message'] = 'Dados inválidos'
            return Response(response)
        product = Product.objects.get(id=id)
        product.name = name
        product.description = description
        product.price = price
        product.save()
        response['status'] = 'success'
        response['id'] = product.id
        response['name'] = product.name
        response['description'] = product.description
        response['price'] = product.price
        return Response(response)


class ProductImageView(APIView):
    """
    Manages product images
    """

    def get(self, request, product_id):
        """
        Get product image
        """
        product = Product.objects.get(id=product_id)
        response = dict()

        if not product.image:
            response['status'] = 'success'
            response['image'] = ''
            return Response(response)
        imageUrl = product.image.url
        imageUrl = imageUrl.split('/')[-1]
        imageUrl = 'uploads/product_images/' + imageUrl
        response['status'] = 'success'
        response['image'] = imageUrl
        return Response(response)

    def post(self, request, product_id):
        """
        Posts product image
        """
        image = request.FILES['image']
        product = Product.objects.get(id=product_id)
        product.image = image
        product.save()
        imageUrl = product.image.url
        imageUrl = imageUrl.split('/')[-1]
        imageUrl = 'uploads/product_images/' + imageUrl
        response = dict()
        response['status'] = 'success'
        response['image'] = imageUrl
        return Response(response)


@api_view(['POST'])
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
                'product_id': product.id,
                'name': product.name,
                'description': product.description,
                'price': product.price,
                'seller': product.seller.username
            }
            products_list.append(product_dict)
        return Response({'status': 'success', 'products': products_list})

    return Response({'status': 'fail'})


@api_view(['POST'])
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
                'product_id': product.id,
                'name': product.name,
                'description': product.description,
                'price': product.price,
                'seller': product.seller.username
            }
            print(type(product.id))
            products_list.append(product_dict)
        return Response({'status': 'success', 'products': products_list})

    return Response({'status': 'fail'})
