from django.db import models

# Create your models here.

class Product(models.Model):
    name = models.CharField(max_length=100)
    description = models.TextField()
    price = models.FloatField()
    seller = models.ForeignKey('userbase.User', on_delete=models.CASCADE)
    image = models.FileField(upload_to='product_images', blank=True, null=True, default=None)

    def __str__(self):
        return self.name