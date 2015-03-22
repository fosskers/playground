from django.http import HttpResponseRedirect
from django.shortcuts import render, get_object_or_404
from polls.models import Question, Choice
from django.core.urlresolvers import reverse

# --- #


def index(request):
    latest = Question.objects.order_by('-pub_date')[:5]
    # The means to give data to the templates
    context = {'latest': latest}
    return render(request, 'polls/index.html', context)


def detail(request, question_id):
    question = get_object_or_404(Question, pk=question_id)
    return render(request, 'polls/detail.html', {'question': question})


def results(request, question_id):
    question = get_object_or_404(Question, pk=question_id)
    return render(request, 'polls/results.html', {'question': question})


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
