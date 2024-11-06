# views.py
from django.shortcuts import render

def login_view(request):
    return render(request, 'login.html')  # Renderiza a página de login

def register_view(request):
    return render(request, 'register.html')  # Renderiza a página de registro

def users_view(request):
    return render(request, 'users.html')  # Renderiza a página users.html

def companies_view(request):
    return render(request, 'companies.html')  # Renderiza a página companies.html

def speakers_view(request):
    return render(request, 'speakers.html')   # Renderiza a página speakers.html

def events_view(request):
    return render(request, 'events.html') # Renderiza a página events.html

def registeredevents_view(request):
    return render(request, 'registeredEvents.html') # Renderiza a página registeredevents.html

def event_details_view(request):
    return render(request, 'event_details.html') 

def edit_user_view(request):
    return render(request, 'edit_user.html') 

def edit_speaker_view(request):
    return render(request, 'edit_speaker.html') 

def edit_company_view(request):
    return render(request, 'edit_company.html') 

def edit_event_view(request):
    return render(request, 'edit_event.html') 

def edit_profile_view(request):
    return render(request, 'edit_profile.html') 

def create_event_view(request):
    return render(request, 'create_event.html') 