# views.py
from django.shortcuts import render, redirect
from django.db import connections, connection
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
    with connections['default'].cursor() as cursor:
        cursor.execute("SELECT id_utilizador, nome, email, data_nascimento, data_registo FROM view_utilizadores;")
        users = cursor.fetchall()

    context = {
        'users': users,  # Lista de utilizadores
    }

    return render(request, 'users.html', context)

def companies_view(request):
    with connections['default'].cursor() as cursor:
        cursor.execute("SELECT id_empresa, nome, email, local, telefone, data_registo FROM view_empresas;")
        companies = cursor.fetchall()

    context = {
        'companies': companies,  # Lista de empresas
    }

    return render(request, 'companies.html', context)

def speakers_view(request):
    return render(request, 'speakers.html')   # Renderiza a página speakers.html

def events_view(request):
    return render(request, 'events.html') # Renderiza a página events.html

def registeredevents_view(request):
    return render(request, 'registeredEvents.html') # Renderiza a página registeredevents.html

def event_details_view(request):
    return render(request, 'event_details.html') 

def edit_user_view(request, user_id):
    # Query para obter o utilizador específico
    with connection.cursor() as cursor:
        cursor.execute("SELECT id_utilizador, nome, email, data_nascimento, data_registo FROM view_utilizadores WHERE id_utilizador = %s", [user_id])
        user = cursor.fetchone()

    if request.method == 'POST':
        # Dados enviados pelo formulário
        nome = request.POST.get('nome')
        email = request.POST.get('email')
        data_nascimento = request.POST.get('data_nascimento')

        # Chamar o procedimento armazenado para atualizar os dados
        with connection.cursor() as cursor:
            cursor.execute("""
                CALL proc_update_utilizador(%s, %s, %s, %s)
            """, [user_id, nome, email, data_nascimento])

        return redirect('users')

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

def edit_company_view(request, company_id):
    # Query para obter a empresa específica
    with connection.cursor() as cursor:
        cursor.execute("SELECT id_empresa, nome, email, local, telefone, data_registo FROM view_empresas WHERE id_empresa = %s", [company_id])
        company = cursor.fetchone()

    if request.method == 'POST':
        # Dados enviados pelo formulário
        nome = request.POST.get('nome')
        email = request.POST.get('email')
        local = request.POST.get('local')
        telefone = request.POST.get('telefone')
        data_registo = request.POST.get('data_registo')

        # Chamar o procedimento armazenado para atualizar os dados
        with connection.cursor() as cursor:
            cursor.execute("""
                CALL proc_update_empresas(%s, %s, %s, %s, %s, %s)
            """, [company_id, nome, email, local, telefone, data_registo])

        return redirect('companies')

    # Passa os dados do utilizador para o template
    context = {
        'company': {
            'id': company[0],
            'nome': company[1],
            'email': company[2],
            'local': company[3],
            'telefone': company[4],
            'data_registo': company[5]
        }
    }
    return render(request, 'edit_company.html', context)

def edit_event_view(request):
    return render(request, 'edit_event.html') 

def edit_profile_view(request):
    return render(request, 'edit_profile.html') 

def create_event_view(request):
    return render(request, 'create_event.html') 