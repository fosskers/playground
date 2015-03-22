from django.db import models
from django.utils import timezone

import datetime

# --- #

# The follow query is an example of Django's `__` field lookup pattern.
#   Choice.objects.filter(question__q_text__startswith='This')
class Question(models.Model):
    q_text   = models.CharField('question text', max_length = 200)
    asker    = models.CharField(max_length = 20, default="colin")
    pub_date = models.DateTimeField('date published')

    def __unicode__(self):
        return self.q_text

    def published_recently(self):
        return self.pub_date >= timezone.now() - datetime.timedelta(days=1)

class Choice(models.Model):
    question = models.ForeignKey(Question)
    c_text   = models.CharField(max_length = 200)
    votes    = models.IntegerField(default = 0)

    def __unicode__(self):
        return self.c_text
