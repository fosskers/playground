import datetime
from django.test import TestCase
from django.utils import timezone
from polls.models import Question
from django.core.urlresolvers import reverse

# --- #


def create_question(text, days):
    """Dynamically creates a question."""
    time = timezone.now() + datetime.timedelta(days=days)
    return Question.objects.create(q_text=text, pub_date=time)


class QuestionViewTests(TestCase):
    def test_index_view_with_past_questions(self):
        """Old Questions should be displayed."""
        create_question(text="Past question.", days=-30)
        response = self.client.get(reverse('polls:index'))
        self.assertQuerysetEqual(
            response.context['latest'],
            ['<Question: Past question.>']
        )


class QuestionMethodTests(TestCase):
    def test_future_question(self):
        """`published_recently` should return False for dates in
        the future."""
        time = timezone.now() + datetime.timedelta(days=30)
        future_q = Question(pub_date=time)
        self.assertFalse(future_q.published_recently())

    def test_published_recently_usual_case(self):
        """Should be True if Question was published in the last day."""
        q = Question(pub_date=timezone.now())
        self.assertTrue(q.published_recently())

    def test_published_recently_usual_case2(self):
        """Should be False if published more than a day ago."""
        time = timezone.now() - datetime.timedelta(days=30)
        q = Question(pub_date=time)
        self.assertFalse(q.published_recently())
