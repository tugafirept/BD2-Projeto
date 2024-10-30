# urls.py
from django.urls import path
from . import views

urlpatterns = [
    path('', views.login_view, name='login'),
    path('register/', views.register_view, name='register'),
    path('users/', views.users_view, name='users'),  # Rota para a página de utilizadores
    path('companies/', views.companies_view, name='companies'), # Rota para a página de empresas
    path('speakers/', views.speakers_view, name='speakers'), # Rota para a página de palestrantes
    path('events/', views.events_view, name='events'), # Rota para a página de eventos
    path('registeredEvents/', views.registeredevents_view, name='registeredEvents'), # Rota para a página de eventos
    path('event/', views.event_details_view, name='event_details'),  # Rota para a página de detalhes do evento
]
