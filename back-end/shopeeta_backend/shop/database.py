from userbase.database import UserDatabase
from shop.models import Product

class ShopDatabase:
    @staticmethod
    def fetch_all_products():
        products = Product.objects.all()
        products.order_by('-id')
        return products

    @staticmethod
    def fetch_product_by_id(product_id):
        product = Product.objects.get(id=product_id)
        return product
    
    @staticmethod
    def create_product(name, description, price, seller_username):
        seller = UserDatabase.fetch_user_by_username(seller_username)
        product = Product(name=name, description=description,
                          price=price, seller=seller)
        product.image = None
        product.save()
        return product

    @staticmethod
    def delete_product(product_id, username):
        product = Product.objects.get(id=product_id)
        if product.seller.username != username:
            return False
        product.delete()
        return True

    @staticmethod
    def update_product(product_id, name, description, price, username):
        product = Product.objects.get(id=product_id)
        if product.seller.username != username:
            return product, False
        product.name = name
        product.description = description
        product.price = price
        product.save()
        return product, True


    @staticmethod
    def fetch_products_by_name(name, filtroiniciativa):
        # print(filtroiniciativa)
        if(filtroiniciativa == '0'):
            print('entrei no if')
            products = Product.objects.filter(name__contains=name)
        else:
            print('entrei no else')
            products = Product.objects.filter(name__contains=name, seller__is_iniciativa=True)
        
        return products
    
    @staticmethod
    def fetch_products_by_seller_and_name(name, seller_username):
        products = Product.objects.filter(name__contains=name, seller__username=seller_username)
        return products