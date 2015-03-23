from django.contrib import admin
from polls.models import Question, Choice

# --- #

class ChoiceInline(admin.TabularInline ):
    model = Choice
    extra = 3

class QuestionAdmin(admin.ModelAdmin):
    fieldsets = [ (None,              {'fields': ['q_text']}),
                  ('Date Information',{'fields': ['pub_date'],
                                       'classes': ['collapse']})]
    inlines = [ChoiceInline]
    list_display = ('q_text','pub_date', 'published_recently')
    list_filter = ['pub_date']
    search_fields = ['q_text']
                  
admin.site.register(Question,QuestionAdmin)