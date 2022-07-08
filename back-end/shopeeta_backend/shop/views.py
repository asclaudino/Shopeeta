from urllib import response

from matplotlib.pyplot import text
from numpy import product
from .models import  Comment
from .database import ShopDatabase
import json
from rest_framework.decorators import api_view
from rest_framework.response import Response
from rest_framework.views import APIView
from userbase.models import User
from userbase.views import check_user_validity

# Create your views here.


class CommentView(APIView):
    """
    Manages comments of products
    """
    
    def get(self, request, product_id):
        """
        Gets all comments of products
        """
        comments = Comment.objects.all()
        comments.filter(product__id = product_id)
        comments.order_by('-time')
        comments_list = []
        for comment in comments:
            comment_dict = {
                'comment_id': comment.id,
                'product_id': comment.product.id,
                'text': comment.text,
                'time': comment.time.strftime('%Y-%m-%d %H:%M:%S'),
                'rating': comment.rating,
            }
            comments_list.append(comment_dict)
        response = dict()
        response['status'] = 'success'
        response['coments'] = comments_list
        return Response(response)
        # serializer = CommentSerializer(comments, many=True)
    
    def post(self, request, product_id):
        """
        Add a new product
        """    
        s = request.body.decode('utf-8')
        json_acceptable_string = s.replace("'", "\"")
        body = json.loads(json_acceptable_string)
        text = body.get('text')
        username = body.get('username')
        time = body.get('time')
        rating = body.get('rating')
        password = body.get('password')
        if not check_user_validity(user, password):
            return Response({'status': 'fail'})
        user = User.objects.get(username=username)
        comment = Comment(text=text, time=time, rating=rating, product=product, user=user)
        comment.save()
        response = dict()
        response['status'] = 'success'
        response['comment_id'] = comment.id
        response['text'] = comment.text
        response['time'] = comment.time
        response['product'] = comment.product
        response['rating'] = comment.rating
        return Response(response)
        
    def delete(self, request, product_id):
        """
        Delete a product
        """
        s = request.body.decode('utf-8')
        json_acceptable_string = s.replace("'", "\"")
        body = json.loads(json_acceptable_string)
        id = body.get('id')
        username = body.get('username')
        password = body.get('password')
        response = dict()
        if not check_user_validity(username, password):
            response['status'] = 'fail'
            response['message'] = 'Dados invalidos'
            return Response(response)
        comment = Comment.objects.get(id=id)
        if username != comment.user.username:
            response['status'] = 'fail'
            response['message'] = 'Você não tem permissão para deletar este comentário'
            return Response(response)
        comment.delete()
        response['status'] = 'success'
        return Response(response)
            
    def put(self, request, product_id):
        """
        Update a product
        """
        s = request.body.decode('utf-8')
        json_acceptable_string = s.replace("'", "\"")
        body = json.loads(json_acceptable_string)
        id = body.get('id')
        text = body.get('text')     
        rating = body.get('rating')
        time = body.get('time')
        user = body.get('username')
        password = body.get('password')
        response = dict()
        if not check_user_validity(user, password):
            response['status'] = 'fail'
            response['message'] = 'Você não tem permissão para editar este comentário'
            return Response(response)
        comment = Comment.objects.get(id=id)
        comment.text = text
        comment.rating = rating
        comment.time = time
        comment.save()
        response['status'] = 'success'
        response['id'] = comment.id
        response['text'] = comment.text
        response['time'] = comment.time
        response['rating'] = comment.rating
        return Response(response)
        
class ProductView(APIView):
    """
    Manages product base
    """

    def get(self, request):
        """
        Get all products
        """
        products = ShopDatabase.fetch_all_products()
        products_list = []
        for product in products:
            product_dict = product.to_json_dict()
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
        product = ShopDatabase.create_product(name, description, price, seller_username)
        response = product.to_json_dict()
        response['status'] = 'success'

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
        deleted = ShopDatabase.delete_product(id, username)
        if not deleted:
            response['status'] = 'fail'
            response['message'] = 'Você não tem permissão para deletar este produto'
            return Response(response)
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
        
        product, updated = ShopDatabase.update_product(id, name, description, price, seller)
        response = product.to_json_dict()
        response['status'] = 'success' if updated else 'fail'
        return Response(response)


class ProductImageView(APIView):
    """
    Manages product images
    """

    def get(self, request, product_id):
        """
        Get product image
        """
        product = ShopDatabase.fetch_product_by_id(product_id)
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
        product = ShopDatabase.fetch_product_by_id(product_id)
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
        filtroiniciativa = body.get('filtroiniciativa')
        print(filtroiniciativa)
        products = ShopDatabase.fetch_products_by_name(name,filtroiniciativa)
        products_list = []
        for product in products:
            product_dict = product.to_json_dict()
            products_list.append(product_dict)
        return Response({'status': 'success', 'products': products_list})

    return Response({'status': 'fail'})


@api_view(['POST'])
def search_products_by_seller_and_name(request):
    if request.method == 'POST':
        s = request.body.decode('utf-8')
        json_acceptable_string = s.replace("'", "\"")
        body = json.loads(json_acceptable_string)
        seller = body.get('seller')
        name = body.get('name')
        products = ShopDatabase.fetch_products_by_seller_and_name(name, seller)
        products_list = []
        for product in products:
            product_dict = product.to_json_dict()
            products_list.append(product_dict)
        return Response({'status': 'success', 'products': products_list})

    return Response({'status': 'fail'})
