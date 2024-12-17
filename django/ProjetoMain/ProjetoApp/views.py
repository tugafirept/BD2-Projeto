# views.py
from django.shortcuts import render, redirect
from django.db import connections, connection
from .forms import RegistoForm
from .basededados import ins_empresa, ins_utilizador, del_utilizador,delete_event,delete_palestrante,delete_empresa,ins_evento,delete_inscricao
from django.contrib import messages
from django.contrib.auth import logout

def logout_view(request):
    logout(request)
    return redirect('login')

def login_view(request):
    if request.method == 'POST':
        email = request.POST.get('email')
        password = request.POST.get('password')

        # Chama a função de login do banco de dados
        with connection.cursor() as cursor:
            cursor.execute("""
                SELECT * FROM login(%s, %s);
            """, [email, password])

            result = cursor.fetchone()

        if result:
            id, tipo = result
            if id:
                request.session['id'] = id
                request.session['tipo'] = tipo

                # Redireciona conforme o tipo de usuário
                if tipo == 'empresa':
                    return redirect('events')
                elif tipo == 'administrador':
                    return redirect('users')
                elif tipo == 'palestrante':
                    return redirect('events')
                else:
                    return redirect('events') 
            else:
                messages.error(request, "Email ou password inválidos.")
        else:
            messages.error(request, "Email ou password inválidos.")

    return render(request, 'login.html')

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

            # Registar de acordo com o papel (empresa ou individual)
            if role == 'empresa':
                ins_empresa(name, email, password, local, phone)
            elif role == 'individual':
                ins_utilizador(name, email, password, birthdate)

            return redirect('login')  # Redireciona para a página de login após registo
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

def delete_user_view(request, user_id):
    try:
        del_utilizador(user_id)  # Chama a função para eliminar utilizador
        messages.success(request, "Utilizador eliminado com sucesso!")
    except Exception as e:
        messages.error(request, f"Erro ao eliminar utilizador: {str(e)}")
    
    return redirect('users') 

def delete_palestrante_view(request, palestrante_id):
    try:
        delete_palestrante(palestrante_id)  # Chama a função para eliminar palestrante
        messages.success(request, "Palestrante eliminado com sucesso!")
    except Exception as e:
        messages.error(request, f"Erro ao eliminar palestrante: {str(e)}")
    
    return redirect('speakers') 

def companies_view(request):
    with connections['default'].cursor() as cursor:
        cursor.execute("SELECT id_empresa, nome, email, local, telefone, data_registo FROM view_empresas;")
        companies = cursor.fetchall()

    context = {
        'companies': companies,  # Lista de empresas
    }

    return render(request, 'companies.html', context)

def delete_empresa_view(request, empresa_id):
    try:
        delete_empresa(empresa_id)  # Chama a função para eliminar empresa
        messages.success(request, "Empresa eliminada com sucesso!")
    except Exception as e:
        messages.error(request, f"Erro ao eliminar empresa: {str(e)}")
    
    return redirect('companies') 

def speakers_view(request):
    # Abrir conexão ao banco
    with connections['default'].cursor() as cursor:
        # Query direta para a view SQL
        cursor.execute("SELECT id_utilizador, nome, email, data_nascimento, data_registo, custopalestrante, dataficoupalestrante FROM view_palestrantes;")
        # Obter todos os resultados
        users = cursor.fetchall()

    user_type = request.session.get('tipo')
    # Contexto para enviar os dados para o template
    context = {
        'users': users, # Lista de utilizadores
        'user_type': user_type
    }

    return render(request, 'speakers.html', context) # Renderiza a página speakers.html

