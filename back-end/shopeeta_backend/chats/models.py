from django.db import models

# Create your models here.


class Chat(models.Model):
    seller = models.ForeignKey('userbase.User', on_delete=models.CASCADE, related_name='seller')
    buyer = models.ForeignKey('userbase.User', on_delete=models.CASCADE, related_name='buyer')
    is_closed = models.BooleanField(default=False)
    
class Message(models.Model):
    chat = models.ForeignKey('Chat', on_delete=models.CASCADE)
    sender = models.ForeignKey('userbase.User', on_delete=models.CASCADE, related_name='sender')
    receiver = models.ForeignKey('userbase.User', on_delete=models.CASCADE, related_name='receiver')
    text = models.TextField()
    time = models.DateTimeField(auto_now_add=True)
    
    def __str__(self) -> str:
        return self.text