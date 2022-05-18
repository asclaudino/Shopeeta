from django.db import models

# Create your models here.


class User(models.Model):
    username = models.CharField(max_length=20)
    password = models.CharField(max_length=20)
    email = models.EmailField()
    is_iniciativa = models.BooleanField(default=False)

    def __str__(self):
        return self.username

