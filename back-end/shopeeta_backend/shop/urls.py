from django.urls import path

from . import views

urlpatterns = [
    path("register_product/", views.register_product),
    path("register_product_image/<int:product_id>/", views.register_product_image),
    path("get_product_image/<int:product_id>/", views.get_product_image),
    path("update_product/", views.update_product),
    path("delete_product/", views.delete_product),
    path("get_latest_products/", views.get_latest_products),
    path("search_products/", views.search_products_by_name),
    path("get_sellers_products/", views.search_products_by_seller),
]