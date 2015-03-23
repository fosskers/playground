from django.core.urlresolvers import reverse
from django.http import HttpResponseRedirect
from django.shortcuts import render, get_object_or_404
from django.utils import timezone
from django.views import generic
from polls.models import Question, Choice

# --- #


class IndexView(generic.ListView):
    template_name = 'polls/index.html'
    context_object_name = 'latest'

    def get_queryset(self):
        """Get last five published questions."""
        return Question.objects.filter(
            pub_date__lte=timezone.now()
        ).order_by('-pub_date')[:5]


class DetailView(generic.DetailView):
    model = Question
    template_name = 'polls/detail.html'


class ResultsView(generic.DetailView):
    model = Question
    template_name = 'polls/results.html'


def vote(request, question_id):
    """Submit a vote to the DB. Notice the simple form validation."""
    q = get_object_or_404(Question, pk=question_id)
    try:
        selected = q.choice_set.get(pk=request.POST['choice'])
    except (KeyError, Choice.DoesNotExist):
        return render(request,
                      'polls/detail.html',
                      {'question': q,
                       'error_message': "You didn't select a choice."})
    else:
        selected.votes += 1
        selected.save()
        return HttpResponseRedirect(reverse('polls:results', args=(q.id,)))
