from django.contrib import admin
from polls.models import Question

# --- #

class QuestionAdmin(admin.ModelAdmin):
    fieldsets = [ ('Date Information',{'fields': ['pub_date']}),
                  (None,              {'fields': ['q_text']})]
                  
admin.site.register(Question,QuestionAdmin)
