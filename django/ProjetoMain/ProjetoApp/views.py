# views.py
from django.shortcuts import render, redirect
from django.db import connections
from .forms import RegistoForm
from .basededados import ins_empresa, ins_utilizador

def login_view(request):
    return render(request, 'login.html')  # Renderiza a página de login

def register_user(request):
    if request.method == 'POST':
        form = RegistoForm(request.POST)
        if form.is_valid():
            role = form.cleaned_data['role']
            name = form.cleaned_data['name']
            email = form.cleaned_data['email']
            password = form.cleaned_data['password']
            birthdate = form.cleaned_data.get('birthdate')
            local = form.cleaned_data.get('local')
            phone = form.cleaned_data.get('phone')

            if role == 'empresa':
                ins_empresa(name, email, password, local, phone)
            elif role == 'individual':
                ins_utilizador(name, email, password, birthdate)

            return redirect('login')  # Redireciona para a página inicial após o registo
    else:
        form = RegistoForm()

    context = {
        'form': form,
    }
    return render(request, 'Register.html', context)  # Renderiza a página de registo

def users_view(request):
    # Abrir conexão ao banco
    with connections['default'].cursor() as cursor:
        # Query direta para a view SQL
        cursor.execute("SELECT id_utilizador, nome, email, data_nascimento, data_registo FROM view_utilizadores;")
        # Obter todos os resultados
        users = cursor.fetchall()

    # Contexto para enviar os dados para o template
    context = {
        'users': users,  # Lista de utilizadores
    }

    return render(request, 'users.html', context)

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

def edit_user_view(request, user_id):
    # Query SQL para obter o utilizador específico
    with connection.cursor() as cursor:
        cursor.execute("SELECT Id_utilizador, Nome, Email, Data_Nascimento, Data_Registo FROM view_utilizadores WHERE Id_utilizador = %s", [user_id])
        user = cursor.fetchone()

    if not user:
        return render(request, '404.html', status=404)  # Renderiza uma página 404 se o utilizador não existir

    if request.method == 'POST':
        # Lógica para atualizar os dados do utilizador usando SQL
        nome = request.POST.get('nome')
        email = request.POST.get('email')
        data_nascimento = request.POST.get('data_nascimento')
        # Realizar atualização no banco se necessário
        with connection.cursor() as cursor:
            cursor.execute("""
                UPDATE Utilizadores
                SET Nome = %s, Email = %s, Data_Nascimento = %s
                WHERE Id_utilizador = %s
            """, [nome, email, data_nascimento, user_id])

        return render(request, 'success.html')  # Redireciona para uma página de sucesso ou lista de utilizadores

    # Passa os dados do utilizador para o template
    context = {
        'user': {
            'id': user[0],
            'nome': user[1],
            'email': user[2],
            'data_nascimento': user[3],
            'data_registo': user[4],
        }
    }
    return render(request, 'edit_user.html', context)


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