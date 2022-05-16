from django.db import models

# Create your models here.

class Product(models.Model):
    name = models.CharField(max_length=100)
    description = models.TextField()
    price = models.FloatField()
    seller = models.ForeignKey('userbase.User', on_delete=models.CASCADE)

    def __str__(self):
        return self.name