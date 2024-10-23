# views.py
from django.shortcuts import render

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
