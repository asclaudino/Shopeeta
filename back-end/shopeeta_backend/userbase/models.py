from django.db import models

# Create your models here.


class User(models.Model):
    username = models.CharField(max_length=20)
    password_hash = models.CharField(max_length=64)
    email = models.EmailField()
    is_iniciativa = models.BooleanField(default=False)

    token = models.CharField(max_length=32, default=None, null=True)
    last_time_login = models.DateTimeField(auto_now=True)

    def __str__(self):
        return self.username