def events_view(request):
    user_type = request.session.get('tipo') 
    user_id = request.session.get('id')

    with connections['default'].cursor() as cursor:
        if user_type == 'empresa':
            # Se for empresa, mostra apenas os eventos dessa empresa
            cursor.execute("""
                SELECT id_evento, EventoNome, empresanome, data, local, precoinscricao 
                FROM view_eventos
                WHERE id_empresa = %s;
            """, [user_id])
        else:
            # Caso contrário, mostra todos os eventos
            cursor.execute("""
                SELECT id_evento, EventoNome, empresanome, data, local, precoinscricao 
                FROM view_eventos;
            """)

        events = cursor.fetchall()

    context = {
        'events': events, 
    }

    # Renderiza a página events.html com o contexto
    return render(request, 'events.html', context)


def delete_event_view(request, event_id):
    try:
        delete_event(event_id)  # Chama a função para eliminar evento
        messages.success(request, "Evento eliminado com sucesso!")
    except Exception as e:
        messages.error(request, f"Erro ao eliminar utilizador: {str(e)}")
    
    return redirect('events') 

def registeredevents_view(request):
    # Verifique se o id_utilizador está presente na sessão
    user_id = request.session.get('id')
    
    # Se o ID do usuário não estiver presente, talvez seja necessário redirecionar ou mostrar uma mensagem de erro
    if not user_id:
        return render(request, 'error.html', {'message': 'Usuário não autenticado ou ID não encontrado na sessão.'})

    # Consultar os eventos inscritos na view 'view_eventos_inscritos'
    with connection.cursor() as cursor:
        cursor.execute("""
            SELECT EventoNome, EmpresaNome, Data, Local, PrecoInscricao, Id_Evento, id_inscricao
            FROM view_eventos_inscritos 
            WHERE id_utilizador = %s
        """, [user_id])
        
        # Obter todos os resultados
        eventos_inscritos = cursor.fetchall()

    # Passar os dados para o template
    return render(request, 'registeredEvents.html', {'eventos_inscritos': eventos_inscritos})

def event_details_view(request, event_id):
    with connection.cursor() as cursor:
        cursor.execute("""
            SELECT id_evento, id_empresa, id_utilizador, nome, data, local, telefone, descricao,
                   precoinscricao, precototalevento, data_criacao, nomeutilizador
            FROM view_eventos_detalhes
            WHERE id_evento = %s
        """, [event_id])
        event = cursor.fetchone()

        # Recuperar despesas associadas ao evento
        cursor.execute("""
            SELECT id_despesa, total, data, nome
            FROM view_despesas
            WHERE id_evento = %s
        """, [event_id])
        despesas = cursor.fetchall()

        # Recuperar pagamentos associados ao evento
        cursor.execute("""
            SELECT id_pagamento, total, data, nome
            FROM view_pagamentos
            WHERE id_evento = %s
        """, [event_id])
        pagamentos = cursor.fetchall()

    # Contexto para o template
    context = {
        "event": {
            "id": event[0],
            "id_empresa": event[1],
            "id_utilizador": event[2],
            "nome": event[3],
            "data": event[4],
            "local": event[5],
            "telefone": event[6],
            "descricao": event[7],
            "precoinscricao": event[8],
            "precototalevento": event[9],
            "data_criacao": event[10],
            "nomeutilizador": event[11],
        },
        "despesas": despesas,
        "pagamentos": pagamentos,
    }

    return render(request, "event_details.html", context) 

def edit_user_view(request, user_id):
    # Query para obter o utilizador específico
    with connection.cursor() as cursor:
        cursor.execute("SELECT Id_utilizador, Nome, Email, Data_Nascimento, Data_Registo FROM view_utilizadores WHERE Id_utilizador = %s", [user_id])
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


