# urls.py
from django.urls import path
from . import views

urlpatterns = [
    path('users/', views.users_view, name='users'),  # Rota para a página de utilizadores
    path('companies/', views.companies_view, name='companies'), # Rota para a página de empresas
    path('speakers/', views.speakers_view, name='speakers'), # Rota para a página de palestrantes
    path('events/', views.events_view, name='events'), # Rota para a página de eventos
    path('registeredEvents/', views.registeredevents_view, name='registeredEvents'), # Rota para a página de eventos
]
