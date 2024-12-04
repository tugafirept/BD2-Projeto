# urls.py
from django.urls import path
from . import views

urlpatterns = [
    path('', views.login_view, name='login'),
    path('register/', views.register_user, name='register_user'),
    path('users/', views.users_view, name='users'),  # Rota para a página de utilizadores
    path('companies/', views.companies_view, name='companies'), # Rota para a página de empresas
    path('speakers/', views.speakers_view, name='speakers'), # Rota para a página de palestrantes
    path('events/', views.events_view, name='events'), # Rota para a página de eventos
    path('registeredEvents/', views.registeredevents_view, name='registeredEvents'), # Rota para a página de eventos
    path('event/', views.event_details_view, name='event_details'),  # Rota para a página de detalhes do evento

    path('editUser/<int:user_id>/', views.edit_user_view, name='edit_user'),  # Rota para a página de editar utilizador
    path('editSpeaker/', views.edit_speaker_view, name='edit_speaker'),  # Rota para a página de editar palestrante
    path('editCompany/<int:company_id>/', views.edit_company_view, name='edit_company'),  # Rota para a página de editar empresa
    path('editEvent/', views.edit_event_view, name='edit_event'),  # Rota para a página de editar evento
    path('editProfile/', views.edit_profile_view, name='edit_profile'),  # Rota para a página de editar perfil

    path('createEvent/', views.create_event_view, name='create_event'),  # Rota para a página de criar evento
    
]
