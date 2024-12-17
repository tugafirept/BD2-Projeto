from django.db import connections

def ins_empresa(name, email, password, local=None, telefone=None):
    cur = connections['default'].cursor()
    cur.execute(
        "CALL insert_empresa(%s, %s, %s, %s, %s);",
        (name, email, password, local, telefone)
    )
    connections['default'].commit()
    cur.close()

def ins_utilizador(name, email, password, data_nascimento=None):
    cur = connections['default'].cursor()
    cur.execute(
        "CALL insert_utilizador(%s, %s, %s, %s);",
        (name, email, password, data_nascimento)
    )
    connections['default'].commit()
    cur.close()


def del_utilizador(id_utilizador):
    cur = connections['default'].cursor()
    cur.execute(
        "CALL proc_delete_utilizador(%s);",
        [id_utilizador]
    )
    connections['default'].commit()
    cur.close()

def delete_event(event_id):
    cur = connections['default'].cursor()
    cur.execute(
        "CALL proc_delete_evento(%s);",
        [event_id]
    )
    connections['default'].commit()
    cur.close()

def delete_palestrante(id_utilizador):
    cur = connections['default'].cursor()
    cur.execute(
        "CALL proc_delete_palestrante(%s);",
        [id_utilizador]
    )
    connections['default'].commit()
    cur.close()

def delete_empresa(id_empresa):
    cur = connections['default'].cursor()
    cur.execute(
        "CALL proc_delete_empresa(%s);",
        [id_empresa]
    )
    connections['default'].commit()
    cur.close()

def ins_evento(id_empresa, id_utilizador, nome, data, local, telefone, descricao, preco_inscricao, preco_total_evento):
    cur = connections['default'].cursor()
    
    cur.execute(
        """
        CALL insert_evento(%s, %s, %s, %s, %s, %s, %s, %s, %s);
        """,
        (id_empresa, id_utilizador, nome, data, local, telefone, descricao, preco_inscricao, preco_total_evento)
    )
    connections['default'].commit()
    cur.close()

def delete_inscricao(id_inscr):
    cur = connections['default'].cursor()
    cur.execute(
        "CALL proc_delete_inscricao(%s);",
        [id_inscr]
    )
    connections['default'].commit()
    cur.close()