def edit_speaker_view(request,user_id):
    with connection.cursor() as cursor:
        cursor.execute("SELECT id_utilizador, nome, email, data_nascimento, data_registo, custopalestrante, dataficoupalestrante FROM view_palestrantes WHERE id_utilizador = %s", [user_id])
        user = cursor.fetchone()

    if request.method == 'POST':
        # Dados enviados pelo formulário
        nome = request.POST.get('nome')
        email = request.POST.get('email')
        data_nascimento = request.POST.get('data_nascimento')
        custopalestrante = request.POST.get('custopalestrante')

        # Chamar o procedimento armazenado para atualizar os dados
        with connection.cursor() as cursor:
            cursor.execute("""
                CALL proc_update_palestrante(%s, %s, %s, %s, %s)
            """, [user_id, nome, email, data_nascimento,custopalestrante])

        return redirect('speakers') # Redireciona para uma página de sucesso ou lista de utilizadores

    # Passa os dados do utilizador para o template
    context = {
        'user': {
            'id': user[0],
            'nome': user[1],
            'email': user[2],
            'data_nascimento': user[3],
            'data_registo': user[4],
            'custopalestrante': user[5],
            'dataficoupalestrante': user[6],
        }
    }
    return render(request, 'edit_speaker.html', context)

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
                CALL proc_update_empresas(%s, %s, %s, %s, %s)
            """, [company_id, nome, email, local, telefone])

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

def edit_event_view(request, event_id):
    with connection.cursor() as cursor:
        # Buscar o evento específico
        cursor.execute("""
            SELECT id_evento, nome, data, local, telefone, descricao, precoinscricao, id_utilizador
            FROM view_eventos_detalhes
            WHERE id_evento = %s
        """, [event_id])
        event = cursor.fetchone()

        cursor.execute("SELECT id_utilizador, nome FROM view_palestrantes;")
        speakers = cursor.fetchall()

    if request.method == 'POST':
        nome = request.POST.get('nome')
        data = request.POST.get('data')
        local = request.POST.get('local')
        telefone = request.POST.get('telefone')
        descricao = request.POST.get('descricao')
        precoinscricao = request.POST.get('precoinscricao')
        id_utilizador = request.POST.get('palestrante')

        # Chamar o procedimento armazenado para atualizar os dados
        with connection.cursor() as cursor:
            cursor.execute("""
                CALL public.proc_update_eventos(%s, %s, %s, %s, %s, %s, %s, %s)
            """, [event_id, id_utilizador, nome, data, local, telefone, descricao, precoinscricao])

        return redirect('events')

    # Passa os dados do evento e os palestrantes para o template
    context = {
        'event': {
            'id': event[0],
            'nome': event[1],
            'data': event[2],
            'local': event[3],
            'telefone': event[4],
            'descricao': event[5],
            'precoinscricao': event[6],
            'id_utilizador': event[7] 
        },
        'speakers': speakers  # Todos os palestrantes disponíveis
    }

    return render(request, 'edit_event.html', context)

def edit_profile_view(request):
    user_id = request.session.get('id')
    user_type = request.session.get('tipo')

    # Inicializa as variáveis que vamos passar para o template
    user_data = {}
    palestrante_data = {}
    
    if request.method == 'POST':
        nome = request.POST.get('nome')
        email = request.POST.get('email')
        data_nascimento = request.POST.get('data_nascimento')
        palestrante = request.POST.get('palestrante')
        custo_palestrante = request.POST.get('custo_palestrante')

        # Atualiza os dados do utilizador
        with connections['default'].cursor() as cursor:
            # Atualiza os dados do utilizador (nome, email, data de nascimento)
            cursor.callproc('proc_update_utilizador', [user_id, nome, email, data_nascimento])

            # Verifica se o utilizador se tornou palestrante ou deixou de ser
            if palestrante == 'sim':
                # Se já for palestrante, atualiza o custo
                if user_type == 'palestrante':
                    cursor.callproc('proc_update_palestrante', [user_id, nome, email, data_nascimento, float(custo_palestrante)])
                else:
                    # Se não for palestrante, insere o utilizador na tabela de palestrantes
                    cursor.callproc('insert_palestrante', [user_id, float(custo_palestrante) if custo_palestrante else 0])
            
            elif palestrante == 'nao' and user_type == 'palestrante':
                # Se o utilizador está a deixar de ser palestrante, exclui da tabela Palestrantes
                cursor.callproc('proc_delete_palestrante', [user_id])

        # Redireciona para o perfil após a atualização
        return redirect('edit_profile')

    # Consulta os dados do utilizador
    with connections['default'].cursor() as cursor:
        if user_type in ['utilizador', 'administrador', 'palestrante']:
            cursor.execute("""
                SELECT nome, email, data_nascimento
                FROM view_utilizadores
                WHERE id_utilizador = %s;
            """, [user_id])
            user_data = cursor.fetchone()

        if user_type == 'palestrante':
            cursor.execute("""
                SELECT custopalestrante
                FROM palestrantes
                WHERE id_utilizador = %s;
            """, [user_id])
            palestrante_data = cursor.fetchone()

    context = {
        'user_data': user_data,
        'user_id': user_id,
        'user_type': user_type,
        'palestrante_data': palestrante_data,
    }

    return render(request, 'edit_profile.html', context)


def create_event_view(request):
    with connection.cursor() as cursor:
        # Buscar todos os palestrantes disponíveis
        cursor.execute("SELECT id_utilizador, nome FROM view_palestrantes;")
        speakers = cursor.fetchall()

    if request.method == 'POST':
        # Obtém os dados enviados pelo formulário
        nome = request.POST.get('nome')
        data = request.POST.get('data')
        local = request.POST.get('local')
        telefone = request.POST.get('telefone')
        descricao = request.POST.get('descricao')
        preco_inscricao = float(request.POST.get('preco_inscricao'))
        palestrante_id = request.POST.get('palestrante')

        id_empresa = request.session.get('id')

        try:
            # Chama a função para inserir o evento
            ins_evento(
                id_empresa=id_empresa,
                id_utilizador=palestrante_id,  # Associa o palestrante selecionado ao evento
                nome=nome,
                data=data,
                local=local,
                telefone=telefone,
                descricao=descricao,
                preco_inscricao=preco_inscricao,
                preco_total_evento=0  
            )
            messages.success(request, "Evento criado com sucesso!")
            return redirect('events')  # Redireciona para a lista de eventos

        except Exception as e:
            messages.error(request, f"Erro ao criar evento: {str(e)}")

    # Renderiza o formulário de criação e passa a lista de palestrantes
    return render(request, 'create_event.html', {'speakers': speakers})


def register_event(request, event_id):
    if request.method == "POST":
        user_id = request.session.get('id')
        evento_id = event_id 

        # Chamar o procedimento insert_inscricao
        with connection.cursor() as cursor:
            cursor.execute("""
                CALL public.insert_inscricao(%s, %s);
            """, [evento_id, user_id])

        # Adicionar uma mensagem de sucesso para o usuário
        messages.success(request, "Inscrição realizada com sucesso!")

        return redirect('events')  # Redirecionar de volta para a lista de eventos

    return redirect('events')  # Redirecionar de volta caso o método não seja POST

def palestrante_events_view(request):
    with connection.cursor() as cursor:
        cursor.execute("""
            SELECT EventoNome, EmpresaNome, Data, Local, PrecoInscricao, Id_Evento 
            FROM view_eventos_inscritos_palestrantes 
            WHERE id_utilizador = %s
        """, [request.session.get('id')])
        
        eventos_palestrante = cursor.fetchall()
        
        # Passar os dados para o template
        return render(request, 'lectures.html', {'eventos_palestrante': eventos_palestrante})
    
def cancelar_inscricao(request, id_inscricao):
    try:
        delete_inscricao(id_inscricao)  # Chama a função que executa a procedure
        messages.success(request, "Inscrição cancelada com sucesso!")
    except Exception as e:
        messages.error(request, f"Ocorreu um erro ao tentar cancelar a inscrição: {e}")

    return redirect('registeredEvents')
    

