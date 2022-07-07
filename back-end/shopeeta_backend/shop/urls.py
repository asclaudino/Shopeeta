from django.urls import path

from . import views

urlpatterns = [
    path("search_products/", views.search_products_by_name),
    path("get_sellers_products/", views.search_products_by_seller_and_name),
    path("product/", views.ProductView.as_view()),
    path("product_image/<int:product_id>/", views.ProductImageView.as_view()),
    path("product/<int:product_id>/comment/", views.CommentView.as_view()),
]